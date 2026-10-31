"""Nintendo DS. Two CPUs: the ARM9 runs the game, the ARM7 handles sound, touch and wifi. Code is a mix of
ARM and Thumb. Much of a game's code sits in overlays: chunks loaded into the same RAM area at different times,
so overlay functions are shown with their overlay number (ov03:021A0000).
Addresses inside the tool: (region << 32) | address, where region 0 is the ARM9 program, 1 the ARM7, 2+ overlays."""
from .. import progress as PG
import re, struct
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM, CS_MODE_THUMB
from . import gba_plain

NAME = 'Nintendo DS'
KEY = 'nds'
EXTS = ('.nds', '.srl', '.dsi')
BUS = 'DS'
CPU = 'ARM946E-S + ARM7TDMI (ARM and Thumb)'

def detect(path, head):
    if path.lower().endswith(EXTS): return True
    return len(head) > 0x160 and head[0x15C:0x15E] == b'\x56\xCF' and struct.unpack_from('<I', head, 0x20)[0] >= 0x4000

# ---- RetroAchievements: main RAM 0x02000000 (4 MB, mirrored up to 0x02FFFFFF) at 0 ----
def ra(v):
    if 0x02000000 <= v < 0x03000000: return (v - 0x02000000) & 0x3FFFFF
    return None
def bus(r): return 0x02000000 + r if r < 0x400000 else r
def mem_region(r): return 'Main RAM' if r < 0x400000 else ('Data TCM (RA)' if 0x1000000 <= r < 0x1004000 else '')
RA_RANGES = [(0x02000000, 0x02400000, 0)]

# ---------------- BLZ (the DS "backwards LZ" used for compressed ARM9 programs and overlays) ----------------
def blz_decompress(pak):
    if len(pak) < 8: return pak
    inc_len = struct.unpack_from('<I', pak, len(pak) - 4)[0]
    if inc_len == 0: return pak
    hdr_len = pak[len(pak) - 5]
    enc_len = struct.unpack_from('<I', pak, len(pak) - 8)[0] & 0xFFFFFF
    dec_len = len(pak) - enc_len
    pak_len = enc_len - hdr_len
    raw_len = dec_len + enc_len + inc_len
    src = pak[dec_len:dec_len + pak_len][::-1]
    target = raw_len - dec_len
    out = bytearray(); i = 0
    while len(out) < target and i < len(src):
        flags = src[i]; i += 1
        for _ in range(8):
            if len(out) >= target or i >= len(src): break
            if flags & 0x80:
                if i + 1 >= len(src): break
                v = src[i] << 8 | src[i + 1]; i += 2
                ln = (v >> 12) + 3; pos = (v & 0xFFF) + 3
                for _ in range(ln):
                    out.append(out[-pos] if pos <= len(out) else 0)
            else:
                out.append(src[i]); i += 1
            flags = (flags << 1) & 0xFF
    out = out[:target]
    return bytes(pak[:dec_len]) + bytes(out[::-1])

def arm9_module_params(arm9, ram):
    """NitroSDK puts a small table in the ARM9 program ending with 0x2106C0DE 0xDEC00621. Returns its fields or None."""
    i = arm9.find(b'\x21\x06\xC0\xDE\xDE\xC0\x06\x21')
    if i < 0x1C: return None
    f = struct.unpack_from('<7I', arm9, i - 0x1C)
    return {'autoload_list': f[0], 'autoload_list_end': f[1], 'autoload_start': f[2], 'bss_start': f[3], 'bss_end': f[4],
            'compressed_end': f[5], 'sdk': f[6], 'at': i - 0x1C}

class Image:
    def __init__(self, path):
        R = open(path, 'rb').read(); self.rom = R
        self.title = R[0:12].split(b'\x00')[0].decode('latin1').strip()
        self.code = R[0x0C:0x10].decode('latin1')
        a9o, a9e, a9r, a9s, a7o, a7e, a7r, a7s = struct.unpack_from('<8I', R, 0x20)
        fnto, fnts, fato, fats, o9o, o9s, o7o, o7s = struct.unpack_from('<8I', R, 0x40)
        regions = []   # (name, ram address, bytes, default mode)
        arm9 = R[a9o:a9o + a9s]
        mp = arm9_module_params(arm9, a9r)
        self.arm9_compressed = False
        if mp and mp['compressed_end']:
            end = mp['compressed_end'] - a9r
            if 0 < end <= len(arm9):
                arm9 = blz_decompress(arm9[:end]) + arm9[end:]; self.arm9_compressed = True
        regions.append(('arm9', a9r, arm9, a9e))
        regions.append(('arm7', a7r, R[a7o:a7o + a7s], a7e))
        fat = [struct.unpack_from('<II', R, fato + 8 * i) for i in range(fats // 8)] if fats else []
        self.overlays = []
        for k in range(o9s // 32):
            ov_id, ram_addr, ram_size, bss, sinit_s, sinit_e, file_id, flags = struct.unpack_from('<8I', R, o9o + 32 * k)
            if file_id >= len(fat): continue
            s, e = fat[file_id]; data = R[s:e]
            if flags & 0x01000000: data = blz_decompress(data)
            self.overlays.append({'id': ov_id, 'ram': ram_addr, 'sinit': (sinit_s, sinit_e)})
            regions.append((f'ov{ov_id:02d}', ram_addr, data, None))
        self.region_names = [r[0] for r in regions]
        self.entries = {0: a9e, 1: a7e}
        # lay all regions end to end in one buffer; off() maps (region<<32 | address) into it
        self.data = b''; self.reg = []
        for idx, (n, ram, b, _) in enumerate(regions):
            self.reg.append((idx, ram, len(self.data), len(b))); self.data += b
        self.base = 0
        self.info = f'{self.title} [{self.code}] (DS)'
    def off(self, enc):
        r, a = enc >> 32, enc & 0xFFFFFFFF
        if r >= len(self.reg): return None
        _, ram, o, n = self.reg[r]
        return o + a - ram if ram <= a < ram + n else None
    def region_of(self, a, prefer):
        """Which region holds address a, preferring the caller's own region (overlays share addresses)."""
        if self.off((prefer << 32) | a) is not None: return prefer
        if self.off(a) is not None: return 0
        for idx, ram, o, n in self.reg:
            if idx >= 2 and ram <= a < ram + n: return idx
        return None

def load(path): return Image(path)
def seed_key(img): return 'nds_' + img.code
def fmt(enc):
    r = enc >> 32
    return f'{_NAMES[r] if r < len(_NAMES) else r}:{enc & 0xFFFFFFFF:08X}' if r else f'{enc:08X}'
_NAMES = ['arm9', 'arm7'] + [f'ov{i:02d}' for i in range(512)]
def sub_name(enc):
    r = enc >> 32
    return f'sub_{enc:08X}' if r == 0 else f'sub_{_NAMES[r]}_{enc & 0xFFFFFFFF:08X}'

def _is_push_thumb(hw): return (hw & 0xFE00) == 0xB400 and hw & 0x100      # push {..., lr}
def _is_push_arm(w): return (w & 0xFFFF4000) == 0xE92D4000                  # stmdb sp!, {..., lr}

def analyze(img):
    D = img.data
    def u16(enc):
        o = img.off(enc); return struct.unpack_from('<H', D, o)[0] if o is not None and o + 2 <= len(D) else None
    def u32(enc):
        o = img.off(enc); return struct.unpack_from('<I', D, o)[0] if o is not None and o + 4 <= len(D) else None
    PG.say(f'Following ARM and Thumb code in the ARM9, ARM7 and {len(img.reg) - 2} overlay{"s" if len(img.reg) != 3 else ""}…')
    starts = {}   # enc -> 'arm' | 'thumb'
    for r, e in img.entries.items():
        if e: starts[(r << 32) | e] = 'arm'
    # function pointers in each region: odd = Thumb, even with an ARM prologue = ARM
    for idx, ram, o, n in img.reg:
        for i in range(0, n - 3, 4):
            v = struct.unpack_from('<I', D, o + i)[0]
            rr = img.region_of(v & ~1, idx)
            if rr is None: continue
            enc = (rr << 32) | (v & ~1)
            if v & 1:
                hw = u16(enc)
                if hw is not None and _is_push_thumb(hw): starts.setdefault(enc, 'thumb')
            elif v & 3 == 0:
                w = u32(enc)
                if w is not None and _is_push_arm(w): starts.setdefault(enc, 'arm')
    for ov in img.overlays:   # static initialisers listed by each overlay
        s, e = ov['sinit']; ridx = 2 + img.overlays.index(ov)
        for a in range(s, e, 4):
            v = u32((ridx << 32) | a)
            if v: starts.setdefault((ridx << 32) | (v & ~1), 'thumb' if v & 1 else 'arm')
    mds = {'arm': Cs(CS_ARCH_ARM, CS_MODE_ARM), 'thumb': Cs(CS_ARCH_ARM, CS_MODE_THUMB)}
    for m in mds.values(): m.skipdata = True
    funcs = {}; calls = {}
    todo = sorted(starts); seen = set()
    while todo:
        s = todo.pop()
        if s in seen: continue
        seen.add(s); mode = starts.get(s, 'arm'); region = s >> 32; a0 = s & 0xFFFFFFFF
        o = img.off(s)
        if o is None: continue
        _, ram, ro, rn = img.reg[region]
        stop = min(ro + rn, o + 0x4000)
        ins, refs, callees = [], [], set(); far = 0; zeros = 0
        step = 4 if mode == 'arm' else 2
        for x in mds[mode].disasm(D[o:stop], a0):
            mn = x.mnemonic; t = f'{mn} {x.op_str}'.strip()
            line = {'a': (region << 32) | x.address, 't': t}
            m = re.match(r'ldr(?:b|h|sb|sh)? (r\d+), \[pc(?:, #(-?0x[0-9a-f]+|-?\d+))?\]', t)
            if m:
                imm = int(m.group(2), 0) if m.group(2) else 0
                la = (x.address + 8 + imm) if mode == 'arm' else (((x.address + 4) & ~3) + imm)
                v = u32((region << 32) | la) if mn == 'ldr' else None
                if v is not None:
                    line['lit'] = v; line['pool'] = la; rr = ra(v)
                    if rr is not None: refs.append({'ra': rr, 'at': line['a'], 'rw': 'ptr', 'reg': m.group(1)})
            if mn in ('bl', 'blx') and re.fullmatch(r'#0x[0-9a-f]+', x.op_str):
                tgt = int(x.op_str[1:], 16)
                tmode = mode if mn == 'bl' else ('thumb' if mode == 'arm' else 'arm')
                rr = img.region_of(tgt, region)
                if rr is not None:
                    enc = (rr << 32) | tgt; starts.setdefault(enc, tmode); line['call'] = enc; callees.add(enc)
                    calls.setdefault(enc, []).append(line['a'])
                    if enc not in seen: todo.append(enc)
            elif mn.startswith('b') and re.fullmatch(r'#0x[0-9a-f]+', x.op_str) and mn not in ('bic', 'bics'):
                tgt = int(x.op_str[1:], 16)
                if mn in ('b', 'b.w') and not (a0 <= tgt <= x.address + 0x800):
                    rr = img.region_of(tgt, region)
                    if rr is not None:
                        enc = (rr << 32) | tgt; starts.setdefault(enc, mode); line['call'] = enc; line['tail'] = True; callees.add(enc)
                        calls.setdefault(enc, []).append(line['a'])
                        if enc not in seen: todo.append(enc)
                else: far = max(far, tgt)
            ins.append(line)
            ret = t in ('bx lr', 'mov pc, lr') or (mn in ('pop', 'ldm', 'ldmia', 'ldmfd') and 'pc' in x.op_str) or line.get('tail')
            loop_back = mn in ('b', 'b.w') and re.fullmatch(r'#0x[0-9a-f]+', x.op_str) and int(x.op_str[1:], 16) <= x.address
            if (ret or loop_back) and far <= x.address: break
            zero = x.bytes == b'\x00' * len(x.bytes)
            zeros = zeros + 1 if zero else 0
            if zeros >= 4: ins = ins[:-4]; break
            if len(ins) > 2500: break
        # read or write for pointer loads (same idea as GBA)
        for rf in refs:
            reg = rf.pop('reg'); rw = set()
            k = next(i for i, l in enumerate(ins) if l['a'] == rf['at'])
            for l in ins[k + 1:k + 8]:
                tt = l['t']
                if f'[{reg}' in tt: rw.add('W' if tt.startswith('str') else 'R')
                elif tt.split(' ')[1:2] == [reg + ','] and not tt.startswith(('str', 'cmp', 'tst')): break
            rf['rw'] = ''.join(sorted(rw)) or 'ptr'
        funcs[s] = {'start': s, 'n': len(ins), 'ins': ins, 'refs': refs, 'callees': sorted(callees), 'mode': mode}
    for k, f in funcs.items():
        f['callers'] = sorted(set(calls.get(k, []))); f['ptrrefs'] = []
        if k in ((r << 32) | e for r, e in img.entries.items()):
            f['auto'] = ('ARM9_Entry' if k >> 32 == 0 else 'ARM7_Entry', 'Where this CPU starts running the game.')
    return funcs

def pool(f):
    out = set()
    for l in f['ins']:
        if 'pool' in l:
            base = l['a'] & ~0xFFFFFFFF; p = base | l['pool']; out.update((p, p + 2))
    return out

def find_text(img):
    """Text in the ARM9 program (much of a DS game's text lives in separate files on the ROM's file system)."""
    from .. import core
    idx, ram, o, n = img.reg[0]
    class Sub: pass
    sub = Sub(); sub.data = img.data[o:o + n]; sub.base = ram
    sub.off = lambda v: (v - ram) if ram <= v < ram + n else None
    return core.find_text(sub)

def ghidra_import(img, rom_path, work):
    """The ARM9 program (decompressed), loaded at its RAM address. Overlays aren't included."""
    from pathlib import Path
    idx, ram, o, n = img.reg[0]
    f = Path(work) / f'{img.code}.arm9.bin'; f.write_bytes(img.data[o:o + n])
    return {'file': str(f), 'thumb': 'per-start', 'region': 0,
            'args': ['-loader', 'BinaryLoader', '-loader-baseAddr', hex(ram), '-processor', 'ARM:LE:32:v5t']}

def translate(ins, lab, fname, pool_, tlook=lambda v: None, enums=None):
    """Shares the GBA (ARM/Thumb) translator. Branch targets in the text are plain addresses, so strip the
    region from the line addresses while translating, then put it back."""
    if not ins: return {}, {}
    hi = ins[0]['a'] & ~0xFFFFFFFF
    plain = [dict(l, a=l['a'] & 0xFFFFFFFF) for l in ins]
    out, L = gba_plain.translate(plain, lab, fname, {p & 0xFFFFFFFF for p in pool_}, tlook, enums, ra)
    return {hi | a: v for a, v in out.items()}, {hi | a: v for a, v in L.items()}

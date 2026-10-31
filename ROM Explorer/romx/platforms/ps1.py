"""PlayStation: code lives in the boot executable (PS-X EXE) on the disc, loaded into the 2 MB main RAM.
CPU is a MIPS R3000A (little endian). Branches and jumps have a delay slot: the next instruction runs first."""
from .. import progress as PG
import re, struct
from pathlib import Path
from capstone import Cs, CS_ARCH_MIPS, CS_MODE_MIPS32, CS_MODE_LITTLE_ENDIAN
from . import ps1_plain

NAME = 'PlayStation'
KEY = 'ps1'
EXTS = ('.cue', '.bin', '.iso', '.img', '.exe', '.psx')
BUS = 'PS1'
CPU = 'MIPS R3000A'

LOADS = {'lw', 'lh', 'lhu', 'lb', 'lbu', 'lwl', 'lwr', 'ld', 'lq', 'lwu', 'ldl', 'ldr', 'lwc1'}
STORES = {'sw', 'sh', 'sb', 'swl', 'swr', 'sd', 'sq', 'sdl', 'sdr', 'swc1'}
NO_DEST = STORES | {'jr', 'j', 'jalr', 'nop', 'syscall', 'break', 'mult', 'multu', 'div', 'divu', 'mthi', 'mtlo',
                    'mtc0', 'mtc2', 'ctc2', 'sync', 'b', 'bal', 'cop2', 'swc2', 'lwc2'}

def is_branch(mn):
    return mn in ('b', 'j', 'jal', 'jr', 'jalr', 'bal') or (mn.startswith('b') and mn not in ('break',))

# ---------- RetroAchievements addresses ----------
def ra(v):
    """PS1 bus address -> RA address. Main RAM (KSEG0 0x80.., KSEG1 0xA0..) at 0, scratchpad at 0x200000."""
    if (v >> 29) in (4, 5) and (v & 0x1FFFFFFF) < 0x200000: return v & 0x1FFFFF
    if 0x1F800000 <= v < 0x1F800400: return 0x200000 + v - 0x1F800000
    return None

def bus(r):
    return 0x80000000 + r if r < 0x200000 else 0x1F800000 + r - 0x200000

RA_RANGES = [(0x80000000, 0x80200000, 0), (0xA0000000, 0xA0200000, 0), (0x1F800000, 0x1F800400, 0x200000)]
def mem_region(r):
    return 'Main RAM' if r < 0x200000 else 'Scratchpad'

# ---------- disc reading ----------
class Disc:
    """Reads 2048-byte sectors from an .iso or a raw .bin (2352-byte sectors, Mode 1 or Mode 2)."""
    def __init__(self, path):
        self.f = open(path, 'rb')
        head = self.f.read(16)
        self.raw = head[:12] == b'\x00' + b'\xff' * 10 + b'\x00'
        if self.raw:
            self.size, self.off = 2352, (24 if head[15] == 2 else 16)
        else:
            self.size, self.off = 2048, 0
    def sector(self, n):
        self.f.seek(n * self.size + self.off); return self.f.read(2048)
    def read(self, lba, length):
        out = bytearray()
        for i in range((length + 2047) // 2048): out += self.sector(lba + i)
        return bytes(out[:length])
    def find(self, path):
        pvd = self.sector(16)
        if pvd[1:6] != b'CD001': raise ValueError('Not a PlayStation disc image (no ISO 9660 volume found).')
        rec = pvd[156:156 + 34]
        lba, size = struct.unpack_from('<I', rec, 2)[0], struct.unpack_from('<I', rec, 10)[0]
        parts = [p for p in re.split(r'[\\/]', path) if p]
        for i, part in enumerate(parts):
            data = self.read(lba, size); o = 0; hit = None
            while o < len(data):
                n = data[o]
                if n == 0:
                    o = (o // 2048 + 1) * 2048; continue
                nl = data[o + 32]; name = data[o + 33:o + 33 + nl].decode('latin1').split(';')[0]
                if name.upper() == part.upper().split(';')[0]:
                    hit = (struct.unpack_from('<I', data, o + 2)[0], struct.unpack_from('<I', data, o + 10)[0]); break
                o += n
            if not hit: return None
            lba, size = hit
        return self.read(lba, size)

def boot_exe(path):
    """Returns (exe bytes, boot file name) from a .cue/.bin/.iso, or the file itself for an .exe."""
    p = Path(path)
    if p.suffix.lower() == '.cue':
        m = re.search(r'FILE\s+"?([^"\n]+?)"?\s+BINARY', p.read_text(errors='replace'), re.I)
        if not m: raise ValueError('The .cue file does not name a BINARY track.')
        p = p.parent / m.group(1)
    with open(p, 'rb') as fh: head = fh.read(8)
    if head == b'PS-X EXE': return p.read_bytes(), p.name
    d = Disc(p)
    cnf = d.find('SYSTEM.CNF')
    name = 'PSX.EXE'
    if cnf:
        m = re.search(rb'BOOT\s*=\s*cdrom:?\\?([^\s;]+)', cnf, re.I)
        if m: name = m.group(1).decode('latin1')
    exe = d.find(name)
    if not exe: raise ValueError(f'Boot file {name} was not found on the disc.')
    return exe, name.split('\\')[-1]

class Image:
    def __init__(self, path):
        exe, name = boot_exe(path)
        if exe[:8] != b'PS-X EXE': raise ValueError(f'{name} is not a PS-X EXE.')
        self.pc0, self.gp0, self.base, size = struct.unpack_from('<IIII', exe, 0x10)
        self.data = exe[0x800:0x800 + size]
        self.serial = re.sub(r'[_.]', '', name.split(';')[0]).upper()
        if re.match(r'^[A-Z]{4}\d{5}$', self.serial): self.serial = self.serial[:4] + '-' + self.serial[4:]
        self.info = f'{self.serial} (PS1)'
    def off(self, v):
        o = v - self.base
        return o if 0 <= o < len(self.data) else None

def detect(path, head):
    if head[:8] == b'PS-X EXE': return True
    if path.lower().endswith('.cue'): return True
    for so, sz in ((16 * 2352 + 24, 2352), (16 * 2352 + 16, 2352), (16 * 2048, 2048)):
        if head[so + 1:so + 6] == b'CD001' and path.lower().endswith(('.bin', '.iso', '.img')):
            return True
    return False

def load(path): return Image(path)
def seed_key(img): return 'ps1_' + img.serial

def sext(v): return v - 0x10000 if v & 0x8000 else v
def reg(x): return x.strip().lstrip('$')

def analyze(img, ra_fn=None, mode=CS_MODE_MIPS32, extra_starts=()):
    """Shared MIPS analysis (PS1 and PS2)."""
    ra_ = ra_fn or ra
    D = img.data; base = img.base; N = len(D) & ~3; end_addr = base + N
    words = struct.unpack_from(f'<{N // 4}I', D)
    W = lambda a: words[(a - base) // 4]
    def prologue(a): return base <= a < end_addr and (W(a) >> 16) in (0x27BD, 0x67BD) and W(a) & 0x8000  # (d)addiu sp, sp, -N
    calls = {}
    for i, w in enumerate(words):
        if w >> 26 == 3:  # jal
            pc = base + 4 * i; t = ((pc + 4) & 0xF0000000) | ((w & 0x3FFFFFF) << 2)
            if base <= t < end_addr: calls.setdefault(t, []).append(pc)
    ptrs = {}
    for i, w in enumerate(words):
        if w & 3 == 0 and prologue(w): ptrs.setdefault(w, []).append(base + 4 * i)
    starts = sorted(set(calls) | set(ptrs) | ({img.pc0} if base <= img.pc0 < end_addr else set()) | {s for s in extra_starts if base <= s < end_addr})
    md = Cs(CS_ARCH_MIPS, mode + CS_MODE_LITTLE_ENDIAN); md.skipdata = True
    funcs = {}
    PG.say(f'Found {len(starts):,} function starts (calls and function pointers). Reading each one…')
    for si, s in enumerate(starts):
        PG.count(si + 1, len(starts), 'functions read')
        stop = min(starts[si + 1] if si + 1 < len(starts) else end_addr, s + 0x4000)
        ins, refs, callees = [], [], set()
        hi = {}; far = 0; pending_clobber = False; done_after = None
        for x in md.disasm(D[s - base:stop - base], s):
            mn = x.mnemonic; ops = [o.strip() for o in x.op_str.split(',')] if x.op_str else []
            line = {'a': x.address, 't': f'{mn} {x.op_str}'.strip()}
            tgt = None
            if is_branch(mn) and ops and re.fullmatch(r'0x[0-9a-f]+', ops[-1]):
                tgt = int(ops[-1], 16)
                if mn in ('jal', 'bal'):
                    if tgt in calls or tgt in ptrs: callees.add(tgt); line['call'] = tgt
                else: far = max(far, tgt)
            # track constants built with lui / addiu / ori, and gp-relative globals
            d0 = reg(ops[0]) if ops else None
            try:
                if mn == 'lui':
                    hi[d0] = (int(ops[1], 0) << 16) & 0xFFFFFFFF
                elif mn in ('addiu', 'addi', 'ori', 'daddiu') and len(ops) == 3 and reg(ops[1]) in hi:
                    v = (hi[reg(ops[1])] | int(ops[2], 0)) if mn == 'ori' else (hi[reg(ops[1])] + sext(int(ops[2], 0) & 0xFFFF))
                    v &= 0xFFFFFFFF; line['lit'] = v; hi[d0] = v
                    r = ra_(v)
                    if r is not None and v not in ptrs and v not in calls: refs.append({'ra': r, 'at': x.address, 'rw': 'ptr'})
                elif mn in LOADS | STORES and len(ops) == 2:
                    m = re.fullmatch(r'(-?0x[0-9a-f]+|-?\d+)?\(\$(\w+)\)', ops[1])
                    if m:
                        off = int(m.group(1), 0) if m.group(1) else 0; b = m.group(2)
                        addr = None
                        if b in hi: addr = (hi[b] + off) & 0xFFFFFFFF
                        elif b == 'gp' and img.gp0: addr = (img.gp0 + off) & 0xFFFFFFFF
                        if addr is not None:
                            line['mem'] = addr; r = ra_(addr)
                            if r is not None: refs.append({'ra': r, 'at': x.address, 'rw': 'W' if mn in STORES else 'R'})
                    if mn in LOADS: hi.pop(d0, None)
                elif d0 and mn not in NO_DEST and not is_branch(mn):
                    hi.pop(d0, None)
            except ValueError:
                pass
            if pending_clobber:
                for r_ in ('v0', 'v1', 'a0', 'a1', 'a2', 'a3', 't0', 't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9'): hi.pop(r_, None)
                pending_clobber = False
            if mn in ('jal', 'jalr', 'bal'): pending_clobber = True
            ins.append(line)
            if done_after is not None and x.address >= done_after: break
            if mn == 'jr' and ops and reg(ops[0]) == 'ra' and far <= x.address:
                done_after = x.address + 4  # include the delay slot, then stop
            if len(ins) > 1500: break
        funcs[s] = {'start': s, 'n': len(ins), 'ins': ins, 'refs': refs, 'callers': sorted(set(calls.get(s, []))),
                    'ptrrefs': ptrs.get(s, [])[:20], 'callees': sorted(callees)}
    return funcs

def translate(ins, lab, fname, pool, tlook=lambda v: None, enums=None):
    return ps1_plain.translate(ins, lab, fname, tlook, enums or {}, ra)

def ghidra_import(img, rom_path, work):
    """The boot program's code, loaded where the PS1 puts it."""
    from pathlib import Path
    f = Path(work) / f'{img.serial}.exe.bin'; f.write_bytes(img.data)
    return {'file': str(f), 'thumb': False,
            'args': ['-loader', 'BinaryLoader', '-loader-baseAddr', hex(img.base), '-processor', 'MIPS:LE:32:default']}

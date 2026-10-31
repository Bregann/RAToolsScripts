"""GameCube and Wii. The game's main program is main.dol (found from the disc header). CPU is the PowerPC 750
(Gekko on GameCube, Broadway on Wii), big endian. Globals are often reached through r13 and r2, the
"small data" base registers set up at start-up."""
from .. import progress as PG
import re, struct
from capstone import Cs, CS_ARCH_PPC, CS_MODE_32, CS_MODE_BIG_ENDIAN
from . import nintendo_disc, ppc_plain

NAME = 'GameCube / Wii'
KEY = 'gc'
EXTS = ('.iso', '.gcm', '.rvz', '.wia', '.dol')
BUS = 'GC/Wii'
CPU = 'PowerPC 750 (Gekko / Broadway)'
PTR_FMT = '>I'   # pointers in data are big endian

try:
    from capstone import CS_MODE_PS
    MODE = CS_MODE_32 + CS_MODE_BIG_ENDIAN + CS_MODE_PS   # paired-single float instructions
except ImportError:
    MODE = CS_MODE_32 + CS_MODE_BIG_ENDIAN

# ---- RetroAchievements: MEM1 0x80000000 at 0, Wii MEM2 0x90000000 at 0x10000000 ----
def ra(v):
    if 0x80000000 <= v < 0x81800000: return v - 0x80000000
    if 0xC0000000 <= v < 0xC1800000: return v - 0xC0000000     # uncached mirror of MEM1
    if 0x90000000 <= v < 0x94000000: return 0x10000000 + v - 0x90000000
    if 0xD0000000 <= v < 0xD4000000: return 0x10000000 + v - 0xD0000000
    return None
def bus(r): return 0x80000000 + r if r < 0x10000000 else 0x90000000 + r - 0x10000000
def mem_region(r): return 'MEM1' if r < 0x01800000 else 'MEM2 (Wii)'
RA_RANGES = [(0x80000000, 0x81800000, 0), (0xC0000000, 0xC1800000, 0), (0x90000000, 0x94000000, 0x10000000), (0xD0000000, 0xD4000000, 0x10000000)]

def detect(path, head):
    if path.lower().endswith('.dol'): return True
    return nintendo_disc.is_disc(path, head)

class Image:
    def __init__(self, path):
        if path.lower().endswith('.dol'):
            dol = open(path, 'rb').read(); self.game_id = ''; self.title = ''; self.wii = None
        else:
            g = nintendo_disc.GameData(path)
            dol = g.dol(); self.game_id = g.game_id; self.title = g.title; self.wii = g.wii
        self.dol = dol
        offs = struct.unpack('>18I', dol[0:0x48]); addrs = struct.unpack('>18I', dol[0x48:0x90]); sizes = struct.unpack('>18I', dol[0x90:0xD8])
        self.bss, self.bss_size, self.pc0 = struct.unpack('>III', dol[0xD8:0xE4])
        secs = [(addrs[i], dol[offs[i]:offs[i] + sizes[i]], i < 7) for i in range(18) if sizes[i] and addrs[i]]
        if not secs: raise ValueError('main.dol has no sections.')
        self.base = min(a for a, _, _ in secs); top = max(a + len(b) for a, b, _ in secs)
        if top - self.base > 0x01800000: raise ValueError('main.dol spans more than 24 MB; that does not look right.')
        flat = bytearray(top - self.base)
        for a, b, _ in secs: flat[a - self.base:a - self.base + len(b)] = b
        self.data = bytes(flat)
        self.code_ranges = [(a, a + len(b)) for a, b, t in secs if t]
        self.r13, self.r2 = self.find_sda()
        kind = 'Wii' if self.wii else ('GC' if self.wii is False else 'GC/Wii')
        self.info = f'{self.title or "main.dol"} [{self.game_id}] ({kind})' if self.game_id else 'main.dol'
    def find_sda(self):
        """__start sets r13 and r2: lis rN, hi / addi (or ori) rN, rN, lo."""
        out = {13: 0, 2: 0}; hi = {}
        o = self.off(self.pc0)
        if o is None: return 0, 0
        for i in range(400):
            if o + 4 * i + 4 > len(self.data): break
            w = struct.unpack_from('>I', self.data, o + 4 * i)[0]
            op, d, a, imm = w >> 26, (w >> 21) & 31, (w >> 16) & 31, w & 0xFFFF
            if op == 15 and a == 0: hi[d] = imm << 16
            elif op in (14, 24) and d == a and d in (13, 2) and d in hi:
                v = (hi[d] + (imm - 0x10000 if imm & 0x8000 else imm)) if op == 14 else (hi[d] | imm)
                out[d] = v & 0xFFFFFFFF
            if out[13] and out[2]: break
        return out[13], out[2]
    def off(self, v):
        o = v - self.base
        return o if 0 <= o < len(self.data) else None

def load(path): return Image(path)
def seed_key(img): return 'gc_' + (img.game_id or 'dol')

def in_code(img, a): return any(lo <= a < hi for lo, hi in img.code_ranges)

LOADS = {'lwz', 'lwzu', 'lhz', 'lhzu', 'lha', 'lhau', 'lbz', 'lbzu', 'lfs', 'lfsu', 'lfd', 'lfdu', 'lmw', 'psq_l', 'psq_lu'}
STORES = {'stw', 'stwu', 'sth', 'sthu', 'stb', 'stbu', 'stfs', 'stfsu', 'stfd', 'stfdu', 'stmw', 'psq_st', 'psq_stu'}

def analyze(img):
    D = img.data; base = img.base; N = len(D) & ~3
    words = struct.unpack_from(f'>{N // 4}I', D)
    W = lambda a: words[(a - base) // 4]
    def prologue(a): return in_code(img, a) and (W(a) >> 16) == 0x9421 and W(a) & 0x8000   # stwu r1, -N(r1)
    calls = {}; ptrs = {}
    for lo, hi in img.code_ranges:
        for a in range(lo, hi - 3, 4):
            w = W(a)
            if w >> 26 == 18 and w & 1 and not w & 2:   # bl
                off = w & 0x03FFFFFC
                if off & 0x02000000: off -= 0x04000000
                t = (a + off) & 0xFFFFFFFF
                if in_code(img, t): calls.setdefault(t, []).append(a)
    for i, w in enumerate(words):   # vtables and other function pointers
        if w & 3 == 0 and prologue(w): ptrs.setdefault(w, []).append(base + 4 * i)
    starts = sorted(set(calls) | set(ptrs) | ({img.pc0} if in_code(img, img.pc0) else set()))
    md = Cs(CS_ARCH_PPC, MODE); md.skipdata = True
    funcs = {}
    sda = {'r13': img.r13, 'r2': img.r2}
    PG.say(f'Found {len(starts):,} function starts (calls and function pointers). Reading each one…')
    for si, s in enumerate(starts):
        PG.count(si + 1, len(starts), 'functions read')
        stop = min(starts[si + 1] if si + 1 < len(starts) else base + N, s + 0x8000)
        ins, refs, callees = [], [], set(); hi = {}; far = 0
        for x in md.disasm(D[s - base:stop - base], s):
            mn = x.mnemonic; ops = [o.strip() for o in x.op_str.split(',')] if x.op_str else []
            line = {'a': x.address, 't': f'{mn} {x.op_str}'.strip()}
            # branches
            if mn.startswith('b') and ops and re.fullmatch(r'0x[0-9a-f]+', ops[-1]):
                tgt = int(ops[-1], 16)
                if mn in ('bl', 'bla'):
                    if tgt in calls or tgt in ptrs: callees.add(tgt); line['call'] = tgt
                    for r in ('r0',) + tuple(f'r{i}' for i in range(3, 13)): hi.pop(r, None)
                elif mn in ('b', 'ba') and not (s <= tgt < stop):
                    if tgt in calls or tgt in ptrs or in_code(img, tgt): line['call'] = tgt; line['tail'] = True; callees.add(tgt)
                else: far = max(far, tgt)
            try:
                d0 = ops[0] if ops else None
                if mn == 'lis' and len(ops) == 2:
                    hi[d0] = (int(ops[1], 0) & 0xFFFF) << 16
                elif mn in ('addi', 'ori', 'addic') and len(ops) == 3 and ops[1] in hi:
                    imm = int(ops[2], 0)
                    v = (hi[ops[1]] | (imm & 0xFFFF)) if mn == 'ori' else (hi[ops[1]] + imm)
                    v &= 0xFFFFFFFF; line['lit'] = v; hi[d0] = v
                    r = ra(v)
                    if r is not None and v not in calls and v not in ptrs: refs.append({'ra': r, 'at': x.address, 'rw': 'ptr'})
                elif mn in ('addi',) and len(ops) == 3 and ops[1] in sda and sda[ops[1]]:
                    v = (sda[ops[1]] + int(ops[2], 0)) & 0xFFFFFFFF; line['lit'] = v; hi[d0] = v
                    r = ra(v)
                    if r is not None: refs.append({'ra': r, 'at': x.address, 'rw': 'ptr'})
                elif mn in LOADS | STORES and len(ops) >= 2:
                    m = re.fullmatch(r'(-?0x[0-9a-f]+|-?\d+)?\((r\d+)\)', ops[1])
                    if m:
                        off = int(m.group(1), 0) if m.group(1) else 0; b = m.group(2); addr = None
                        if b in hi: addr = (hi[b] + off) & 0xFFFFFFFF
                        elif b in sda and sda[b]: addr = (sda[b] + off) & 0xFFFFFFFF
                        if addr is not None and b != 'r1':
                            line['mem'] = addr; r = ra(addr)
                            if r is not None: refs.append({'ra': r, 'at': x.address, 'rw': 'W' if mn in STORES else 'R'})
                        if mn.endswith('u') and b in hi and addr is not None: hi[b] = addr
                    if mn in LOADS: hi.pop(d0, None)
                elif d0 and re.fullmatch(r'r\d+', d0) and mn not in STORES and not mn.startswith(('b', 'cmp', 'mt')):
                    hi.pop(d0, None)
            except ValueError:
                pass
            ins.append(line)
            if (mn in ('blr', 'bctr', 'rfi') or line.get('tail')) and far <= x.address: break
            if len(ins) > 3000: break
        funcs[s] = {'start': s, 'n': len(ins), 'ins': ins, 'refs': refs, 'callers': sorted(set(calls.get(s, []))),
                    'ptrrefs': ptrs.get(s, [])[:20], 'callees': sorted(callees)}
        if s in ptrs and s not in calls: funcs[s]['auto'] = (None, f'Reached through a function pointer ({len(ptrs[s])} place{"s" if len(ptrs[s]) > 1 else ""}), often a C++ virtual method.')
    if img.pc0 in funcs: funcs[img.pc0]['auto'] = ('__start', 'Entry point of main.dol. Sets up r13 and r2 (the small-data bases) and calls main.')
    name_cpp_classes(img, funcs, words, base)
    return funcs

IDENT = re.compile(rb'[A-Za-z_][A-Za-z0-9_:<>,\* ]{1,80}')
def name_cpp_classes(img, funcs, words, base):
    """C++ games built with CodeWarrior keep class names (RTTI): a class's vtable starts with a pointer to
    {pointer to "ClassName", ...}, then 0, then its virtual functions. Name those functions ClassName::vfunc_N,
    and the functions that store the vtable into a new object ClassName::ClassName (constructor) or ~ClassName."""
    D = img.data; n = len(words)
    def W(a):
        o = img.off(a)
        return struct.unpack_from('>I', D, o)[0] if o is not None and o + 4 <= len(D) and o % 4 == 0 else None
    def cname(ti):
        p = W(ti)
        if p is None: return None
        o = img.off(p)
        if o is None: return None
        m = IDENT.match(D, o)
        if not m or D[m.end():m.end() + 1] != b'\x00' or len(m.group()) < 2: return None
        return m.group().decode('latin1')
    vts = {}
    for i in range(n - 3):
        w0, w1, w2 = words[i], words[i + 1], words[i + 2]
        if w1 != 0 or w2 & 3 or not in_code(img, w2) or not (0x80000000 <= w0 < 0x81800000): continue
        cls = cname(w0)
        if not cls: continue
        ents = []
        for j in range(i + 2, min(n, i + 2 + 400)):
            if words[j] & 3 == 0 and in_code(img, words[j]): ents.append(words[j])
            else: break
        vts[base + 4 * i] = (cls, ents)
    if not vts: return 0
    by_func = {}
    for va, (cls, ents) in vts.items():
        for k, f in enumerate(ents):
            if f in funcs: by_func.setdefault(f, []).append((len(ents), cls, k))
    safe = lambda c: re.sub(r'[^A-Za-z0-9_]', '_', c.replace('::', '__'))[:60]
    named = 0
    for f, uses in by_func.items():
        if funcs[f].get('auto') and funcs[f]['auto'][0]: continue
        uses.sort(); size, cls, k = uses[0]   # the class with the shortest vtable is usually the base class that defines it
        others = sorted({c for _, c, _ in uses if c != cls})
        note = f'Virtual function {k} of {cls}' + (f', also used by {len(others)} other class{"es" if len(others) > 1 else ""} ({", ".join(others[:4])}{"…" if len(others) > 4 else ""})' if others else '') + '. Name from the game\'s C++ class info.'
        funcs[f]['auto'] = (f'{safe(cls)}__vfunc_{k}', note); named += 1
    for k, f in funcs.items():
        if f.get('auto') and f['auto'][0]: continue
        hits = [l['lit'] for l in f['ins'] if l.get('lit') in vts]
        if not hits: continue
        va = hits[0]; cls = vts[va][0]
        if k in vts[va][1]: funcs[k]['auto'] = (f'{safe(cls)}__dtor', f'Destructor of {cls} (puts its vtable back while the object is torn down). Name from the game\'s C++ class info.')
        else: funcs[k]['auto'] = (f'{safe(cls)}__ctor', f'Constructor of {cls}: sets up a new {cls} and points it at its vtable. Name from the game\'s C++ class info.')
        named += 1
    img.cpp_classes = len(vts)
    PG.say(f'Named {named:,} functions from the game\'s C++ class names ({len(vts):,} classes).')
    return named

def builtin_labels(img=None):
    out = []
    if img is not None:
        if img.r13 and ra(img.r13) is not None:
            out.append({'ra': ra(img.r13), 'size': 1, 'name': 'SDA_r13', 'note': 'Small-data base held in r13. Globals at r13 plus or minus 0x8000 are reached from it.', 'builtin': True})
        if img.r2 and ra(img.r2) is not None:
            out.append({'ra': ra(img.r2), 'size': 1, 'name': 'SDA2_r2', 'note': 'Read-only small-data base held in r2 (constants).', 'builtin': True})
    return out

def ghidra_import(img, rom_path, work):
    """main.dol's sections laid out where they load. With the Ghidra GameCube Loader extension you can also
    open main.dol in Ghidra directly."""
    from pathlib import Path
    f = Path(work) / f'{img.game_id or "main"}.dol.bin'; f.write_bytes(img.data)
    return {'file': str(f), 'thumb': False,
            'args': ['-loader', 'BinaryLoader', '-loader-baseAddr', hex(img.base), '-processor', 'PowerPC:BE:32:default']}

def translate(ins, lab, fname, pool, tlook=lambda v: None, enums=None):
    return ppc_plain.translate(ins, lab, fname, tlook, enums or {}, ra)

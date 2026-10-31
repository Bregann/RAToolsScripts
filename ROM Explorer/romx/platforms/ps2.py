"""PlayStation 2: the game's main program is an ELF on the DVD (named by BOOT2 in SYSTEM.CNF).
CPU is the Emotion Engine (MIPS R5900, 64-bit registers, some 128-bit and vector-unit instructions the
disassembler shows raw). Many PS2 ELFs still carry their symbol table, which gives real function names."""
import re, struct
from pathlib import Path
from capstone import CS_MODE_MIPS64
from . import ps1, ps1_plain

NAME = 'PlayStation 2'
KEY = 'ps2'
EXTS = ('.iso', '.bin', '.elf', '.cue')
BUS = 'PS2'
CPU = 'Emotion Engine (MIPS R5900)'

# ---- RetroAchievements: EE RAM 0x00000000-0x01FFFFFF as is, scratchpad (0x70000000) at 0x02000000 ----
def ra(v):
    if 0x00100000 <= (v & 0x1FFFFFFF) < 0x02000000 and (v >> 28) in (0, 2, 3): return v & 0x1FFFFFF
    if 0x70000000 <= v < 0x70004000: return 0x02000000 + v - 0x70000000
    return None
def bus(r): return r if r < 0x02000000 else 0x70000000 + r - 0x02000000
RA_RANGES = [(0x00100000, 0x02000000, 0x00100000), (0x20100000, 0x22000000, 0x00100000), (0x70000000, 0x70004000, 0x02000000)]
def mem_region(r):
    if r < 0x00100000: return 'Kernel RAM'
    if r < 0x02000000: return 'Main RAM'
    return 'Scratchpad'

def boot_elf(path):
    """Returns (elf bytes, boot file name) from a disc image, or the file itself for an .elf."""
    p = Path(path)
    if p.suffix.lower() == '.cue':
        m = re.search(r'FILE\s+"?([^"\n]+?)"?\s+BINARY', p.read_text(errors='replace'), re.I)
        if not m: raise ValueError('The .cue file does not name a BINARY track.')
        p = p.parent / m.group(1)
    with open(p, 'rb') as fh: head = fh.read(4)
    if head == b'\x7fELF': return p.read_bytes(), p.name
    d = ps1.Disc(p)
    cnf = d.find('SYSTEM.CNF')
    if not cnf: raise ValueError('No SYSTEM.CNF on the disc, so the boot program is unknown.')
    m = re.search(rb'BOOT2\s*=\s*cdrom0?:\\?([^\s;]+)', cnf, re.I)
    if not m: raise ValueError('SYSTEM.CNF has no BOOT2 line. Is this a PS1 disc? Open it as PlayStation instead.')
    name = m.group(1).decode('latin1')
    elf = d.find(name)
    if not elf: raise ValueError(f'Boot file {name} was not found on the disc.')
    return elf, name.split('\\')[-1]

def disc_is_ps2(path, head):
    """True if the disc's SYSTEM.CNF has a BOOT2 line."""
    try:
        p = Path(path)
        if p.suffix.lower() == '.cue':
            m = re.search(r'FILE\s+"?([^"\n]+?)"?\s+BINARY', p.read_text(errors='replace'), re.I)
            if not m: return False
            p = p.parent / m.group(1)
        cnf = ps1.Disc(p).find('SYSTEM.CNF')
        return bool(cnf and re.search(rb'BOOT2\s*=', cnf, re.I))
    except (OSError, ValueError, struct.error, IndexError):
        return False

def detect(path, head):
    if head[:4] == b'\x7fELF' and head[18] == 8: return True   # e_machine 8 = MIPS
    if path.lower().endswith(('.iso', '.bin', '.cue', '.img')): return disc_is_ps2(path, head)
    return False

class Image:
    def __init__(self, path):
        elf, name = boot_elf(path)
        self.elf = elf
        if elf[:4] != b'\x7fELF' or elf[4] != 1: raise ValueError(f'{name} is not a 32-bit ELF.')
        (self.pc0,) = struct.unpack_from('<I', elf, 24)
        phoff, shoff = struct.unpack_from('<II', elf, 28)
        phentsize, phnum, shentsize, shnum, shstrndx = struct.unpack_from('<HHHHH', elf, 42)
        segs = []
        for i in range(phnum):
            ptype, off, vaddr, paddr, filesz, memsz, flags, align = struct.unpack_from('<8I', elf, phoff + i * phentsize)
            if ptype == 1 and filesz: segs.append((vaddr, elf[off:off + filesz], flags))
        if not segs: raise ValueError('The ELF has no loadable segments.')
        self.base = min(v for v, _, _ in segs)
        top = max(v + len(b) for v, b, _ in segs)
        if top - self.base > 48 * 1024 * 1024: raise ValueError('The ELF spans more than 48 MB of memory; that does not look like a PS2 program.')
        flat = bytearray(top - self.base)
        for v, b, _ in segs: flat[v - self.base:v - self.base + len(b)] = b
        self.data = bytes(flat)
        self.code_ranges = [(v, v + len(b)) for v, b, f in segs if f & 1] or [(v, v + len(b)) for v, b, _ in segs]
        # symbols
        self.func_syms, self.data_syms = {}, {}
        secs = [struct.unpack_from('<10I', elf, shoff + i * shentsize) for i in range(shnum)] if shoff and shnum else []
        for s in secs:
            if s[1] == 2 and s[6] < len(secs):   # SHT_SYMTAB, sh_link -> string table
                st = secs[s[6]]; strtab = elf[st[4]:st[4] + st[5]]
                for k in range(s[5] // 16):
                    nm, val, size, info, other, shndx = struct.unpack_from('<IIIBBH', elf, s[4] + 16 * k)
                    if not nm or not val: continue
                    e = strtab.find(b'\x00', nm); n = strtab[nm:e].decode('latin1', 'replace')
                    typ = info & 0xF
                    if typ == 2: self.func_syms[val] = n
                    elif typ == 1: self.data_syms[val] = (n, size)
                    elif n == '_gp': self.data_syms[val] = (n, 0)
        self.gp0 = next((v for v, (n, _) in self.data_syms.items() if n == '_gp'), 0) or self.find_gp()
        self.serial = re.sub(r'[_.]', '', name.split(';')[0]).upper()
        if re.match(r'^[A-Z]{4}\d{5}$', self.serial): self.serial = self.serial[:4] + '-' + self.serial[4:]
        self.info = f'{self.serial} (PS2)'
        self.symbols = len(self.func_syms)
    def find_gp(self):
        """Most PS2 programs set gp in their first few instructions: lui gp, hi / addiu gp, gp, lo."""
        o = self.off(self.pc0)
        if o is None: return 0
        hi = None
        for i in range(64):
            if o + 4 * i + 4 > len(self.data): break
            w = struct.unpack_from('<I', self.data, o + 4 * i)[0]
            if w >> 16 == 0x3C1C: hi = (w & 0xFFFF) << 16
            elif hi is not None and w >> 16 in (0x279C, 0x379C, 0x679C):
                lo = w & 0xFFFF
                return (hi | lo) if w >> 16 == 0x379C else (hi + (lo - 0x10000 if lo & 0x8000 else lo)) & 0xFFFFFFFF
        return 0
    def off(self, v):
        o = v - self.base
        return o if 0 <= o < len(self.data) else None

def load(path): return Image(path)
def seed_key(img): return 'ps2_' + img.serial

def analyze(img):
    F = ps1.analyze(img, ra_fn=ra, mode=CS_MODE_MIPS64, extra_starts=img.func_syms.keys())
    for k, f in F.items():
        if k in img.func_syms: f['auto'] = (re.sub(r'[^A-Za-z0-9_]', '_', img.func_syms[k])[:60], "Name from the game's symbol table.")
    return F

def builtin_labels(img=None):
    """Global variables named in the symbol table (only when the ELF still has one)."""
    out = []
    if img is None: return out
    for v, (n, size) in img.data_syms.items():
        r = ra(v)
        if r is not None and n != '_gp':
            out.append({'ra': r, 'size': max(1, min(size or 4, 0x1000)), 'name': re.sub(r'[^A-Za-z0-9_]', '_', n)[:60],
                        'note': "Name from the game's symbol table.", 'builtin': True})
    return out

def translate(ins, lab, fname, pool, tlook=lambda v: None, enums=None):
    return ps1_plain.translate(ins, lab, fname, tlook, enums or {}, ra)

def ghidra_import(img, rom_path, work):
    """The boot ELF. Ghidra's ELF loader picks the processor; with the Emotion Engine extension
    installed it can use the R5900 language, otherwise it falls back to plain MIPS."""
    from pathlib import Path
    f = Path(work) / f'{img.serial}.elf'; f.write_bytes(img.elf)
    return {'file': str(f), 'thumb': False, 'args': []}

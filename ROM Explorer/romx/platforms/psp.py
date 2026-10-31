"""PlayStation Portable. The game is PSP_GAME/SYSDIR/EBOOT.BIN on the UMD image. Retail EBOOTs are encrypted:
PPSSPP can dump the decrypted file (Settings > Tools > Developer tools > Dump decrypted EBOOT.BIN on game boot).
The CPU is the Allegrex (MIPS32, little endian; its VFPU vector instructions show as raw).
The main program is usually a relocatable PRX; it's placed where the PSP loads it, 0x08804000."""
import re, struct, zlib
from pathlib import Path
from capstone import CS_MODE_MIPS32
from . import ps1, ps1_plain

NAME = 'PlayStation Portable'
KEY = 'psp'
EXTS = ('.iso', '.cso', '.zso', '.elf', '.prx', '.bin')
BUS = 'PSP'
CPU = 'Allegrex (MIPS32)'
LOAD_BASE = 0x08804000

# ---- RetroAchievements: 0x08000000 is RA 0 (kernel RAM 0x08000000, user RAM 0x08800000, extra RAM 0x0A000000) ----
def ra(v):
    low = v & 0x3FFFFFFF if (v >> 28) in (0, 4, 8, 0xC) else None
    if low is not None and 0x08000000 <= low < 0x0C000000: return low - 0x08000000
    return None
def bus(r): return 0x08000000 + r
def mem_region(r): return 'Kernel RAM' if r < 0x800000 else ('User RAM' if r < 0x2000000 else 'Extra RAM')
RA_RANGES = [(0x08000000, 0x0C000000, 0), (0x48000000, 0x4C000000, 0), (0x88000000, 0x8C000000, 0)]

# A few common system calls, so import stubs read as names. Everything else shows as Library_NID.
NIDS = {0x1F803938: 'sceCtrlReadBufferPositive', 0x3A622550: 'sceCtrlPeekBufferPositive', 0x1F4011E6: 'sceCtrlSetSamplingMode',
        0x984C27E7: 'sceDisplayWaitVblankStart', 0xCEADEB47: 'sceKernelDelayThread', 0x05572A5F: 'sceKernelExitGame',
        0x446D8DE6: 'sceKernelCreateThread', 0xF475845D: 'sceKernelStartThread', 0x109F50BC: 'sceIoOpen', 0x6A638D83: 'sceIoRead',
        0x42EC03AC: 'sceIoWrite', 0x810C4BC3: 'sceIoClose', 0xAB49E76A: 'sceGeListEnQueue', 0xE7C27D1B: 'sceRtcGetCurrentClockLocalTime'}

class CsoDisc(ps1.Disc):
    """CSO (zlib) and ZSO (LZ4) compressed UMD images."""
    def __init__(self, path):
        self.f = open(path, 'rb'); h = self.f.read(0x18)
        self.kind = h[:4]
        hdr, total = struct.unpack_from('<IQ', h, 4); self.block, ver, self.align = struct.unpack_from('<IBB', h, 0x10)
        n = (total + self.block - 1) // self.block
        self.f.seek(hdr); self.index = struct.unpack(f'<{n + 1}I', self.f.read(4 * (n + 1)))
        self.size, self.off = 2048, 0; self.cache = {}
    def block_data(self, i):
        if i in self.cache: return self.cache[i]
        a, b = self.index[i], self.index[i + 1]
        start, end = (a & 0x7FFFFFFF) << self.align, (b & 0x7FFFFFFF) << self.align
        self.f.seek(start); raw = self.f.read(end - start)
        if a & 0x80000000: data = raw[:self.block]
        elif self.kind == b'CISO': data = zlib.decompress(raw, -15)
        else:
            try: import lz4.block
            except ImportError: raise ValueError('Reading .zso needs the lz4 package: pip install lz4')
            data = lz4.block.decompress(raw, uncompressed_size=self.block)
        if len(self.cache) > 128: self.cache.clear()
        self.cache[i] = data; return data
    def sector(self, n):
        per = self.block // 2048; d = self.block_data(n // per); o = (n % per) * 2048
        return d[o:o + 2048]

def boot_file(path):
    p = Path(path)
    with open(p, 'rb') as fh: head = fh.read(4)
    if head == b'\x7fELF': return p.read_bytes(), p.name
    if head == b'~PSP': raise ValueError(ENCRYPTED)
    disc = CsoDisc(p) if head in (b'CISO', b'ZISO') else ps1.Disc(p)
    eboot = disc.find('PSP_GAME/SYSDIR/EBOOT.BIN')
    if eboot is None: raise ValueError('No PSP_GAME/SYSDIR/EBOOT.BIN on this disc. Is it a PSP game?')
    if eboot[:4] == b'\x7fELF': return eboot, 'EBOOT.BIN'
    boot = disc.find('PSP_GAME/SYSDIR/BOOT.BIN')
    if boot and boot[:4] == b'\x7fELF': return boot, 'BOOT.BIN'
    raise ValueError(ENCRYPTED)
ENCRYPTED = ('The game\'s EBOOT.BIN is encrypted. In PPSSPP turn on Settings > Tools > Developer tools > '
             '"Dump decrypted EBOOT.BIN on game boot", start the game once, then open the dumped file '
             '(memstick/PSP/SYSTEM/DUMP/<game ID>.BIN) here.')

def is_psp_disc(path):
    try:
        p = Path(path)
        with open(p, 'rb') as fh: head = fh.read(4)
        disc = CsoDisc(p) if head in (b'CISO', b'ZISO') else ps1.Disc(p)
        pvd = disc.sector(16)
        return pvd[1:6] == b'CD001' and disc.find('PSP_GAME/PARAM.SFO') is not None
    except (OSError, ValueError, struct.error, IndexError, zlib.error):
        return False

def detect(path, head):
    if head[:4] in (b'CISO', b'ZISO'): return True
    if head[:4] == b'~PSP': return True
    if head[:4] == b'\x7fELF' and len(head) > 40 and head[18] == 8:
        etype = struct.unpack_from('<H', head, 16)[0]; flags = struct.unpack_from('<I', head, 36)[0]
        return etype == 0xFFA0 or (flags >> 16) & 0xFF == 0xA2 or path.lower().endswith('.prx')   # 0xA2 = Allegrex
    if path.lower().endswith('.iso'): return is_psp_disc(path)
    return False

def relocate(elf, phs, secs, base):
    """Apply PSP relocations (section type 0x700000A0) for a PRX placed at base."""
    out = bytearray(elf); applied = 0
    seg_file = [(p[2], p[1], p[4]) for p in phs]   # (vaddr, file offset, filesz)
    def file_off(vaddr):
        for va, fo, sz in seg_file:
            if va <= vaddr < va + sz: return fo + vaddr - va
        return None
    for s in secs:
        if s[1] != 0x700000A0: continue
        ents = [struct.unpack_from('<II', elf, s[4] + 8 * i) for i in range(s[5] // 8)]
        for i, (r_off, info) in enumerate(ents):
            typ, ofsb, adrb = info & 0xFF, (info >> 8) & 0xFF, (info >> 16) & 0xFF
            if ofsb >= len(phs) or adrb >= len(phs): continue
            where = file_off(phs[ofsb][2] + r_off)
            if where is None or where + 4 > len(out): continue
            rel = base + phs[adrb][2]
            w = struct.unpack_from('<I', out, where)[0]
            if typ == 2: w = (w + rel) & 0xFFFFFFFF
            elif typ == 4: w = (w & 0xFC000000) | ((((w & 0x03FFFFFF) << 2) + rel) >> 2 & 0x03FFFFFF)
            elif typ == 5:   # HI16: pair with the next LO16
                lo = 0
                for r2, i2 in ents[i + 1:i + 8]:
                    if i2 & 0xFF == 6:
                        lw = file_off(phs[(i2 >> 8) & 0xFF][2] + r2)
                        if lw is not None: lo = struct.unpack_from('<h', out, lw)[0]
                        break
                full = ((w & 0xFFFF) << 16) + lo + rel
                w = (w & 0xFFFF0000) | (((full + 0x8000) >> 16) & 0xFFFF)
            elif typ == 6: w = (w & 0xFFFF0000) | ((w + rel) & 0xFFFF)
            else: continue
            struct.pack_into('<I', out, where, w); applied += 1
    return bytes(out), applied

class Image:
    def __init__(self, path):
        elf, name = boot_file(path); self.elf = elf; self.boot_name = name
        if elf[:4] != b'\x7fELF': raise ValueError(f'{name} is not an ELF.')
        etype = struct.unpack_from('<H', elf, 16)[0]
        (entry,) = struct.unpack_from('<I', elf, 24)
        phoff, shoff = struct.unpack_from('<II', elf, 28)
        phentsize, phnum, shentsize, shnum, shstrndx = struct.unpack_from('<HHHHH', elf, 42)
        phs = [struct.unpack_from('<8I', elf, phoff + i * phentsize) for i in range(phnum)]
        secs = [struct.unpack_from('<10I', elf, shoff + i * shentsize) for i in range(shnum)] if shoff and shnum else []
        self.prx = etype == 0xFFA0
        base = LOAD_BASE if self.prx else 0
        self.relocs = 0; self.reloc_note = ''
        if self.prx:
            elf, self.relocs = relocate(elf, phs, secs, base)
            if not self.relocs and any(p[0] == 0x700000A1 for p in phs):
                self.reloc_note = 'This PRX uses the newer packed relocation format, which the tool can\'t apply yet, so RAM addresses in the code may be off.'
        loads = [p for p in phs if p[0] == 1 and p[4]]
        if not loads: raise ValueError('The ELF has no loadable segments.')
        segs = [(p[2] + base, elf[p[1]:p[1] + p[4]], p[6]) for p in loads]
        self.base = min(v for v, _, _ in segs); top = max(v + len(b) for v, b, _ in segs)
        flat = bytearray(top - self.base)
        for v, b, _ in segs: flat[v - self.base:v - self.base + len(b)] = b
        self.data = bytes(flat); self.pc0 = entry + base
        self.code_ranges = [(v, v + len(b)) for v, b, f in segs if f & 1] or [(v, v + len(b)) for v, b, _ in segs]
        # module info (name, gp, import stubs). For a PRX, the first program header's p_paddr is its file offset.
        self.module, self.gp0, self.stubs = '', 0, {}
        mi_vaddr = None
        if self.prx and phs: mi_off = phs[0][3] & 0x7FFFFFFF; mi_vaddr = phs[0][2] + base + (mi_off - phs[0][1])
        for s in secs:   # .rodata.sceModuleInfo by name
            nm_off = secs[shstrndx][4] + s[0] if shstrndx < len(secs) else None
            if nm_off and elf[nm_off:nm_off + 22] == b'.rodata.sceModuleInfo': mi_vaddr = s[3] + base if self.prx else s[3]
        if mi_vaddr is not None and self.off(mi_vaddr) is not None:
            o = self.off(mi_vaddr)
            self.module = self.data[o + 4:o + 32].split(b'\x00')[0].decode('latin1', 'replace')
            self.gp0, ent_top, ent_end, stub_top, stub_end = struct.unpack_from('<5I', self.data, o + 32)
            a = stub_top
            while stub_top and a + 20 <= stub_end and self.off(a) is not None:
                libp, ver, flags, size, vcount, count, nidp, stubp = struct.unpack_from('<IHHBBHII', self.data, self.off(a))
                lib = ''
                if self.off(libp) is not None:
                    lo = self.off(libp); lib = self.data[lo:lo + 40].split(b'\x00')[0].decode('latin1', 'replace')
                for i in range(count):
                    if self.off(nidp + 4 * i) is None: break
                    nid = struct.unpack_from('<I', self.data, self.off(nidp + 4 * i))[0]
                    self.stubs[stubp + 8 * i] = (NIDS.get(nid) or f'{lib}_{nid:08X}', lib, nid)
                a += max(5, size) * 4
        # symbol table, if the ELF still has one
        self.func_syms = {}
        for s in secs:
            if s[1] == 2 and s[6] < len(secs):
                st = secs[s[6]]; strtab = elf[st[4]:st[4] + st[5]]
                for k in range(s[5] // 16):
                    nm, val, size, info, other, shndx = struct.unpack_from('<IIIBBH', elf, s[4] + 16 * k)
                    if nm and val and info & 0xF == 2:
                        e = strtab.find(b'\x00', nm); self.func_syms[val + base] = strtab[nm:e].decode('latin1', 'replace')
        self.info = f'{self.module or name} (PSP)'
    def off(self, v):
        o = v - self.base
        return o if 0 <= o < len(self.data) else None

def load(path): return Image(path)
def seed_key(img): return 'psp_' + re.sub(r'[^A-Za-z0-9]', '_', img.module or 'game')

def analyze(img):
    extra = set(img.stubs) | set(img.func_syms)
    F = ps1.analyze(img, ra_fn=ra, mode=CS_MODE_MIPS32, extra_starts=extra)
    for k, f in F.items():
        if k in img.stubs:
            n, lib, nid = img.stubs[k]
            f['auto'] = (n, f'System call imported from {lib} (NID 0x{nid:08X}).')
        elif k in img.func_syms:
            f['auto'] = (re.sub(r'[^A-Za-z0-9_]', '_', img.func_syms[k])[:60], "Name from the game's symbol table.")
    if img.pc0 in F and not F[img.pc0].get('auto'):
        F[img.pc0]['auto'] = ('module_start', 'Entry point of the game module.' + (' ' + img.reloc_note if img.reloc_note else ''))
    return F

def ghidra_import(img, rom_path, work):
    """The (relocated) main module laid out at its load address."""
    f = Path(work) / f'{seed_key(img)}.bin'; f.write_bytes(img.data)
    return {'file': str(f), 'thumb': False,
            'args': ['-loader', 'BinaryLoader', '-loader-baseAddr', hex(img.base), '-processor', 'MIPS:LE:32:default']}

def translate(ins, lab, fname, pool, tlook=lambda v: None, enums=None):
    return ps1_plain.translate(ins, lab, fname, tlook, enums or {}, ra)

def builtin_labels(img=None):
    if img is None or not img.gp0 or ra(img.gp0) is None: return []
    return [{'ra': ra(img.gp0), 'size': 1, 'name': 'GP_base', 'builtin': True,
             'note': 'Small-data base held in gp (from the module info). Globals at gp plus or minus 0x8000 are reached from it.'}]

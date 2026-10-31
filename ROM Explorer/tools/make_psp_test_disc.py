"""Build a small PSP-style test: a relocatable PRX (module info, an import stub table, PSP relocations, gp-relative
globals) as PSP_GAME/SYSDIR/EBOOT.BIN in an ISO, the same disc as a CSO, and a disc with an encrypted-looking EBOOT."""
import struct, io, zlib, sys
R = {n: i for i, n in enumerate('zero at v0 v1 a0 a1 a2 a3 t0 t1 t2 t3 t4 t5 t6 t7 s0 s1 s2 s3 s4 s5 s6 s7 t8 t9 k0 k1 gp sp fp ra'.split())}
def I(op, rs, rt, imm): return (op << 26) | (R[rs] << 21) | (R[rt] << 16) | (imm & 0xFFFF)
def J(t): return (3 << 26) | ((t >> 2) & 0x3FFFFFF)
JR_RA, NOP = 0x03E00008, 0
MSG, HEALTH, LIVES, MI, LIBN, STUBENT, NIDTAB = 0x500, 0x600, 0x604, 0x400, 0x440, 0x460, 0x480
GP = HEALTH + 0x8000
STUB0, STUB1, STUB2 = 0x300, 0x308, 0x310
code = {}; relocs = []   # (offset, type)
def put(a, w, rt=None):
    code[a] = w
    if rt: relocs.append((a, rt))
L = {'module_start': 0, 'UpdateHealth': 0x40, 'PrintText': 0x80}
a = 0
for w, rt in [(I(9, 'sp', 'sp', -16), None), (I(43, 'sp', 'ra', 0), None),
              (J(L['UpdateHealth']), 4), (NOP, None), (J(STUB0), 4), (NOP, None), (J(STUB2), 4), (NOP, None),
              (I(15, 'zero', 'a0', 0), 5), (J(L['PrintText']), 4), (I(9, 'a0', 'a0', MSG), 6),
              (I(35, 'sp', 'ra', 0), None), (JR_RA, None), (I(9, 'sp', 'sp', 16), None)]:
    put(a, w, rt); a += 4
a = L['UpdateHealth']
for w, rt in [(I(35, 'gp', 'v0', -0x8000), None), (I(10, 'v0', 't1', 1), None), (I(4, 't1', 'zero', 3), None), (NOP, None),
              (I(9, 'zero', 't2', 3), None), (I(43, 'gp', 't2', -0x8000), None),
              (I(15, 'zero', 't0', 0), 5), (I(35, 't0', 'v1', LIVES), 6), (JR_RA, None), (NOP, None)]:
    put(a, w, rt); a += 4
a = L['PrintText']
for w in (I(36, 'a0', 'v0', 0), JR_RA, NOP): put(a, w); a += 4
for s in (STUB0, STUB1, STUB2): put(s, JR_RA); put(s + 4, NOP)
seg = bytearray(0x700)
for k, w in code.items(): struct.pack_into('<I', seg, k, w)
# module info: attr, version, name[28], gp, ent_top, ent_end, stub_top, stub_end
struct.pack_into('<HH28sIIIII', seg, MI, 0, 0x0101, b'RomxTestGame', GP, 0, 0, STUBENT, STUBENT + 20)
relocs += [(MI + 32, 2), (MI + 44, 2), (MI + 48, 2)]
seg[LIBN:LIBN + 8] = b'sceCtrl\x00'
struct.pack_into('<IHHBBHII', seg, STUBENT, LIBN, 0x11, 0x4001, 5, 0, 3, NIDTAB, STUB0)
relocs += [(STUBENT, 2), (STUBENT + 12, 2), (STUBENT + 16, 2)]
struct.pack_into('<3I', seg, NIDTAB, 0x1F803938, 0x3A622550, 0x12345678)
seg[MSG:MSG + 17] = b'PRESS X TO FIGHT\x00'
# ELF: type 0xFFA0 (PRX), one segment at vaddr 0, p_paddr = file offset of the module info, one 0x700000A0 reloc section
ehsz, phsz = 52, 32; seg_off = 0x60
rel = b''.join(struct.pack('<II', o, t) for o, t in relocs)   # offset base and address base both segment 0
rel_off = seg_off + len(seg); shstr = b'\x00.text\x00.rel.text\x00.rodata.sceModuleInfo\x00.shstrtab\x00'
shstr_off = rel_off + len(rel); sh_off = (shstr_off + len(shstr) + 3) & ~3
def sh(n, t, fl, ad, o, sz, link=0, info=0, al=4, ent=0): return struct.pack('<10I', n, t, fl, ad, o, sz, link, info, al, ent)
shs = [sh(0, 0, 0, 0, 0, 0), sh(1, 1, 6, 0, seg_off, 0x400), sh(7, 0x700000A0, 0, 0, rel_off, len(rel), 0, 1, 4, 8),
       sh(17, 1, 2, MI, seg_off + MI, 52), sh(40, 3, 0, 0, shstr_off, len(shstr), al=1)]
eh = b'\x7fELF' + bytes([1, 1, 1, 0]) + bytes(8) + struct.pack('<HHIIIIIHHHHHH', 0xFFA0, 8, 1, 0, ehsz, sh_off, 0x10A23001,
                                                               ehsz, phsz, 1, 40, len(shs), 4)
ph = struct.pack('<8I', 1, seg_off, 0, seg_off + MI, len(seg), len(seg), 5, 16)
elf = bytearray(eh + ph); elf += bytes(seg_off - len(elf)); elf += seg + rel + shstr; elf += bytes(sh_off - len(elf)); elf += b''.join(shs)
elf = bytes(elf)
out = sys.argv[1] if len(sys.argv) > 1 else '.'
open(f'{out}/test.prx', 'wb').write(elf)
import pycdlib
def disc(name, eboot):
    iso = pycdlib.PyCdlib(); iso.new(interchange_level=3)
    sfo = b'\x00PSF' + bytes(60)
    iso.add_directory('/PSP_GAME'); iso.add_directory('/PSP_GAME/SYSDIR')
    iso.add_fp(io.BytesIO(sfo), len(sfo), '/PSP_GAME/PARAM.SFO;1')
    iso.add_fp(io.BytesIO(eboot), len(eboot), '/PSP_GAME/SYSDIR/EBOOT.BIN;1')
    b = io.BytesIO(); iso.write_fp(b); iso.close(); open(f'{out}/{name}', 'wb').write(b.getvalue()); return b.getvalue()
img = disc('psptest.iso', elf)
disc('psptest_encrypted.iso', b'~PSP' + bytes(0x200))
# CSO v1: zlib raw deflate per 2048-byte block, index of n+1 offsets (bit 31 = stored uncompressed)
n = len(img) // 2048; idx = []; body = bytearray(); start = 0x18 + 4 * (n + 1)
for i in range(n):
    blk = img[i * 2048:(i + 1) * 2048]; c = zlib.compressobj(9, zlib.DEFLATED, -15); z = c.compress(blk) + c.flush()
    if len(z) >= 2048: idx.append((start + len(body)) | 0x80000000); body += blk
    else: idx.append(start + len(body)); body += z
idx.append(start + len(body))
open(f'{out}/psptest.cso', 'wb').write(b'CISO' + struct.pack('<IQIBB2x', 0x18, len(img), 2048, 1, 0) + struct.pack(f'<{n + 1}I', *idx) + body)
print('prx', len(elf), 'relocs', len(relocs))

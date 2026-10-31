"""Build a tiny .nds: ARM9 (ARM + Thumb, partly BLZ-compressed, with NitroSDK module params), ARM7, one compressed overlay."""
import struct
from keystone import Ks, KS_ARCH_ARM, KS_MODE_ARM, KS_MODE_THUMB
A9=0x02000000; THUMB=0x02000400; OVL=0x02200000; A7=0x02380000
def asm(src, addr, mode):
    c,_=Ks(KS_ARCH_ARM, mode).asm(src, addr); return bytes(c)
def blx(frm, to):   # ARM blx imm to Thumb
    off=to-(frm+8); h=(off>>1)&1; return struct.pack('<I', 0xFA000000|(h<<24)|((off>>2)&0xFFFFFF))
def bl(frm, to):
    off=to-(frm+8); return struct.pack('<I', 0xEB000000|((off>>2)&0xFFFFFF))
arm = asm("""
 ldr r0, =0x02100010
 ldr r1, [r0]
 cmp r1, #2
 bne skip
 mov r2, #5
 str r2, [r0, #4]
skip:
 nop
 nop
 b 0x02000000
 .ltorg
""", A9, KS_MODE_ARM)
arm = bytearray(arm)
arm[0x18:0x1C] = blx(A9+0x18, THUMB|0)   # replace first nop: blx to Thumb function
arm[0x1C:0x20] = bl(A9+0x1C, OVL)       # replace second nop: bl into the overlay
thumb = asm("""
 push {r4, lr}
 ldr r0, =0x02000600
 ldrb r1, [r0]
 ldr r2, =0x02100020
 strb r1, [r2]
 pop {r4, pc}
 .ltorg
""", THUMB, KS_MODE_THUMB)
ovl = asm("""
 push {lr}
 ldr r3, =0x02100030
 ldr r0, [r3]
 add r0, r0, #1
 str r0, [r3]
 pop {pc}
 .ltorg
""", OVL, KS_MODE_ARM)
arm9 = bytearray(0x800)
arm9[0:len(arm)] = arm; arm9[0x400:0x400+len(thumb)] = thumb
arm9[0x600:0x600+18] = b'TOUCH TO CONTINUE\x00'
# NitroSDK module params at 0x700 (in the part left uncompressed)
def blz_compress(raw, prefix_len):
    pre, body = raw[:prefix_len], raw[prefix_len:]
    data = body[::-1]; out = bytearray(); i = 0
    while i < len(data):
        fp = len(out); out.append(0); flags = 0
        for bit in range(8):
            if i >= len(data): break
            best = (0, 0)
            for pos in range(3, min(0x1002, i) + 1):
                ln = 0
                while ln < 18 and i + ln < len(data) and data[i + ln] == data[i + ln - pos]: ln += 1
                if ln > best[0]: best = (ln, pos)
            if best[0] >= 3:
                flags |= 0x80 >> bit; v = ((best[0] - 3) << 12) | (best[1] - 3); out += bytes([v >> 8, v & 0xFF]); i += best[0]
            else: out.append(data[i]); i += 1
        out[fp] = flags
    enc = bytes(out[::-1]); pad = (-len(enc)) % 4
    enc_len = len(enc) + pad + 8; hdr_len = pad + 8
    return bytes(pre) + enc + b'\xff' * pad + struct.pack('<II', enc_len | (hdr_len << 24), len(body) - enc_len)
# compress everything after 0x780 is not possible since code is before; put params in the first 0x200 bytes instead:
# layout: keep 0x000-0x0FF uncompressed (code start + params), compress the rest
params_at = 0xE0
arm9_list = bytearray(arm9)
comp = blz_compress(bytes(arm9_list), 0x100)
struct.pack_into('<7I', arm9_list, params_at, 0, 0, 0, 0x02100000, 0x02101000, A9 + len(comp), 0x04020000)
arm9_list[params_at+0x1C:params_at+0x24] = b'\x21\x06\xC0\xDE\xDE\xC0\x06\x21'
comp = blz_compress(bytes(arm9_list), 0x100)
struct.pack_into('<I', arm9_list, params_at + 0x14, A9 + len(comp))
arm9_final = blz_compress(bytes(arm9_list), 0x100)
assert len(arm9_final) == len(comp)
arm7 = asm("bx lr", A7, KS_MODE_ARM)
ovl_c = blz_compress(ovl + b'\x00' * 32, 0)
# ROM: header 0x200, arm9 at 0x4000, arm7 at 0x8000, ovl file at 0xA000, FAT at 0xC000, ov table at 0xC100
rom = bytearray(0x10000)
rom[0:12] = b'ROMX TEST DS'; rom[0x0C:0x10] = b'RXTE'
struct.pack_into('<8I', rom, 0x20, 0x4000, A9, A9, len(arm9_final), 0x8000, A7, A7, len(arm7))
struct.pack_into('<8I', rom, 0x40, 0, 0, 0xC000, 8, 0xC100, 32, 0, 0)
rom[0x15C:0x15E] = b'\x56\xCF'
rom[0x4000:0x4000+len(arm9_final)] = arm9_final; rom[0x8000:0x8000+len(arm7)] = arm7; rom[0xA000:0xA000+len(ovl_c)] = ovl_c
struct.pack_into('<II', rom, 0xC000, 0xA000, 0xA000 + len(ovl_c))
struct.pack_into('<8I', rom, 0xC100, 0, OVL, 0x1000, 0, 0, 0, 0, 0x01000000 | len(ovl_c))
open('test.nds', 'wb').write(rom)
open('arm9_plain.bin','wb').write(bytes(arm9_list)); open('ovl_plain.bin','wb').write(ovl + b'\x00'*32)
print('arm9', len(arm9_list), '->', len(arm9_final), ' ovl', len(ovl)+32, '->', len(ovl_c))

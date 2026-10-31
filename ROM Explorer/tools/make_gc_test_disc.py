"""Build a tiny GameCube test disc: main.dol with __start (sets r13/r2), a few functions, text and a vtable."""
import struct
from keystone import Ks, KS_ARCH_PPC, KS_MODE_PPC32, KS_MODE_BIG_ENDIAN
TEXT=0x80003100; DATA=0x80200000
src = """
__start:
 lis 13,0x8021
 addi 13,13,-0x8000
 lis 2,0x8022
 ori 2,2,0x0000
 bl main
 b __start
main:
 stwu 1,-16(1)
 mflr 0
 stw 0,20(1)
 bl check_mode
 bl show_title
 lwz 0,20(1)
 mtlr 0
 addi 1,1,16
 blr
check_mode:
 lis 3,0x8034
 lwz 4,0x1234(3)
 cmpwi 4,2
 bne skip
 li 5,3
 stw 5,0x1238(3)
skip:
 lwz 6,-0x7f20(13)
 cmplwi 7,6,10
 bge 7,done
 li 0,0
 stb 0,0x10(13)
done:
 blr
show_title:
 stwu 1,-16(1)
 mflr 0
 stw 0,20(1)
 lis 3,0x8020
 addi 3,3,0x100
 bl draw_text
 lwz 0,20(1)
 mtlr 0
 addi 1,1,16
 blr
draw_text:
 lbz 4,0(3)
 blr
virt_update:
 stwu 1,-16(1)
 lwz 3,0x8(3)
 addi 1,1,16
 blr
"""
ks=Ks(KS_ARCH_PPC, KS_MODE_PPC32+KS_MODE_BIG_ENDIAN)
code,_=ks.asm(src,TEXT); code=bytes(code)
# find virt_update address: count instructions
lines=[l.strip() for l in src.strip().split('\n')]; n=0; addr={}
for l in lines:
    if l.endswith(':'): addr[l[:-1]]=TEXT+4*n
    elif l: n+=1
data=bytearray(0x400)
data[0x100:0x100+19]=b'PRESS START TO PLAY'
data[0x200:0x208]=struct.pack('>II', addr['virt_update'], addr['virt_update'])   # a little vtable
# DOL
hdr=bytearray(0x100)
text_off=0x100; data_off=text_off+len(code)+(-len(code))%32
struct.pack_into('>I',hdr,0x00,text_off); struct.pack_into('>I',hdr,0x48,TEXT); struct.pack_into('>I',hdr,0x90,len(code))
struct.pack_into('>I',hdr,0x1C,data_off); struct.pack_into('>I',hdr,0x64,DATA); struct.pack_into('>I',hdr,0xAC,len(data))
struct.pack_into('>III',hdr,0xD8,0x80300000,0x1000,addr['__start'])
dol=bytes(hdr)+code+b'\x00'*((-len(code))%32)+bytes(data)
open('main.dol','wb').write(dol)
# disc: header, DOL at 0x20000, tiny FST
iso=bytearray(0x40000)
iso[0:6]=b'GTSE01'; struct.pack_into('>I',iso,0x1C,0xC2339F3D); iso[0x20:0x20+15]=b'ROM EXPLORER GC'
struct.pack_into('>III',iso,0x420,0x20000,0x30000,12)
iso[0x20000:0x20000+len(dol)]=dol
struct.pack_into('>III',iso,0x30000,0x01000000,0,1)
open('gctest.iso','wb').write(iso)
print('ok', {k:hex(v) for k,v in addr.items()})

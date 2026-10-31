"""Build a small PS1 test disc: a PS-X EXE with a few functions, in an ISO and a raw BIN/CUE."""
import struct, io
from keystone import Ks, KS_ARCH_MIPS, KS_MODE_MIPS32, KS_MODE_LITTLE_ENDIAN
BASE=0x80010000; GP=0x80098000
src = """
main:
  addiu $sp, $sp, -24
  sw $ra, 20($sp)
  jal check_mode
  nop
  jal show_title
  nop
  lw $ra, 20($sp)
  jr $ra
  addiu $sp, $sp, 24
check_mode:
  lui $t0, 0x8009
  lw $v0, 0x1234($t0)
  addiu $at, $zero, 2
  bne $v0, $at, skip
  nop
  lui $t1, 0x8009
  addiu $t2, $zero, 5
  sw $t2, 0x1238($t1)
skip:
  lw $v1, -0x7ff0($gp)
  slti $t3, $v1, 10
  beq $t3, $zero, done
  nop
  sb $zero, 0x10($gp)
done:
  jr $ra
  nop
show_title:
  addiu $sp, $sp, -24
  sw $ra, 16($sp)
  lui $a0, 0x8001
  jal draw_text
  addiu $a0, $a0, 0x400
  lui $a0, 0x8001
  addiu $a0, $a0, 0x440
  jal draw_text
  addiu $a1, $zero, 3
  lw $ra, 16($sp)
  jr $ra
  addiu $sp, $sp, 24
draw_text:
  addiu $sp, $sp, -8
  lbu $v0, 0($a0)
  addiu $sp, $sp, 8
  jr $ra
  nop
"""
ks=Ks(KS_ARCH_MIPS, KS_MODE_MIPS32+KS_MODE_LITTLE_ENDIAN)
import re
src='.set noreorder\n.set nomacro\n'+src
# keystone turns jal into PIC calls, so encode jal by hand: placeholder words, then patch
lines=src.split('\n'); calls=[]
for i,l in enumerate(lines):
    m=re.match(r'\s*jal (\w+)$',l)
    if m: calls.append((i,m.group(1))); lines[i]='  .word 0'
def addr_of(label):
    idx=[i for i,l in enumerate(lines) if l.strip()==label+':'][0]
    c,_=ks.asm('\n'.join(lines[:idx])+'\n',BASE) if idx else ([],0); return BASE+len(c or [])
code=bytearray(ks.asm('\n'.join(lines),BASE)[0])
for i,lbl in calls:
    c,_=ks.asm('\n'.join(lines[:i])+'\n',BASE); off=len(c or [])
    t=addr_of(lbl); code[off:off+4]=((3<<26)|((t>>2)&0x3FFFFFF)).to_bytes(4,'little')
code=bytes(code)
body=bytearray(0x800); body[:len(code)]=code
body[0x400:0x400+19]=b'PRESS START BUTTON\x00'
body[0x440:0x440+16]=b'SELECT A ROBOT \x00'[:16]
# a pointer table of menu strings
strs=[b'NEW GAME\x00',b'LOAD GAME\x00',b'OPTIONS MENU\x00',b'SOUND TEST\x00']; o=0x500; ptrs=[]
for s in strs: body[o:o+len(s)]=s; ptrs.append(BASE+o); o+=16
body[0x600:0x610]=struct.pack('<4I',*ptrs)
hdr=bytearray(0x800); hdr[:8]=b'PS-X EXE'
struct.pack_into('<IIII',hdr,0x10,BASE,GP,BASE,len(body)); hdr[0x4c:0x4c+30]=b'Sony Computer Entertainment Inc'[:30]
exe=bytes(hdr+body); open('SLUS_999.99','wb').write(exe)
import pycdlib
iso=pycdlib.PyCdlib(); iso.new()
cnf=b'BOOT = cdrom:\\SLUS_999.99;1\r\nTCB = 4\r\nEVENT = 10\r\nSTACK = 801FFFF0\r\n'
iso.add_fp(io.BytesIO(cnf),len(cnf),'/SYSTEM.CNF;1'); iso.add_fp(io.BytesIO(exe),len(exe),'/SLUS_999.99;1')
iso.write('test.iso'); iso.close()
d=open('test.iso','rb').read(); out=bytearray()
for i in range(len(d)//2048):
    sec=b'\x00'+b'\xff'*10+b'\x00'+bytes([0,2,0])+b'\x02'+b'\x00\x00\x08\x00'*2+d[i*2048:(i+1)*2048]+b'\x00'*280
    out+=sec
open('test.bin','wb').write(out); open('test.cue','w').write('FILE "test.bin" BINARY\n  TRACK 01 MODE2/2352\n    INDEX 01 00:00:00\n')
print('exe',len(exe),'iso',len(d),'bin',len(out))

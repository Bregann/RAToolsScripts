"""Build a small PS2-style test disc: a MIPS ELF with a symbol table, inside an ISO with SYSTEM.CNF BOOT2."""
import struct, io, re
from keystone import Ks, KS_ARCH_MIPS, KS_MODE_MIPS64, KS_MODE_LITTLE_ENDIAN
TEXT=0x00100000; DATA=0x00200000; GP=0x00208000
src = """
main:
  addiu $sp, $sp, -32
  sd $ra, 16($sp)
  lui $gp, 0x0020
  addiu $gp, $gp, -0x8000
  jal UpdateHealth
  nop
  jal ShowMessage
  nop
  ld $ra, 16($sp)
  jr $ra
  addiu $sp, $sp, 32
UpdateHealth:
  lui $t0, 0x0030
  lw $v0, 0x10($t0)
  slti $t1, $v0, 1
  beq $t1, $zero, alive
  nop
  addiu $t2, $zero, 3
  sw $t2, -0x7ff0($gp)
alive:
  lui $t3, 0x7000
  lw $v1, 0x20($t3)
  ld $a0, 0x18($t0)
  jr $ra
  nop
ShowMessage:
  addiu $sp, $sp, -16
  sd $ra, 0($sp)
  lui $a0, 0x0020
  jal PrintText
  addiu $a0, $a0, 0x100
  ld $ra, 0($sp)
  jr $ra
  addiu $sp, $sp, 16
PrintText:
  lbu $v0, 0($a0)
  jr $ra
  nop
"""
ks=Ks(KS_ARCH_MIPS, KS_MODE_MIPS64+KS_MODE_LITTLE_ENDIAN)
src='.set noreorder\n.set nomacro\n'+src
lines=src.split('\n'); calls=[]
for i,l in enumerate(lines):
    m=re.match(r'\s*jal (\w+)$',l)
    if m: calls.append((i,m.group(1))); lines[i]='  .word 0'
def off_of(i):
    # every real instruction is 4 bytes (no macros), so count them
    return 4*sum(1 for l in lines[:i] if l.strip() and not l.strip().endswith(':') and not l.strip().startswith('.set'))
labels={l.strip()[:-1]:TEXT+off_of(i) for i,l in enumerate(lines) if re.match(r'^\w+:$',l.strip())}
code=bytearray(ks.asm('\n'.join(lines),TEXT)[0])
for i,lbl in calls:
    o=off_of(i); t=labels[lbl]; code[o:o+4]=((3<<26)|((t>>2)&0x3FFFFFF)).to_bytes(4,'little')
code=bytes(code)
data=bytearray(0x200); data[0x100:0x100+16]=b'PRESS X TO FIGHT'; data[0x110]=0
# ELF
segs=[(TEXT,code,5),(DATA,bytes(data),6)]
strtab=b'\x00'; syms=[(0,0,0,0,0,0)]
def addsym(name,val,size,typ):
    global strtab
    off=len(strtab); strtab+=name.encode()+b'\x00'; syms.append((off,val,size,typ|(1<<4),0,1))
for n,a in labels.items(): addsym(n,a,0,2)
addsym('g_PlayerHealth',0x00300010,4,1); addsym('g_Lives',GP-0x7ff0,4,1); addsym('_gp',GP,0,0)
symtab=b''.join(struct.pack('<IIIBBH',*s) for s in syms)
shstr=b'\x00.text\x00.data\x00.symtab\x00.strtab\x00.shstrtab\x00'
ehsz=52; phsz=32; nph=len(segs)
off=ehsz+phsz*nph; off=(off+15)&~15
body=bytearray(); phs=[]
for v,b,f in segs:
    po=off+len(body); body+=b; body+=b'\x00'*((-len(body))%16); phs.append(struct.pack('<8I',1,po,v,v,len(b),len(b),f,16))
so_sym=off+len(body); body+=symtab
so_str=off+len(body); body+=strtab
so_sh=off+len(body); body+=shstr; body+=b'\x00'*((-len(body))%4)
shoff=off+len(body)
def sh(name,typ,flags,addr,o,size,link=0,info=0,align=4,ent=0): return struct.pack('<10I',name,typ,flags,addr,o,size,link,info,align,ent)
shs=[sh(0,0,0,0,0,0),sh(1,1,6,TEXT,phs and struct.unpack('<8I',phs[0])[1],len(code)),sh(7,1,3,DATA,struct.unpack('<8I',phs[1])[1],len(data)),
     sh(13,2,0,0,so_sym,len(symtab),4,1,4,16),sh(21,3,0,0,so_str,len(strtab),0,0,1),sh(29,3,0,0,so_sh,len(shstr),0,0,1)]
eh=b'\x7fELF'+bytes([1,1,1,0])+b'\x00'*8+struct.pack('<HHIIIIIHHHHHH',2,8,1,labels['main'],ehsz,shoff,0x20924001,ehsz,phsz,nph,40,len(shs),5)
elf=eh+b''.join(phs); elf+=b'\x00'*(off-len(elf)); elf+=bytes(body)+b''.join(shs)
open('SLUS_200.01','wb').write(elf)
import pycdlib
iso=pycdlib.PyCdlib(); iso.new()
cnf=b'BOOT2 = cdrom0:\\SLUS_200.01;1\r\nVER = 1.00\r\nVMODE = NTSC\r\n'
iso.add_fp(io.BytesIO(cnf),len(cnf),'/SYSTEM.CNF;1'); iso.add_fp(io.BytesIO(elf),len(elf),'/SLUS_200.01;1')
iso.write('ps2test.iso'); iso.close(); print('elf',len(elf),labels)

"""Game Boy Advance: the whole ROM is code and data mapped at 0x08000000, CPU is ARM7 (Thumb)."""
from .. import progress as PG
import struct
from capstone import Cs, CS_ARCH_ARM, CS_MODE_THUMB
from . import gba_plain

NAME = 'Game Boy Advance'
KEY = 'gba'
EXTS = ('.gba', '.agb')
BUS = 'GBA'
PTR_SIZE = 4
CPU = 'ARM7 (Thumb)'
import re

def detect(path, head):
    return path.lower().endswith(EXTS) or head[0xB2:0xB3] == b'\x96'

def ra(v):
    """GBA bus address -> RetroAchievements address (IWRAM at 0, EWRAM from 0x8000)."""
    if 0x02000000 <= v < 0x02040000: return 0x8000 + v - 0x02000000
    if 0x03000000 <= v < 0x03008000: return v - 0x03000000
    return None

RA_RANGES = [(0x02000000, 0x02040000, 0x8000), (0x03000000, 0x03008000, 0)]
def bus(r):
    return r + 0x02000000 - 0x8000 if r >= 0x8000 else r + 0x03000000

def mem_region(r):
    return 'EWRAM' if r >= 0x8000 else 'IWRAM'

class Image:
    def __init__(self, path):
        self.data = open(path, 'rb').read(); self.base = 0x08000000
        self.title = self.data[0xA0:0xAC].decode('latin1').strip('\x00 ') or 'GBA ROM'
        self.code = self.data[0xAC:0xB0].decode('latin1')
        self.info = f'{self.title} [{self.code}]'
    def off(self, v):
        o = v - self.base
        return o if 0 <= o < len(self.data) else None

def load(path): return Image(path)

def analyze(img):
    ROM = img.data; BASE = img.base; N = len(ROM)
    PG.say(f'Looking through {N // 1024:,} KB of ROM for Thumb calls (BL) and function tables…')
    hw = lambda o: ROM[o] | ROM[o+1] << 8
    # 1. functions = targets of Thumb BL pairs that start with push
    calls = {}
    for o in range(0, N - 4, 2):
        a, b = hw(o), hw(o+2)
        if a & 0xF800 == 0xF000 and b & 0xF800 == 0xF800:
            off = ((a & 0x7FF) << 12) | ((b & 0x7FF) << 1)
            if off & 0x400000: off -= 0x800000
            t = o + 4 + off
            if 0 <= t < N and (hw(t) & 0xFE00) == 0xB400:
                calls.setdefault(t, []).append(o)
    # also functions reached through pointer tables (state machines, callbacks): odd Thumb pointers to a push
    ptrs = {}
    for o in range(0, N - 4, 4):
        v = struct.unpack_from('<I', ROM, o)[0]
        if v & 1 and BASE <= v < BASE + N:
            t = (v & ~1) - BASE
            if (hw(t) & 0xFE00) == 0xB400: ptrs.setdefault(t, []).append(o)
    for t in ptrs: calls.setdefault(t, [])
    starts = sorted(calls)
    md = Cs(CS_ARCH_ARM, CS_MODE_THUMB); md.skipdata = True
    funcs = {}
    for i, s in enumerate(starts):
        end = min(starts[i+1] if i+1 < len(starts) else N, s + 0x1000)
        ins, refs, callees = [], [], set()
        for x in md.disasm(ROM[s:end], BASE + s):
            line = {'a': x.address, 't': f'{x.mnemonic} {x.op_str}'.strip()}
            o = x.address - BASE
            h = hw(o)
            if h & 0xF800 == 0x4800:  # ldr rX, [pc, #imm]
                la = ((o + 4) & ~3) + (h & 0xFF) * 4
                if la + 4 <= N:
                    v = struct.unpack_from('<I', ROM, la)[0]; line['lit'] = v
                    r = ra(v)
                    if r is not None:
                        reg = (h >> 8) & 7; kind = 'ref'
                        # peek ahead: does the next use of this reg store or load through it?
                        j = len(ins)
                        refs.append({'ra': r, 'at': x.address, 'reg': reg})
            if x.mnemonic == 'bl':
                try:
                    t = int(x.op_str.lstrip('#'), 16) - BASE
                    if t in calls: callees.add(t); line['call'] = t + BASE
                except ValueError: pass
            ins.append(line)
            if len(ins) > 700: break
            # stop after a return once we're past all branch targets we've seen
            if x.mnemonic in ('bx',) and x.op_str in ('lr', 'r0', 'r1', 'r2', 'r3') or (x.mnemonic == 'pop' and 'pc' in x.op_str):
                nxt = x.address + x.size - BASE
                # keep going only if a branch inside the function jumps past here
                far = max([int(l['t'].split('#')[-1], 16) for l in ins if l['t'][:1] == 'b' and '#0x' in l['t'] and not l['t'].startswith('bl ')] or [0])
                if far - BASE < nxt: break
        # classify each ref as read / write by looking at the next few instructions using that register
        for rf in refs:
            k = next(n for n, l in enumerate(ins) if l['a'] == rf['at'])
            rw = set()
            for l in ins[k+1:k+8]:
                t = l['t']; r = f"[r{rf['reg']}"
                if r in t:
                    rw.add('W' if t.startswith('str') else 'R')
                elif t.split(' ')[1:2] and t.split(' ')[1].startswith(f"r{rf['reg']},"): break  # reg overwritten
            rf['rw'] = ''.join(sorted(rw)) or 'ptr'
            del rf['reg']
        funcs[s + BASE] = {'start': s + BASE, 'n': len(ins), 'ins': ins, 'refs': refs,
                           'callers': sorted({c + BASE for c in calls[s]}), 'ptrrefs': [p + BASE for p in ptrs.get(s, [])][:20], 'callees': sorted(c + BASE for c in callees)}
    # struct fields: ldr rX,=base followed by adds rX,#off counts as a reference to base+off
    for k, f in funcs.items():
        ins = f['ins']; idx = {l['a']: i for i, l in enumerate(ins)}
        for rf in list(f['refs']):
            i = idx[rf['at']]; m = re.match(r'ldr (r\d), \[pc', ins[i]['t'])
            if not m: continue
            reg = m.group(1)
            for l in ins[i+1:i+5]:
                mm = re.match(rf'(?:adds|add) {reg}, #(0x[0-9a-f]+|\d+)$', l['t'])
                if mm:
                    f['refs'].append({'ra': rf['ra'] + int(mm.group(1), 0), 'at': l['a'], 'rw': 'base+off'}); break
                if l['t'].split(' ')[1:2] == [reg + ','] and not l['t'].startswith(('str', 'cmp', 'tst')): break
    return funcs

def pool(f):
    """Addresses inside the function that are data (literal pools), not instructions."""
    out = set()
    for l in f['ins']:
        m = re.match(r'ldr r\d, \[pc, #(0x[0-9a-f]+|\d+)\]', l['t'])
        if m:
            la = ((l['a'] + 4) & ~3) + int(m.group(1), 0); out.update((la, la + 2))
    return out

translate = gba_plain.translate

def seed_key(img): return 'gba_' + img.code

def ghidra_import(img, rom_path, work):
    """How Ghidra should load this game: a raw ROM at 0x08000000 on an ARM7 (Thumb functions)."""
    return {'file': str(rom_path), 'thumb': True,
            'args': ['-loader', 'BinaryLoader', '-loader-baseAddr', '0x08000000', '-processor', 'ARM:LE:32:v4t']}

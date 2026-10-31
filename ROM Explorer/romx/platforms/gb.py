"""Game Boy / Game Boy Color. CPU is the Sharp SM83 (8-bit, Z80-like).
ROM is banked: 0x0000-0x3FFF is always bank 0, 0x4000-0x7FFF is whichever bank the game switched in.
Addresses inside the tool are written as (bank << 16) | address, shown as BB:AAAA."""
from .. import progress as PG
import struct
from . import sm83, gb_plain

NAME = 'Game Boy / Game Boy Color'
KEY = 'gb'
EXTS = ('.gb', '.gbc', '.cgb', '.sgb')
BUS = 'GB'
CPU = 'Sharp SM83'

def detect(path, head):
    return path.lower().endswith(EXTS) or head[0x104:0x108] == bytes.fromhex('ceed6666')

# ---- RetroAchievements: the GB bus address is the RA address (0x0000-0xFFFF); extra GBC WRAM banks sit at 0x10000+ ----
def ra(v):
    if 0x8000 <= v <= 0xFFFF:
        return v - 0x2000 if 0xE000 <= v < 0xFE00 else v  # echo RAM mirrors C000
    return None
def bus(r): return r
def canon(r): return r - 0x2000 if 0xE000 <= r < 0xFE00 else r
def mem_region(r):
    if 0xE000 <= r < 0xFE00: return f'Echo RAM (same memory as 0x{r - 0x2000:04X})'
    for lo, hi, n in ((0x8000, 0x9FFF, 'Video RAM'), (0xA000, 0xBFFF, 'Cartridge RAM'), (0xC000, 0xCFFF, 'WRAM bank 0'),
                      (0xD000, 0xDFFF, 'WRAM bank 1 (switchable on GBC)'), (0xFE00, 0xFE9F, 'Sprite RAM'), (0xFF00, 0xFF7F, 'Hardware I/O'),
                      (0xFF80, 0xFFFE, 'HRAM'), (0xFFFF, 0xFFFF, 'Interrupt enable'), (0x10000, 0x15FFF, 'GBC WRAM banks 2-7'), (0x16000, 0x33FFF, 'Cartridge RAM banks 1-15')):
        if lo <= r <= hi: return n
    return ''

HW = {0xFF00: ('P1', 'Joypad'), 0xFF01: ('SB', 'Serial data'), 0xFF02: ('SC', 'Serial control'), 0xFF04: ('DIV', 'Divider'),
      0xFF05: ('TIMA', 'Timer counter'), 0xFF06: ('TMA', 'Timer modulo'), 0xFF07: ('TAC', 'Timer control'), 0xFF0F: ('IF', 'Interrupt flags'),
      0xFF10: ('NR10', 'Sound'), 0xFF11: ('NR11', 'Sound'), 0xFF12: ('NR12', 'Sound'), 0xFF13: ('NR13', 'Sound'), 0xFF14: ('NR14', 'Sound'),
      0xFF24: ('NR50', 'Sound volume'), 0xFF25: ('NR51', 'Sound panning'), 0xFF26: ('NR52', 'Sound on/off'),
      0xFF40: ('LCDC', 'LCD control'), 0xFF41: ('STAT', 'LCD status'), 0xFF42: ('SCY', 'Scroll Y'), 0xFF43: ('SCX', 'Scroll X'),
      0xFF44: ('LY', 'Current scanline'), 0xFF45: ('LYC', 'Scanline compare'), 0xFF46: ('DMA', 'Sprite DMA'), 0xFF47: ('BGP', 'BG palette (GB)'),
      0xFF48: ('OBP0', 'Sprite palette 0 (GB)'), 0xFF49: ('OBP1', 'Sprite palette 1 (GB)'), 0xFF4A: ('WY', 'Window Y'), 0xFF4B: ('WX', 'Window X'),
      0xFF4D: ('KEY1', 'GBC speed switch'), 0xFF4F: ('VBK', 'GBC VRAM bank'), 0xFF51: ('HDMA1', 'GBC DMA'), 0xFF52: ('HDMA2', 'GBC DMA'),
      0xFF53: ('HDMA3', 'GBC DMA'), 0xFF54: ('HDMA4', 'GBC DMA'), 0xFF55: ('HDMA5', 'GBC DMA start'), 0xFF56: ('RP', 'GBC infrared'),
      0xFF68: ('BCPS', 'GBC BG palette index'), 0xFF69: ('BCPD', 'GBC BG palette data'), 0xFF6A: ('OCPS', 'GBC sprite palette index'),
      0xFF6B: ('OCPD', 'GBC sprite palette data'), 0xFF70: ('SVBK', 'GBC WRAM bank'), 0xFFFF: ('IE', 'Interrupt enable')}
def builtin_labels(img=None):
    return [{'ra': a, 'size': 1, 'name': n, 'note': f'Hardware register: {d}', 'builtin': True} for a, (n, d) in HW.items()]

def fmt(a): return f'{a >> 16:02X}:{a & 0xFFFF:04X}'
def sub_name(a): return f'sub_{a >> 16:02X}_{a & 0xFFFF:04X}'

class Image:
    def __init__(self, path):
        self.data = open(path, 'rb').read(); self.base = 0
        self.banks = max(2, len(self.data) // 0x4000)
        self.title = self.data[0x134:0x13F if self.data[0x143] in (0x80, 0xC0) else 0x144].split(b'\x00')[0].decode('latin1').strip()
        self.cgb = self.data[0x143] in (0x80, 0xC0)
        self.code = self.data[0x13F:0x143].decode('latin1') if self.cgb else ''
        self.cart = self.data[0x147]
        self.info = f'{self.title.title()} ({"GBC" if self.cgb else "GB"})'
    def off(self, v):
        """encoded (bank<<16)|addr -> file offset"""
        b, a = v >> 16, v & 0xFFFF
        if a < 0x4000: o = a if b == 0 else None
        elif a < 0x8000: o = b * 0x4000 + a - 0x4000 if b >= 1 else None
        else: o = None
        return o if o is not None and o < len(self.data) else None

def load(path): return Image(path)
def seed_key(img): return f'gb_{img.code or img.title.replace(" ", "_")}'

MBC_LO, MBC_HI = 0x2000, 0x3FFF   # writes here pick the ROM bank (MBC1/3/5)
PART = {'b': 'bc', 'c': 'bc', 'd': 'de', 'e': 'de', 'h': 'hl', 'l': 'hl'}
def track(rv, d):
    """Keep the constant values of registers up to date (enough to follow bank switches and far calls)."""
    t = d['t']; op = d['op']
    def kill(r):
        rv.pop(r, None)
        if r in PART: rv.pop(PART[r], None)
        if r in ('bc', 'de', 'hl'):
            for p, q in PART.items():
                if q == r: rv.pop(p, None)
    if op == 'ld' and t[2:3] == ' ' and ',' in t:
        dst, src = t[3:].split(',', 1)
        if dst in ('a', 'b', 'c', 'd', 'e', 'h', 'l'):
            kill(dst)
            if src.startswith('0x'): rv[dst] = int(src, 16)
            elif dst == 'a' and src.startswith('(0x'): rv['a'] = ('m', int(src[1:-1], 16))
            elif src in rv and src in 'abcdehl': rv[dst] = rv[src]
        elif dst in ('bc', 'de', 'hl', 'sp'):
            kill(dst)
            if src.startswith('0x'):
                v = int(src, 16); rv[dst] = v
                p = {'bc': 'bc', 'de': 'de', 'hl': 'hl'}.get(dst)
                if p: rv[p[0]] = v >> 8; rv[p[1]] = v & 0xFF
        elif src in ('(hl+)', '(hl-)') or dst in ('(hl+)', '(hl-)'):
            tb = rv.get('table'); kill('hl')
            if tb is not None: rv['table'] = tb
        if src in ('(hl+)', '(hl-)'): kill('a')
    elif t == 'xor a': rv['a'] = 0
    elif op in ('ldh',) and t.startswith('ldh a'): kill('a'); rv['a'] = ('m', d['mem'])
    elif op in ('inc', 'dec', 'pop', 'swap', 'rl', 'rr', 'rlc', 'rrc', 'sla', 'sra', 'srl', 'res', 'set'):
        r = t.split(' ')[1].split(',')[-1]
        if r == 'af': kill('a')
        elif not r.startswith('('): kill(r)
    elif op in ('add', 'adc', 'sub', 'sbc', 'and', 'or', 'xor', 'cpl', 'rla', 'rra', 'rlca', 'rrca', 'daa') and t not in ('or a', 'and a'):
        if t.startswith('add hl') and isinstance(rv.get('hl'), int): base = rv['hl']; kill('hl'); rv['table'] = base; return
        kill('hl' if t.startswith('add hl') else 'a')
FLOW_END = ('ret', 'reti')

def analyze(img):
    D = img.data
    def at(enc):
        o = img.off(enc)
        return None if o is None else sm83.decode(D, o, enc & 0xFFFF)
    # bank switch helpers: short routines that write A into the MBC bank register
    switchers = set()
    def is_switcher(enc):
        a = enc
        for _ in range(6):
            d = at(a)
            if not d: return False
            if d['op'] == 'ld' and d.get('mem') and MBC_LO <= d['mem'] <= MBC_HI and d['t'].endswith(',a'): return True
            if d['op'] in FLOW_END or d['op'] == 'jp': return False
            a += d['size']
        return False
    farcalls = {}
    def farcall_reg(enc):
        """Bank-0 helpers that switch to the bank held in a register and jump to HL. Returns that register."""
        if enc in farcalls: return farcalls[enc]
        a = enc; src = None; switched = False; res = None
        for _ in range(24):
            d = at(a)
            if not d: break
            t = d['t']
            if t.startswith('ld a,') and t[5:] in ('b', 'c', 'd', 'e'): src = t[5:]
            if (d['op'] == 'ld' and d.get('mem') and MBC_LO <= d['mem'] <= MBC_HI and t.endswith(',a')) or (d['op'] == 'rst' and d.get('target') in switchers):
                if src is not None: switched = src
            if t == 'jp hl':
                res = switched or None; break
            if d['op'] in ('ret', 'reti'): break
            a += d['size']
        farcalls[enc] = res
        return res
    starts = {0x100}
    for v in range(0, 0x40, 8):
        if D[v] != 0xFF: starts.add(v)
    for v in (0x40, 0x48, 0x50, 0x58, 0x60):
        if D[v] not in (0xFF, 0xD9): starts.add(v)
    for v in list(starts):
        if is_switcher(v): switchers.add(v)
    funcs = {}; calls = {}
    todo = sorted(starts); seen = set()
    guessed = set()
    def scan_for_more():
        """Second pass: calls found by scanning the raw bytes of each bank (code reached through tables or
        variables the first pass can't follow). Only kept when the target looks like the start of a function."""
        got = {}
        for b in range(img.banks):
            lo = b * 0x4000; B = D[lo:lo + 0x4000]
            for i in range(len(B) - 2):
                if B[i] != 0xCD: continue
                t = B[i + 1] | B[i + 2] << 8
                if b == 0 and t < 0x4000: enc = t
                elif b and 0x4000 <= t < 0x8000: enc = (b << 16) | t
                else: continue
                got[enc] = got.get(enc, 0) + 1
        out = []
        for enc, n in got.items():
            if enc in seen: continue
            o = img.off(enc)
            if o is None or D[o] in (0xFF, 0x00): continue
            prev = D[o - 1] if o else 0xC9
            ok = n >= 2 or prev in (0xC9, 0xD9, 0xC3, 0x18, 0xE9)
            if not ok: continue
            a2 = enc; good = 0
            for _ in range(6):   # the first few instructions must decode cleanly
                d = at(a2)
                if not d or D[img.off(a2)] == 0xFF: break
                good += 1; a2 += d['size']
                if d['op'] in ('ret', 'reti', 'jp'): good = 6; break
            if good >= 4: out.append(enc)
        return out
    varcalls = []; consts = {}; maybe = {}
    def from_bank_variables():
        """Code that switches to a bank read from RAM: try every constant the game ever writes to that RAM byte."""
        out = []
        for var, tgt, site in varcalls:
            cands = sorted(b for b in consts.get(var, ()) if 1 <= b < img.banks)
            if not cands or len(cands) > 24: continue
            for b in cands:
                enc = (b << 16) | tgt; o = img.off(enc)
                if o is None or D[o] in (0xFF, 0x00): continue
                good = 0; a2 = enc
                for _ in range(5):
                    d = at(a2)
                    if not d or D[img.off(a2)] == 0xFF: break
                    good += 1; a2 += d['size']
                    if d['op'] in ('ret', 'reti', 'jp'): good = 5; break
                if good >= 4:
                    maybe.setdefault(enc, set()).add((site, var)); calls.setdefault(enc, []).append(site); out.append(enc)
        return out
    # Threaded "script" code: some games keep their logic as lists of routine addresses and end each routine
    # with a jump to a tiny routine in RAM that fetches the next address (e.g. jp 0xC681). Find those RAM
    # targets, then the routines whose addresses appear in the lists.
    ram_jumps = {}
    for i in range(len(D) - 2):
        if D[i] in (0xC3, 0xCA, 0xC2, 0xDA, 0xD2) and D[i + 2] >= 0xC0 and D[i + 2] < 0xE0:
            w = D[i + 1] | D[i + 2] << 8; ram_jumps[w] = ram_jumps.get(w, 0) + 1
    tramps = {w for w, n in ram_jumps.items() if n >= 8}
    script_refs = {}
    def find_script_handlers():
        if not tramps: return []
        memo = {}
        def reaches(a):
            if a in memo: return memo[a]
            o = a; ok = False
            for _ in range(60):
                if o >= len(D) or D[o] == 0xFF: break
                d = sm83.decode(D, o, o)
                if not d: break
                if d['op'] == 'jp' and d.get('target') in tramps: ok = True; break
                if d['t'] in ('ret', 'reti', 'jp hl'): break
                if d['op'] == 'jp' and ',' not in d['t'] and d.get('target', 0xFFFF) < 0x4000: o = d['target']; continue
                o += d['size']
                if o >= 0x4000: break
            memo[a] = ok; return ok
        out = set()
        for i in range(len(D) - 1):
            w = D[i] | D[i + 1] << 8
            if not (0x150 <= w < 0x4000) or w in seen: continue
            prev = D[w - 3:w]
            boundary = (prev[0] in (0xC3,) and (prev[2] >= 0xC0)) or D[w - 1] in (0xC9, 0xD9)
            if boundary and reaches(w):
                out.add(w); b = i // 0x4000
                pos = (b << 16) | ((i % 0x4000) + (0x4000 if b else 0))
                script_refs.setdefault(w, []).append(pos)
        return sorted(out)
    for _pass in range(4):
      PG.say(['Following calls from the start-up code and the interrupt handlers…', f'Found {len(seen):,} functions. Looking through every ROM bank for code that nothing obvious calls…',
              f'Found {len(seen):,}. Following ROM bank numbers kept in variables…', f'Found {len(seen):,}. Looking for script handlers (code run by the game\'s own script data)…'][_pass])
      if _pass == 1:
        todo = scan_for_more(); guessed.update(todo)
      if _pass == 2:
        todo = from_bank_variables()
      if _pass == 3:
        todo = find_script_handlers()
      while todo:
          s = todo.pop()
          if s in seen or img.off(s) is None: continue
          seen.add(s)
          bank = s >> 16; lines = {}; refs = []; callees = set()
          def code_target(x, cur):
              if x < 0x4000: return x
              if x < 0x8000:
                  b = bank if bank else cur
                  return (b << 16) | x if isinstance(b, int) and b else None
              return None
          def call_to(enc, at):
              callees.add(enc); calls.setdefault(enc, []).append(at)
              if enc not in seen: todo.append(enc)
          work = [(s, {}, bank if bank else None)]   # (address, known register values, ROM bank switched in)
          while work and len(lines) < 1500:
              pc, rv, cur = work.pop(); rv = dict(rv)
              while pc not in lines:
                  o = img.off(pc)
                  if o is None or D[o] == 0xFF: break          # 0xFF filler: not code
                  d = sm83.decode(D, o, pc & 0xFFFF)
                  if not d: break
                  op, t = d['op'], d['t']; line = {'a': pc, 't': t}; lines[pc] = line
                  nxt = pc + d['size']; stop = False
                  if (nxt & 0xFFFF) in (0x4000, 0x8000): stop = True
                  if 'target' in d:
                      enc = code_target(d['target'], cur)
                      if op in ('call', 'rst'):
                          if enc is None and d['target'] >= 0x8000: line['ramcall'] = d['target']
                          elif enc is None:
                              line['note'] = 'bank unknown'
                              if isinstance(cur, tuple): varcalls.append((cur[1], d['target'], pc)); line['bankvar'] = cur[1]
                          else:
                              line['call'] = enc; call_to(enc, pc)
                              aval = rv.get('a')
                              if enc < 0x4000 and farcall_reg(enc):
                                  fb, fa = rv.get(farcall_reg(enc)), rv.get('hl')
                                  if isinstance(fb, int) and fb and isinstance(fa, int) and 0x4000 <= fa < 0x8000:
                                      far = (fb << 16) | fa; line['far'] = far; call_to(far, pc)
                                  elif isinstance(fb, tuple) and isinstance(fa, int) and 0x4000 <= fa < 0x8000:
                                      varcalls.append((fb[1], fa, pc)); line['bankvar'] = fb[1]
                                  rv = {}
                              elif enc in switchers or is_switcher(enc):
                                  switchers.add(enc)
                                  if isinstance(aval, int): cur = aval; line['bank'] = aval
                                  elif isinstance(aval, tuple): cur = ('var', aval[1]); line['bankvar'] = aval[1]
                              else: rv = {}
                      elif op == 'jp' and ',' not in t:
                          # a jump at the very start, or out of this area, is a tail call to another function
                          if enc is not None and (len(lines) <= 2 or not (s <= enc < s + 0x400) or enc in funcs or enc in starts):
                              line['call'] = enc; line['tail'] = True; call_to(enc, pc); stop = True
                          elif enc is not None: work.append((enc, rv, cur)); stop = True
                          elif d['target'] >= 0x8000:
                              line['ramcall'] = d['target']; line['tail'] = True; stop = True
                              if d['target'] in tramps: line['next'] = True
                          else: line['note'] = 'bank unknown'; stop = True
                      else:   # jr / jr cc / jp cc: follow both ways
                          if enc is not None and (enc >> 16) == bank: work.append((enc, rv, cur))
                          elif d['target'] in tramps: line['ramcall'] = d['target']; line['next'] = True
                          if op == 'jr' and ',' not in t: stop = True
                  if t == 'jp hl' and isinstance(rv.get('table'), int):
                      # jump table: ld hl,TABLE / add hl,index / ld a,(hl+) / ld h,(hl) / ld l,a / jp hl
                      tb = rv['table']; n = 0; tgts = []
                      while n < 64:
                          te = code_target(tb + 2 * n, cur); to = img.off(te) if te is not None else None
                          if to is None or to + 1 >= len(D): break
                          w = D[to] | D[to + 1] << 8; enc = code_target(w, cur)
                          if enc is None or (w < 0x150 and w not in (0, 8, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38)) or tb <= w < tb + 2 * n + 2: break
                          oo = img.off(enc)
                          if oo is None or D[oo] in (0xFF,): break
                          tgts.append(enc); n += 1
                      if len(tgts) >= 2:
                          line['table'] = tb; line['targets'] = tgts
                          for e in tgts: call_to(e, pc)
                  if t in ('ret', 'reti', 'jp hl') or (op == 'rst' and d.get('target') == 0x38 and D[o] == 0xFF): stop = True
                  track(rv, d)
                  m = d.get('mem')
                  if m is not None:
                      if MBC_LO <= m <= MBC_HI and t.endswith(',a'):
                          line['mbc'] = True
                          if isinstance(rv.get('a'), int): cur = rv['a']; line['bank'] = rv['a']
                          elif isinstance(rv.get('a'), tuple): cur = ('var', rv['a'][1]); line['bankvar'] = rv['a'][1]
                      elif m >= 0x8000:
                          if t.startswith(('ld (', 'ldh (')) and isinstance(rv.get('a'), int): consts.setdefault(m, set()).add(rv['a'])
                          r = ra(m); line['lit'] = m
                          if r is not None: refs.append({'ra': r, 'at': pc, 'rw': 'W' if t.startswith(('ld (', 'ldh (')) else 'R'})
                  if op == 'ld' and d.get('imm') is not None and t[3:5] in ('hl', 'de', 'bc') and t[5:6] == ',':
                      v = d['imm']
                      if v >= 0x8000:
                          line['lit'] = v; r = ra(v)
                          if r is not None: refs.append({'ra': r, 'at': pc, 'rw': 'ptr', 'reg': t[3:5]})
                      else:
                          ct = code_target(v, cur)
                          if ct is not None: line['lit'] = ct
                          elif 0x4000 <= v < 0x8000: line['lit_unres'] = v
                  if stop: break
                  pc = nxt
          ins = [lines[a] for a in sorted(lines)]
          idx = {l['a']: i for i, l in enumerate(ins)}
          for rf in refs:
              if rf['rw'] != 'ptr': continue
              reg = rf.pop('reg'); rw = set()
              for l in ins[idx[rf['at']] + 1: idx[rf['at']] + 6]:
                  tt = l['t']
                  if f'({reg}' in tt:
                      rw.add('W' if tt.startswith(f'ld ({reg}') or tt.startswith(('inc (', 'dec (', 'set', 'res')) else 'R')
                  elif tt.startswith(f'ld {reg},') or tt.startswith(f'pop {reg}'): break
              rf['rw'] = ''.join(sorted(rw)) or 'ptr'
          for rf in refs: rf.pop('reg', None)
          funcs[s] = {'start': s, 'n': len(ins), 'ins': ins, 'refs': refs, 'callees': sorted(callees)}
    # Data pointers into 0x4000-0x7FFF from bank-0 code: the bank is usually one held in a variable
    # (the text bank, the graphics bank...). If exactly one of the banks the game stores there has a message
    # at that address, link it.
    data_banks = set()
    for f in funcs.values():
        for l in f['ins']:
            if l.get('bankvar') is not None: data_banks |= {b for b in consts.get(l['bankvar'], ()) if 1 <= b < img.banks}
    for f in funcs.values():
        for l in f['ins']:
            v = l.pop('lit_unres', None)
            if v is None: continue
            hits = [b for b in sorted(data_banks) if text_at(img, (b << 16) | v)]
            if len(hits) == 1: l['lit'] = (hits[0] << 16) | v; l['databank'] = hits[0]
    for k, f in funcs.items():
        f['callers'] = sorted(set(calls.get(k, []))); f['ptrrefs'] = []
        if k in switchers: f['auto'] = ('SwitchBank', 'Switches the ROM bank to the number in A (found automatically).')
        elif k in farcalls and farcalls[k]: f['auto'] = ('FarCall', f'Calls the function at HL in the ROM bank held in {farcalls[k]} (found automatically).')
        if k in guessed and not f['callers']: f['guess'] = True
        if k in maybe: f['maybe'] = sorted(maybe[k])
        if k in script_refs:
            f['ptrrefs'] = script_refs[k][:20]
            f['auto'] = f.get('auto') or (None, f'Script command: the game lists this routine\'s address in its script data ({len(script_refs[k])} place{"s" if len(script_refs[k]) > 1 else ""}), and it ends by jumping to the next command.')
    return funcs

# ---- text: messages end in 0xFF; 0xF8-0xFE are control codes with arguments ----
CTRL_ARGS = {0xF8: 1, 0xF9: 0, 0xFA: 1, 0xFB: 1, 0xFC: 1, 0xFD: 2, 0xFE: 1}
def text_at(img, enc):
    o = img.off(enc)
    if o is None: return None
    D = img.data; out = []; i = o; letters = 0
    if o and 0x20 <= D[o - 1] < 0x7F and D[o] not in CTRL_ARGS: return None   # starts mid-sentence: not a message start
    while i < len(D) and i - o < 240:
        c = D[i]
        if c == 0xFF: break
        if c in CTRL_ARGS:
            i += 1 + CTRL_ARGS[c]
            if out and out[-1] != ' ': out.append(' ')
            continue
        if 0x20 <= c < 0x7F:
            out.append(chr(c)); letters += c > 0x40
        elif c >= 0x80: out.append('·')
        else: return None
        i += 1
    else:
        return None
    s = ''.join(out).strip()
    if letters < 3 or len(s) < 3: return None
    if s.count('·') > len(s) * 0.1 or letters < len(s.replace(' ', '')) * 0.5: return None
    if letters < 4 or sum(ch.isalnum() or ch in " .,!?'%*-:/&()" for ch in s) < len(s) * 0.9: return None
    if max(s.count(ch) for ch in set(s.replace(' ', ''))) > max(6, len(s) * 0.3): return None
    return s

def find_text(img):
    TEXT = {}; TABLES = []
    D = img.data
    for b in range(img.banks):
        lo = b * 0x4000; hi = min(lo + 0x4000, len(D)) - 1; o = lo
        while o < hi:
            n = 0; ents = []
            while o + 2 * n + 1 <= hi:
                w = D[o + 2 * n] | D[o + 2 * n + 1] << 8
                here = (o - lo + (0x4000 if b else 0))
                # text tables point at messages stored nearby in the same bank
                enc = ((b << 16) | w) if (abs(w - here) < 0x1000 and ((b and 0x4000 <= w < 0x8000) or (not b and w < 0x4000))) else None
                s = text_at(img, enc) if enc is not None and w >= 0x0150 else None
                if s is None: break
                ents.append((enc, s)); n += 1
            if n >= 3 and len({e for e, _ in ents}) >= 2:
                for e, s_ in ents: TEXT[e] = s_
                ents = [e for e, _ in ents]
                a = (b << 16) | (o - lo + (0x4000 if b else 0))
                TABLES.append({'a': a, 'n': n, 'e': ents, 'step': 2}); o += 2 * n
            else:
                o += 1
    for t in TABLES:
        t['name'] = f'text list "{TEXT[t["e"][0]][:28]}…" ({t["n"]} entries)'
    return TEXT, TABLES

def translate(ins, lab, fname, pool, tlook=lambda v: None, enums=None):
    return gb_plain.translate(ins, lab, fname, tlook, enums or {})

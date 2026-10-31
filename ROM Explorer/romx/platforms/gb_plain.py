"""SM83 (Game Boy) instructions to plain English, following what A, the pairs HL/DE/BC and the flags hold."""
import re

PAIRS = ('hl', 'de', 'bc')
REG8 = ('a', 'b', 'c', 'd', 'e', 'h', 'l')
PAIR_OF = {'h': 'hl', 'l': 'hl', 'd': 'de', 'e': 'de', 'b': 'bc', 'c': 'bc'}

def translate(ins, lab, fname, tlook, enums):
    addrs = {l['a'] for l in ins}
    tgts = set()
    for l in ins:
        m = re.match(r'(jr|jp) (?:(nz|z|nc|c),)?0x([0-9a-f]{4})$', l['t'])
        if m and not l.get('tail'):
            enc = (l['a'] & 0xFFFF0000) | int(m.group(3), 16) if int(m.group(3), 16) >= 0x4000 else int(m.group(3), 16)
            if enc in addrs: tgts.add(enc)
    L = {t: f'L{i + 1}' for i, t in enumerate(sorted(tgts))}
    R = {}; flag = None; out = {}; fresh = set()

    def mk(e, r): return ('val', e) if len(e) <= 34 else ('val', f'{r} (calculated)')
    def desc(r):
        v = R.get(r)
        if not v: return r
        if v[0] == 'const': return str(v[1]) if v[1] < 10 else hex(v[1])
        return v[1] if len(str(v[1])) <= 34 else r
    def enum(name, n):
        e = enums.get(str(name).split(' ')[0].split('+')[0], {})
        return f'{n} ({e[n]})' if n in e else str(n)
    def mem(a):
        r = a - 0x2000 if 0xE000 <= a < 0xFE00 else a
        return lab(r) or f'RAM 0x{r:04X}'
    def at_pair(p):
        v = R.get(p)
        if v and v[0] == 'addr': return v[1], v[2]
        return None, None
    def setpair(p, v):
        R[p] = v
        for r8, pp in PAIR_OF.items():
            if pp == p: R.pop(r8, None)
    def set8(r, v):
        R[r] = v
        if r in PAIR_OF: R.pop(PAIR_OF[r], None)
    def cond(cc):
        if flag is None: return f'the last result is {"zero" if cc == "z" else "not zero" if cc == "nz" else "carry" if cc == "c" else "no carry"}'
        kind = flag[0]
        if kind == 'cp':
            x, n = flag[1], flag[2]
            nn = enum(x, n) if isinstance(n, int) else n
            return {'z': f'{x} is {nn}', 'nz': f'{x} is not {nn}', 'c': f'{x} is less than {nn}', 'nc': f'{x} is at least {nn}'}[cc]
        if kind == 'zero':
            return {'z': f'{flag[1]} is 0', 'nz': f'{flag[1]} is not 0', 'c': 'carry is set', 'nc': 'carry is clear'}[cc]
        if kind == 'bit':
            return {'z': f'bit {flag[1]} of {flag[2]} is off', 'nz': f'bit {flag[1]} of {flag[2]} is on', 'c': 'carry is set', 'nc': 'carry is clear'}[cc]
        if kind == 'and':
            return {'z': f'{flag[1]} has none of the bits {flag[2]}', 'nz': f'{flag[1]} has any of the bits {flag[2]}', 'c': 'carry is set', 'nc': 'carry is clear'}[cc]
        return 'the last result ' + cc

    for l in ins:
        a, t = l['a'], l['t']
        if a in L:
            R = {}; flag = None; fresh = set()
        op, _, rest = t.partition(' ')
        ops = rest.split(',') if rest else []
        k, s = 'misc', None
        try:
            if l.get('mbc'):
                b = l.get('bank'); k, s = 'write', f'Switch to ROM bank {b}' if b is not None else 'Switch ROM bank (to the number in a)'
            elif op == 'nop': k, s = 'quiet', None
            elif op == 'ld' and len(ops) == 2:
                d, x = ops
                if d in PAIRS and x.startswith('0x'):
                    v = int(x, 16); tx = tlook(l['lit']) if 'lit' in l else None
                    if tx: setpair(d, ('val', tx[1])); k, s = 'text', f'Use {tx[1]}'
                    elif v >= 0x8000: name = mem(v); setpair(d, ('addr', name, v)); k, s = 'addr', f'{d} = address of {name}'
                    else: setpair(d, ('const', v)); k, s = 'quiet', f'{d} = {hex(v)}'
                    if d == 'hl' or d == 'de' or d == 'bc': fresh.add(d)
                elif x.startswith('(0x') and d == 'a':
                    name = mem(int(x[1:-1], 16)); set8('a', ('val', name)); k, s = 'read', f'Read {name}'; fresh.add('a')
                elif d.startswith('(0x') and x == 'a':
                    name = mem(int(d[1:-1], 16)); v = R.get('a')
                    val = enum(name, v[1]) if v and v[0] == 'const' else desc('a'); k, s = 'write', f'Set {name} = {val}'
                elif x in ('(hl)', '(hl+)', '(hl-)', '(de)', '(bc)'):
                    p = x[1:3]; name, base = at_pair(p)
                    if name: set8(d, ('val', name)); k, s = 'read', f'Read {name}'
                    else: set8(d, mk(f'value at {desc(p)}', d)); k, s = 'quiet', f'{d} = value at {desc(p)}'
                    if x.endswith('+)') or x.endswith('-)'):
                        if base is not None: nb = base + (1 if '+' in x else -1); R['hl'] = ('addr', mem(nb), nb)
                        else: R.pop('hl', None)
                    if d == 'a': fresh.add('a')
                elif d in ('(hl)', '(hl+)', '(hl-)', '(de)', '(bc)'):
                    p = d[1:3]; name, base = at_pair(p)
                    v = R.get(x) if x in REG8 else ('const', int(x, 16)) if x.startswith('0x') else None
                    val = (enum(name, v[1]) if name else str(v[1])) if v and v[0] == 'const' else (desc(x) if x in REG8 else x)
                    if name: k, s = 'write', f'Set {name} = {val}'
                    else: k, s = 'quiet', f'Store {val} at {desc(p)}'
                    if d.endswith('+)') or d.endswith('-)'):
                        if base is not None: nb = base + (1 if '+' in d else -1); R['hl'] = ('addr', mem(nb), nb)
                        else: R.pop('hl', None)
                elif d in REG8 and x.startswith('0x'):
                    set8(d, ('const', int(x, 16))); k, s = 'quiet', f'{d} = {int(x, 16)}'; fresh.add(d)
                elif d in REG8 and x in REG8:
                    set8(d, R.get(x)); k, s = 'quiet', f'{d} = {desc(x)}'; fresh.add(d)
                elif d == 'a' and x == '(c)': set8('a', ('val', 'I/O register')); k, s = 'read', 'Read the I/O register picked by c'
                elif d == '(c)': k, s = 'write', f'Write {desc("a")} to the I/O register picked by c'
                else: k, s = 'quiet', None
            elif op == 'ldh':
                d, x = ops
                if d == 'a':
                    name = mem(int(x[1:-1], 16)); set8('a', ('val', name)); k, s = 'read', f'Read {name}'; fresh.add('a')
                else:
                    name = mem(int(d[1:-1], 16)); v = R.get('a')
                    val = enum(name, v[1]) if v and v[0] == 'const' else desc('a'); k, s = 'write', f'Set {name} = {val}'
            elif t == 'xor a':
                set8('a', ('const', 0)); flag = ('zero', '0'); k, s = 'quiet', 'a = 0'; fresh.add('a')
            elif t in ('or a', 'and a'):
                flag = ('zero', desc('a')); k, s = 'quiet', f'Test whether {desc("a")} is 0'
            elif op == 'cp':
                x = ops[0]; n = int(x, 16) if x.startswith('0x') else desc(x[1:-1] if x.startswith('(') else x)
                if x == '(hl)': nm, _ = at_pair('hl'); n = nm or 'value at hl'
                flag = ('cp', desc('a'), n); k, s = 'quiet', f'Compare {desc("a")} with {n}'
            elif op == 'bit':
                b, r = ops; tgt = (at_pair('hl')[0] or 'value at hl') if r == '(hl)' else desc(r)
                flag = ('bit', int(b), tgt)
                k, s = ('read' if r == '(hl)' and at_pair('hl')[0] else 'quiet'), f'Check bit {b} of {tgt}'
            elif op in ('set', 'res'):
                b, r = ops
                if r == '(hl)':
                    nm, _ = at_pair('hl')
                    k, s = ('write' if nm else 'quiet'), f'{"Turn on" if op == "set" else "Turn off"} bit {b} of {nm or "the value at hl"}'
                else: R.pop(r, None); k, s = 'quiet', f'{"Turn on" if op == "set" else "Turn off"} bit {b} of {r}'
            elif op == 'and' and ops[0].startswith('0x'):
                set8('a', mk(f'{desc("a")} & {ops[0]}', 'a')); flag = ('and', R['a'][1].rsplit(' &', 1)[0], ops[0]); k, s = 'quiet', f'a = {R["a"][1]}'
            elif op in ('inc', 'dec'):
                r = ops[0]; word = 'Add 1 to' if op == 'inc' else 'Take 1 from'
                if r == '(hl)':
                    nm, _ = at_pair('hl'); flag = ('zero', nm or 'value at hl'); k, s = ('write' if nm else 'quiet'), f'{word} {nm or "the value at hl"}'
                elif r in PAIRS:
                    v = R.get(r)
                    if v and v[0] == 'addr': nb = v[2] + (1 if op == 'inc' else -1); R[r] = ('addr', mem(nb), nb)
                    else: R[r] = mk(f'{desc(r)} {"+" if op == "inc" else "-"} 1', r)
                    k, s = 'quiet', f'{r} {"+= 1" if op == "inc" else "-= 1"}'
                else:
                    set8(r, mk(f'{desc(r)} {"+" if op == "inc" else "-"} 1', r)); flag = ('zero', R[r][1]); k, s = 'quiet', f'{r} {"+= 1" if op == "inc" else "-= 1"}'
            elif l.get('next') and l.get('tail'):
                k, s = 'flow', 'Go on to the next script command'
            elif l.get('next'):
                cc = rest.split(',')[0]; k, s = 'branch', f'If {cond(cc)}, go on to the next script command'
            elif op in ('jr', 'jp') and not l.get('tail') and t != 'jp hl':
                m = re.match(r'(?:(nz|z|nc|c),)?0x([0-9a-f]{4})$', rest); cc, tv = m.group(1), int(m.group(2), 16)
                enc = (a & 0xFFFF0000) | tv if tv >= 0x4000 else tv
                dest = L.get(enc, f'0x{tv:04X}')
                k, s = 'branch', (f'If {cond(cc)}, go to {dest}' if cc else f'Go to {dest}')
            elif t == 'jp hl': k, s = 'branch', f'Jump to the address in hl ({desc("hl")}), a jump table'
            elif op in ('call', 'rst') or (op == 'jp' and l.get('tail')):
                m = re.match(r'(?:(nz|z|nc|c),)?', rest); cc = m.group(1) if m else None
                if 'far' in l:
                    k, s = 'call', f'Call {fname(l["far"])} in ROM bank {l["far"] >> 16} (through {fname(l["call"])})'
                elif 'ramcall' in l:
                    k, s = 'call', f'Call the code copied into RAM at 0x{l["ramcall"]:04X}' + (' (usually the sprite DMA routine)' if l['ramcall'] >= 0xFF80 else '')
                elif 'call' in l:
                    nm = fname(l['call'])
                    args = ', '.join(f'{r}={desc(r)}' for r in ('a', 'hl', 'de', 'bc') if r in fresh and R.get(r))
                    pre = f'If {cond(cc)}, ' if cc else ''
                    verb = 'jump to' if op == 'jp' else 'call'
                    s = f'{pre}{verb if pre else verb.capitalize()} {nm}({args})'
                    if l.get('bank') is not None: s += f' (switches to ROM bank {l["bank"]})'
                    k = 'call'
                else:
                    k, s = 'call', f'Call 0x{rest.split(",")[-1][2:]} in a ROM bank this tool could not work out'
                for r in REG8 + PAIRS: R.pop(r, None)
                R['a'] = ('val', f'result of {fname(l["call"])}' if 'call' in l else 'result'); fresh = set(); flag = None
            elif op == 'ret' or op == 'reti':
                cc = ops[0] if ops else None
                if op == 'reti': k, s = 'flow', 'Return from the interrupt'
                elif cc: k, s = 'branch', f'If {cond(cc)}, return'
                else: k, s = 'flow', 'Return'
            elif op == 'push': k, s = 'quiet', f'Save {ops[0]}'
            elif op == 'pop': R.pop(ops[0], None); k, s = 'quiet', f'Restore {ops[0]}'
            elif op == 'di': k, s = 'flow', 'Turn interrupts off'
            elif op == 'ei': k, s = 'flow', 'Turn interrupts on'
            elif op == 'halt': k, s = 'flow', 'Wait for the next interrupt'
            elif op in ('add', 'adc', 'sub', 'sbc', 'or', 'xor', 'and'):
                if op in ('add', 'adc', 'sbc') and ops[0] == 'a': src = ops[1]
                elif op == 'add' and ops[0] == 'hl': R['hl'] = mk(f'{desc("hl")} + {desc(ops[1])}', 'hl'); k, s = 'quiet', f'hl = {R["hl"][1]}'; src = None
                else: src = ops[0]
                if src is not None:
                    sym = {'add': '+', 'adc': '+', 'sub': '-', 'sbc': '-', 'or': '|', 'xor': '^', 'and': '&'}[op]
                    sv = src if src.startswith('0x') else (at_pair('hl')[0] or 'value at hl') if src == '(hl)' else desc(src)
                    set8('a', mk(f'{desc("a")} {sym} {sv}', 'a')); flag = ('zero', R['a'][1]); k, s = 'quiet', f'a = {R["a"][1]}'
            elif op in ('swap', 'sla', 'sra', 'srl', 'rl', 'rr', 'rlc', 'rrc', 'rla', 'rra', 'rlca', 'rrca', 'cpl'):
                r = ops[0] if ops else 'a'
                if r in REG8: set8(r, mk(f'{op}({desc(r)})', r))
                k, s = 'quiet', f'{r} = {op}({r})'
        except (ValueError, IndexError, AttributeError, KeyError, TypeError):
            k, s = 'misc', None
        out[a] = (k, s)
    return out, L

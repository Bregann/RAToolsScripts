"""PowerPC (GameCube / Wii) instructions to plain English. Tracks what registers hold and which value each
condition-register field (cr0-cr7) was last compared against."""
import re

SIZES = {'lwz': '32-bit', 'lhz': '16-bit', 'lha': '16-bit', 'lbz': '8-bit', 'lfs': 'float', 'lfd': 'double',
         'stw': '32-bit', 'sth': '16-bit', 'stb': '8-bit', 'stfs': 'float', 'stfd': 'double'}
ARGS = tuple(f'r{i}' for i in range(3, 11))
VOLATILE = ('r0',) + tuple(f'r{i}' for i in range(3, 13))
COND = {'eq': ('is', 'is not'), 'ne': ('is not', 'is'), 'lt': ('is less than', 'is at least'), 'ge': ('is at least', 'is less than'),
        'gt': ('is more than', 'is at most'), 'le': ('is at most', 'is more than')}

def translate(ins, lab, fname, tlook, enums, ra):
    addrs = {l['a'] for l in ins}
    tg = set()
    for l in ins:
        m = re.match(r'b(eq|ne|lt|gt|le|ge|dnz|dz|)(\+|-)?\s+(?:cr\d, )?(0x[0-9a-f]+)$', l['t'])
        if m and not l.get('tail') and int(m.group(3), 16) in addrs: tg.add(int(m.group(3), 16))
    L = {t: f'L{i + 1}' for i, t in enumerate(sorted(tg))}
    R = {f'r{i}': ('val', f'arg{i - 2}') for i in range(3, 11)}
    CR = {}; out = {}; fresh = set()

    def mk(e, r): return ('val', e) if len(e) <= 34 else ('val', f'{r} (calculated)')
    def desc(r):
        v = R.get(r)
        if not v: return r
        if v[0] == 'const':
            n = v[1] - 0x100000000 if v[1] & 0x80000000 and v[1] > 0xFFFF0000 else v[1]
            return str(n) if -10 < n < 10 else hex(n)
        return v[1] if len(str(v[1])) <= 34 else r
    def enum(name, n):
        e = enums.get(str(name).split(' ')[0].split('+')[0], {})
        return f'{n} ({e[n]})' if n in e else str(n)
    def name_of(v):
        tx = tlook(v)
        if tx: return 'text', tx[1]
        r = ra(v)
        if r is not None: return 'addr', lab(r) or f'RAM 0x{r:08X}'
        return None, None
    def memname(l, base, off):
        if 'mem' in l:
            r = ra(l['mem'])
            if r is not None: return lab(r) or f'RAM 0x{r:08X}'
        b = R.get(base)
        if b and b[0] == 'addr' and len(b) > 3: return f'{b[1]}' + (f' field +0x{off:X}' if off else '')
        if b and b[0] == 'addr' and len(b) > 2: return lab(b[2] + off) or (b[1] if not off else f'{b[1]}+0x{off:X}')
        return None

    for l in ins:
        a, t = l['a'], l['t']
        if a in L:
            for r in VOLATILE: R.pop(r, None)
            CR.clear(); fresh = set()
        op, _, rest = t.partition(' ')
        ops = [o.strip() for o in rest.split(',')] if rest else []
        k, s = 'misc', None
        try:
            d = ops[0] if ops else None
            base_op = op.rstrip('.')
            if op == 'nop': k, s = 'quiet', None
            elif op == 'stwu' and ops[1].endswith('(r1)') and d == 'r1':
                k, s = 'flow', 'Start of function (make room on the stack)'
            elif op in ('mflr', 'mtlr'): k, s = 'quiet', 'Save the return address' if op == 'mflr' else 'Restore the return address'
            elif op == 'li':
                R[d] = ('const', int(ops[1], 0) & 0xFFFFFFFF); k, s = 'quiet', f'{d} = {int(ops[1], 0)}'; fresh.add(d)
            elif op == 'lis':
                R[d] = ('const', (int(ops[1], 0) & 0xFFFF) << 16); k, s = 'quiet', f'{d} = upper half {hex(int(ops[1], 0) & 0xFFFF)}'
            elif op in ('addi', 'ori', 'addic') and len(ops) == 3:
                src = ops[1]; imm = int(ops[2], 0)
                if 'lit' in l:
                    kind, nm = name_of(l['lit'])
                    if kind == 'text': R[d] = ('val', nm); k, s = 'text', f'Use {nm}'
                    elif kind == 'addr': R[d] = ('addr', nm, ra(l['lit'])); k, s = 'addr', f'{d} = address of {nm}'
                    else: R[d] = ('const', l['lit']); k, s = 'quiet', f'{d} = {hex(l["lit"])}'
                elif src == 'r1': R[d] = ('val', 'a local'); k, s = ('quiet', f'{d} = address of a local') if d != 'r1' else ('quiet', 'Free the stack space')
                elif (R.get(src) or ('',))[0] == 'const':
                    v = (R[src][1] | (imm & 0xFFFF)) if op == 'ori' else (R[src][1] + imm) & 0xFFFFFFFF
                    R[d] = ('const', v); k, s = 'quiet', f'{d} = {hex(v)}'
                elif (R.get(src) or ('',))[0] == 'addr' and op == 'addi':
                    r2 = R[src][2] + imm; R[d] = ('addr', lab(r2) or f'{R[src][1]}+0x{imm:X}', r2); k, s = 'addr', f'{d} = address of {R[d][1]}'
                else:
                    R[d] = mk(f'{desc(src)} {"|" if op == "ori" else "+"} {imm}', d); k, s = 'quiet', f'{d} = {R[d][1]}'
                if d in ARGS: fresh.add(d)
            elif op == 'mr':
                R[d] = R.get(ops[1]) or ('val', ops[1]); k, s = 'quiet', f'{d} = {desc(ops[1])}'
                if d in ARGS: fresh.add(d)
            elif re.match(r'^(lwz|lhz|lha|lbz|lfs|lfd)u?$', op) and len(ops) == 2:
                m = re.fullmatch(r'(-?0x[0-9a-f]+|-?\d+)?\((r\d+)\)', ops[1]); off = int(m.group(1), 0) if m.group(1) else 0; base = m.group(2)
                nm = memname(l, base, off); sz = SIZES[op.rstrip('u')]
                if base == 'r1': R[d] = ('val', 'a saved value'); k, s = 'quiet', f'{d} = local variable'
                elif nm: R[d] = ('val', nm); k, s = 'read', f'Read {nm} ({sz})'
                else: R[d] = mk(f'value at {desc(base)}' + (f'+{off}' if off else ''), d); k, s = 'quiet', f'{d} = {R[d][1]}'
                if d in ARGS: fresh.add(d)
            elif re.match(r'^(stw|sth|stb|stfs|stfd)u?$', op) and len(ops) == 2:
                m = re.fullmatch(r'(-?0x[0-9a-f]+|-?\d+)?\((r\d+)\)', ops[1]); off = int(m.group(1), 0) if m.group(1) else 0; base = m.group(2)
                nm = memname(l, base, off); v = R.get(d)
                val = enum(nm, v[1]) if v and v[0] == 'const' and nm else desc(d)
                if base == 'r1': k, s = 'quiet', f'Save {desc(d)} on the stack'
                elif nm: k, s = 'write', f'Set {nm} = {val}'
                else: k, s = 'quiet', f'Store {val} at {desc(base)}' + (f'+{off}' if off else '')
            elif op in ('cmpwi', 'cmplwi', 'cmpw', 'cmplw'):
                cr = 'cr0'
                if ops[0].startswith('cr'): cr, ops = ops[0], ops[1:]
                x = desc(ops[0])
                y = int(ops[1], 0) if op.endswith('i') else desc(ops[1])
                CR[cr] = (x, y); k, s = 'quiet', f'Compare {x} with {y}'
            elif re.fullmatch(r'b(eq|ne|lt|gt|le|ge)(lr)?[+-]?', op):
                cc = re.match(r'b(eq|ne|lt|gt|le|ge)', op).group(1)
                cr = ops[0] if ops and ops[0].startswith('cr') else 'cr0'
                c = CR.get(cr)
                if c:
                    x, y = c; yy = enum(x, y) if isinstance(y, int) else y
                    cond = f'{x} {COND[cc][0]} {yy}'
                else: cond = f'the last result is {cc}'
                if op.startswith(f'b{cc}lr'): k, s = 'branch', f'If {cond}, return'
                else:
                    tgt = int(ops[-1], 16); k, s = 'branch', f'If {cond}, go to {L.get(tgt, hex(tgt))}'
            elif op in ('bdnz', 'bdz'):
                tgt = int(ops[-1], 16); k, s = 'branch', f'Count down and loop back to {L.get(tgt, hex(tgt))}' if op == 'bdnz' else f'If the counter hits 0, go to {L.get(tgt, hex(tgt))}'
            elif op in ('b', 'ba'):
                tgt = int(ops[-1], 16)
                if l.get('tail'): k, s = 'call', f'Jump to {fname(tgt)} (it returns for this function)'
                else: k, s = 'branch', f'Go to {L.get(tgt, hex(tgt))}'
            elif op in ('bl', 'bla'):
                tgt = int(ops[-1], 16)
                args = ', '.join(desc(r) for r in ARGS if r in fresh and R.get(r))
                k, s = 'call', f'Call {fname(tgt)}({args})'
                for r in VOLATILE: R.pop(r, None)
                R['r3'] = ('val', f'result of {fname(tgt)}'); fresh = set(); CR.clear()
            elif op == 'bctrl':
                k, s = 'call', f'Call the function whose address is in ctr ({desc("ctr")})'
                for r in VOLATILE: R.pop(r, None)
                R['r3'] = ('val', 'result'); fresh = set(); CR.clear()
            elif op == 'bctr': k, s = 'branch', f'Jump to the address in ctr ({desc("ctr")}), a jump table'
            elif op == 'mtctr': R['ctr'] = R.get(d); k, s = 'quiet', f'ctr = {desc(d)}'
            elif op == 'blr': k, s = 'flow', 'Return' + (f' {desc("r3")}' if R.get('r3') and not str(R['r3'][1]).startswith('arg') else '')
            elif base_op in ('rlwinm', 'clrlwi', 'slwi', 'srwi', 'extrwi', 'rotlwi', 'clrrwi'):
                R[d] = mk(f'{op.rstrip(".")}({desc(ops[1])}, {", ".join(ops[2:])})', d); k, s = 'quiet', f'{d} = {R[d][1]}'
                if op.endswith('.'): CR['cr0'] = (R[d][1], 0)
            elif base_op in ('andi', 'andis', 'and', 'or', 'xor', 'add', 'subf', 'mullw', 'divw', 'divwu', 'slw', 'srw', 'sraw', 'srawi', 'addis', 'oris', 'xori', 'mulli', 'subfic', 'nor'):
                sym = {'andi': '&', 'andis': '& high', 'and': '&', 'or': '|', 'xor': '^', 'add': '+', 'subf': 'subtracted from', 'mullw': '*',
                       'divw': '/', 'divwu': '/', 'slw': '<<', 'srw': '>>', 'sraw': '>>', 'srawi': '>>', 'addis': '+ high', 'oris': '| high',
                       'xori': '^', 'mulli': '*', 'subfic': 'from', 'nor': 'nor'}[base_op]
                y = ops[2] if len(ops) > 2 else ''
                yv = y if not re.fullmatch(r'r\d+', y) else desc(y)
                x1, x2 = R.get(ops[1]), (R.get(y) if re.fullmatch(r'r\d+', y) else None)
                if base_op == 'add' and (bool(x1 and x1[0] == 'addr') != bool(x2 and x2[0] == 'addr')):
                    bse, other = (x1, yv) if x1 and x1[0] == 'addr' else (x2, desc(ops[1]))
                    tname = bse[1].split(' entry')[0]
                    R[d] = ('addr', f'{tname} entry', bse[2], 'indexed'); k, s = 'addr', f'{d} = address of an entry in {tname} (picked by {other})'
                else:
                    R[d] = mk(f'{desc(ops[1])} {sym} {yv}', d); k, s = 'quiet', f'{d} = {R[d][1]}'
                if op.endswith('.'): CR['cr0'] = (R[d][1], 0)
            elif base_op in ('neg', 'extsb', 'extsh', 'cntlzw'):
                R[d] = mk(f'{base_op}({desc(ops[1])})', d); k, s = 'quiet', f'{d} = {R[d][1]}'
                if op.endswith('.'): CR['cr0'] = (R[d][1], 0)
        except (ValueError, IndexError, AttributeError, KeyError, TypeError):
            k, s = 'misc', None
        out[a] = (k, s)
    return out, L

"""MIPS (PS1) instructions to plain English. Tracks what each register holds, and handles delay slots:
the instruction after a branch or call runs before it, so it's explained first."""
import re

SIZES = {'lw': '32-bit', 'lh': '16-bit', 'lhu': '16-bit', 'lb': '8-bit', 'lbu': '8-bit', 'sw': '32-bit', 'sh': '16-bit', 'sb': '8-bit',
         'ld': '64-bit', 'sd': '64-bit', 'lq': '128-bit', 'sq': '128-bit', 'lwu': '32-bit', 'lwc1': 'float', 'swc1': 'float'}
ARGREGS = ('a0', 'a1', 'a2', 'a3')
SCRATCH = ('v0', 'v1', 'a0', 'a1', 'a2', 'a3', 't0', 't1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9', 'at')

def reg(x): return x.strip().lstrip('$')
def sext(v): return v - 0x10000 if v & 0x8000 else v

def translate(ins, lab, fname, tlook, enums, ra):
    first, last = ins[0]['a'], ins[-1]['a']
    tgts = sorted({int(l['t'].split(',')[-1].split()[-1], 16) for l in ins
                   if re.match(r'(b|j)\w*\s', l['t']) and not l['t'].startswith(('jal', 'jr', 'bal', 'break'))
                   and re.search(r'0x[0-9a-f]+$', l['t'])} & set(l['a'] for l in ins))
    L = {t: f'L{i + 1}' for i, t in enumerate(tgts)}
    R = {'a0': ('val', 'arg1'), 'a1': ('val', 'arg2'), 'a2': ('val', 'arg3'), 'a3': ('val', 'arg4')}
    fresh = set(); out = {}

    def mk(e, r): return ('val', e) if len(e) <= 34 else ('val', f'{r} (calculated)')
    def desc(r):
        if r == 'zero': return '0'
        v = R.get(r)
        if not v: return r
        if v[0] == 'const': return str(v[1]) if v[1] < 10 else hex(v[1])
        if v[0] == 'cmp': return f'({v[1]} < {v[2]})'
        return v[1] if len(str(v[1])) <= 34 else r
    def enum(name, n):
        e = enums.get(str(name).split(' ')[0].split('+')[0], {})
        return f'{n} ({e[n]})' if n in e else str(n)
    def const_value(v, d):
        """A full 32-bit value was built in register d: name it if it's RAM or text."""
        tx = tlook(v)
        if tx: R[d] = ('val', tx[1]); return 'text', f'Use {tx[1]}'
        r = ra(v)
        if r is not None:
            name = lab(r) or f'RAM 0x{r:06X}'; R[d] = ('addr', name, r); return 'addr', f'{d} = address of {name}'
        R[d] = ('const', v); return 'quiet', f'{d} = {v if v < 10 else hex(v)}'
    def memname(l, base, off):
        b = R.get(base)
        if b and b[0] == 'addr':
            if len(b) > 3: return f'{b[1]}' + (f' field +0x{off:X}' if off else '')
            return lab(b[2] + off) or (b[1] if not off else f'{b[1]}+0x{off:X}')
        if 'mem' in l:
            r = ra(l['mem'])
            if r is not None: return lab(r) or f'RAM 0x{r:06X}'
        return None

    def one(l, in_delay=False):
        t = l['t']; op, _, rest = t.partition(' ')
        op = {'daddiu': 'addiu', 'daddu': 'addu', 'dsubu': 'subu', 'dsll': 'sll', 'dsrl': 'srl', 'dsra': 'sra', 'dsll32': 'sll', 'dsrl32': 'srl', 'dsra32': 'sra'}.get(op, op)
        ops = [o.strip() for o in rest.split(',')] if rest else []
        k, s = 'misc', None
        try:
            if op == 'nop': return 'quiet', None
            d = reg(ops[0]) if ops else None
            if op == 'lui':
                R[d] = ('const', (int(ops[1], 0) << 16) & 0xFFFFFFFF); k, s = 'quiet', f'{d} = upper half {ops[1]}'
            elif op in ('addiu', 'addi') and len(ops) == 3:
                srcr = reg(ops[1]); n = sext(int(ops[2], 0) & 0xFFFF)
                if d == 'sp' and srcr == 'sp': k, s = 'flow' if n < 0 else 'quiet', ('Start of function (make room on the stack)' if n < 0 else 'Free the stack space')
                elif srcr == 'zero': R[d] = ('const', n & 0xFFFFFFFF); k, s = 'quiet', f'{d} = {n}'
                elif (R.get(srcr) or ('',))[0] == 'const': k, s = const_value((R[srcr][1] + n) & 0xFFFFFFFF, d)
                elif (R.get(srcr) or ('',))[0] == 'addr':
                    r2 = R[srcr][2] + n; R[d] = ('addr', lab(r2) or f'{R[srcr][1]}+0x{n:X}', r2); k, s = 'addr', f'{d} = address of {R[d][1]}'
                elif srcr == 'sp': R[d] = ('val', 'a local'); k, s = 'quiet', f'{d} = address of a local'
                else: R[d] = mk(f'{desc(srcr)} {"+" if n >= 0 else "-"} {abs(n)}', d); k, s = 'quiet', f'{d} = {R[d][1]}'
            elif op == 'ori' and len(ops) == 3:
                srcr = reg(ops[1]); n = int(ops[2], 0)
                if srcr == 'zero': R[d] = ('const', n); k, s = 'quiet', f'{d} = {n}'
                elif (R.get(srcr) or ('',))[0] == 'const': k, s = const_value(R[srcr][1] | n, d)
                else: R[d] = mk(f'{desc(srcr)} | {n}', d); k, s = 'quiet', f'{d} = {R[d][1]}'
            elif op == 'li':
                k, s = const_value(int(ops[1], 0) & 0xFFFFFFFF, d)
            elif op == 'move' or (op in ('addu', 'or') and len(ops) == 3 and reg(ops[2]) == 'zero'):
                R[d] = (R.get(reg(ops[1])) or ('val', reg(ops[1]))) if reg(ops[1]) != 'zero' else ('const', 0); k, s = 'quiet', f'{d} = {desc(reg(ops[1]))}'
            elif op in SIZES and op.startswith('l'):
                m = re.fullmatch(r'(-?0x[0-9a-f]+|-?\d+)?\(\$(\w+)\)', ops[1]); off = int(m.group(1), 0) if m.group(1) else 0; base = m.group(2)
                name = memname(l, base, off)
                if name: R[d] = ('val', name); k, s = 'read', f'Read {name} ({SIZES[op]})'
                elif base == 'sp': R[d] = ('val', 'a saved value'); k, s = 'quiet', f'{d} = local variable'
                else: R[d] = mk(f'value at {desc(base)}' + (f'+{off}' if off else ''), d); k, s = 'quiet', f'{d} = {R[d][1]}'
            elif op in SIZES:
                src = reg(ops[0]); m = re.fullmatch(r'(-?0x[0-9a-f]+|-?\d+)?\(\$(\w+)\)', ops[1]); off = int(m.group(1), 0) if m.group(1) else 0; base = m.group(2)
                name = memname(l, base, off)
                v = R.get(src)
                val = '0' if src == 'zero' else (enum(name, v[1]) if v and v[0] == 'const' else desc(src))
                if name: k, s = 'write', f'Set {name} = {val}'
                elif base == 'sp': k, s = 'quiet', f'Save {desc(src)} on the stack'
                else: k, s = 'quiet', f'Store {val} at {desc(base)}' + (f'+{off}' if off else '')
            elif op in ('slt', 'sltu', 'slti', 'sltiu'):
                a = desc(reg(ops[1])); b = ops[2]
                bv = str(sext(int(b, 0) & 0xFFFF)) if op.endswith('i') else desc(reg(b))
                R[d] = ('cmp', a, bv); k, s = 'quiet', f'{d} = is {a} less than {bv}'
            elif op in ('beq', 'bne', 'beqz', 'bnez', 'blez', 'bgtz', 'bltz', 'bgez', 'beql', 'bnel'):
                tgt = int(ops[-1], 16); dest = L.get(tgt, f'0x{tgt:08X}')
                x = reg(ops[0]); y = reg(ops[1]) if op in ('beq', 'bne', 'beql', 'bnel') else 'zero'
                eq = op in ('beq', 'beqz', 'beql')
                xv = R.get(x)
                if op in ('beq', 'bne', 'beqz', 'bnez', 'beql', 'bnel') and y == 'zero' and xv and xv[0] == 'cmp':
                    cond = f'{xv[1]} is {"at least" if eq else "less than"} {xv[2]}'
                elif op in ('beq', 'bne', 'beql', 'bnel', 'beqz', 'bnez'):
                    yv = R.get(y)
                    yd = '0' if y == 'zero' else (enum(desc(x), yv[1]) if yv and yv[0] == 'const' else desc(y))
                    cond = f'{desc(x)} is {"" if eq else "not "}{yd}'
                else:
                    cond = f'{desc(x)} is ' + {'blez': 'at most 0', 'bgtz': 'more than 0', 'bltz': 'negative', 'bgez': 'not negative'}[op]
                if op in ('beq',) and x == 'zero' and y == 'zero': k, s = 'branch', f'Go to {dest}'
                else: k, s = 'branch', f'If {cond}, go to {dest}'
            elif op in ('b', 'j'):
                tgt = int(ops[-1], 16); k, s = 'branch', f'Go to {L.get(tgt, fname(tgt) if op == "j" else hex(tgt))}'
            elif op in ('jal', 'bal'):
                tgt = int(ops[-1], 16)
                args = ', '.join(desc(r) for r in ARGREGS if r in fresh)
                k, s = 'call', f'Call {fname(tgt)}({args})'
                for r in SCRATCH: R.pop(r, None)
                R['v0'] = ('val', f'result of {fname(tgt)}'); fresh.clear()
            elif op == 'jalr':
                k, s = 'call', f'Call the function whose address is in {desc(reg(ops[-1]))}'
                for r in SCRATCH: R.pop(r, None)
                fresh.clear()
            elif op == 'jr':
                if reg(ops[0]) == 'ra': k, s = 'flow', 'Return' + (f' {desc("v0")}' if R.get('v0') else '')
                else: k, s = 'branch', f'Jump to the address in {desc(reg(ops[0]))} (a switch or jump table)'
            elif op in ('sll', 'srl', 'sra') and len(ops) == 3:
                if op == 'sll' and d == 'zero': return 'quiet', None
                sym = '<<' if op == 'sll' else '>>'; R[d] = mk(f'{desc(reg(ops[1]))} {sym} {ops[2]}', d); k, s = 'quiet', f'{d} = {R[d][1]}'
            elif op in ('addu', 'add', 'subu', 'sub', 'and', 'or', 'xor', 'nor', 'andi', 'xori', 'sllv', 'srlv', 'srav') and len(ops) == 3:
                sym = {'addu': '+', 'add': '+', 'subu': '-', 'sub': '-', 'and': '&', 'or': '|', 'xor': '^', 'nor': 'nor',
                       'andi': '&', 'xori': '^', 'sllv': '<<', 'srlv': '>>', 'srav': '>>'}[op]
                b = ops[2] if op in ('andi', 'xori') else desc(reg(ops[2]))
                x1, x2 = R.get(reg(ops[1])), (R.get(reg(ops[2])) if op not in ('andi', 'xori') else None)
                if op in ('addu', 'add') and (bool(x1 and x1[0] == 'addr') != bool(x2 and x2[0] == 'addr')):
                    base, other = (x1, desc(reg(ops[2]))) if x1 and x1[0] == 'addr' else (x2, desc(reg(ops[1])))
                    tname = base[1].split(' entry')[0]
                    R[d] = ('addr', f'{tname} entry', base[2], 'indexed'); k, s = 'addr', f'{d} = address of an entry in {tname} (picked by {other})'
                else:
                    R[d] = mk(f'{desc(reg(ops[1]))} {sym} {b}', d); k, s = 'quiet', f'{d} = {R[d][1]}'
            elif op in ('mflo', 'mfhi'):
                R[d] = ('val', 'multiply/divide result'); k, s = 'quiet', f'{d} = multiply/divide result'
            elif op in ('mult', 'multu', 'div', 'divu'):
                k, s = 'quiet', f'{"Multiply" if op.startswith("mult") else "Divide"} {desc(reg(ops[0]))} by {desc(reg(ops[1]))}'
            if d and d.startswith('a') and d in ARGREGS and op not in SIZES or (op in ('lw', 'lh', 'lhu', 'lb', 'lbu') and d in ARGREGS):
                fresh.add(d)
        except (ValueError, AttributeError, IndexError, KeyError):
            k, s = 'misc', None
        if in_delay and s: s += ' (runs before the jump)'
        return k, s

    i = 0
    while i < len(ins):
        l = ins[i]
        if l['a'] in L:
            for r in SCRATCH: R.pop(r, None)
            fresh.clear()
        op = l['t'].split(' ')[0]
        is_jump = op in ('j', 'jal', 'jr', 'jalr', 'b', 'bal') or re.fullmatch(r'b(eq|ne|eqz|nez|lez|gtz|ltz|gez|eql|nel)', op)
        if is_jump and i + 1 < len(ins) and ins[i + 1]['a'] not in L:
            if op in ('j', 'jal', 'jr', 'jalr', 'b', 'bal'):   # the delay slot often sets up an argument
                out[ins[i + 1]['a']] = one(ins[i + 1], True); out[l['a']] = one(l)
            else:                                            # a branch tests its registers before the delay slot runs
                out[l['a']] = one(l); out[ins[i + 1]['a']] = one(ins[i + 1], True)
            i += 2; continue
        out[l['a']] = one(l)
        i += 1
    return out, L

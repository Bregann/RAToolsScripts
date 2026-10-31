"""Turn Thumb instructions into plain-English lines, tracking what each register holds."""
import re
COND = {'eq':('is','=='),'ne':('is not','!='),'gt':('is more than','>'),'lt':('is less than','<'),
        'ge':('is at least','>='),'le':('is at most','<='),'hi':('is more than','>'),'lo':('is less than','<'),
        'hs':('is at least','>='),'ls':('is at most','<='),'cs':('is at least','>='),'cc':('is less than','<'),
        'mi':('is negative',''),'pl':('is not negative','')}
NUM = lambda s: int(s, 0)
def translate(ins, lab, fname, pool, tlook=lambda v: None, enums=None, ra=None):
    ENUMS = enums or {}
    """ins: list of {'a','t','lit'?,'call'?}. lab(ra)->label or None. Returns {addr: (kind, text)}, labels {addr:'L1'}"""
    tgts = []
    for l in ins:
        m = re.match(r'b(?:[a-z]{2})?(?:\.w)? #(0x[0-9a-f]+)$', l['t'])
        if m and not l['t'].startswith('bl'):
            t = NUM(m.group(1))
            if ins[0]['a'] <= t <= ins[-1]['a'] and t not in tgts: tgts.append(t)
    tgts.sort(); L = {t: f'L{i+1}' for i, t in enumerate(tgts)}
    ARGS = {'r0':('val','arg1'),'r1':('val','arg2'),'r2':('val','arg3'),'r3':('val','arg4')}
    R = dict(ARGS); cmp = None; out = {}; fresh = set()
    def mk(expr, reg): return ('val', expr) if len(expr) <= 34 else ('val', f'{reg} (calculated)')
    def desc(r):
        v = R.get(r)
        if not v: return r
        if len(str(v[1])) > 34: return r
        if v[0] == 'const': return str(v[1]) if v[1] < 10 else hex(v[1])
        return v[1]
    def ra_of(v):
        if ra is not None: return ra(v)
        if 0x02000000 <= v < 0x02040000: return v - 0x02000000 + 0x8000
        if 0x03000000 <= v < 0x03008000: return v - 0x03000000
    def enum(name, n):
        base = name.split(' ')[0].split('+')[0]
        e = ENUMS.get(base, {})
        return f'{n} ({e[n]})' if n in e else str(n)
    for l in ins:
        a, t = l['a'], l['t']
        if a in pool: continue
        if a in L:  # paths merge here: forget scratch registers, keep r4-r7 (kept across calls)
            for r in ('r0','r1','r2','r3'): R.pop(r, None)
            cmp = None; fresh = set()
        op, _, rest = t.partition(' ')
        args = [x.strip() for x in re.split(r',(?![^\[]*\])', rest)] if rest else []
        k, s = 'misc', None
        try:
            if op == 'lsrs' and len(args) == 3 and args[2] == '#3':
                R[args[0]] = ('byteidx', desc(args[1])); k, s = 'quiet', f'{args[0]} = which byte holds bit {desc(args[1])}'
            elif op == 'adds' and len(args) == 3 and R.get(args[1], ('',))[0] == 'byteidx' and R.get(args[2], ('',))[0] == 'addr':
                R[args[0]] = ('bitbyte', R[args[2]][1], R[args[1]][1]); k, s = 'quiet', f'{args[0]} = that byte in {R[args[2]][1]}'
            elif op == 'adds' and len(args) == 3 and R.get(args[2], ('',))[0] == 'byteidx' and R.get(args[1], ('',))[0] == 'addr':
                R[args[0]] = ('bitbyte', R[args[1]][1], R[args[2]][1]); k, s = 'quiet', f'{args[0]} = that byte in {R[args[1]][1]}'
            elif op == 'ldrb' and len(args) == 2 and re.fullmatch(r'\[(r\d)\]', args[1]) and R.get(args[1][1:-1], ('',))[0] == 'bitbyte':
                b = R[args[1][1:-1]]; R[args[0]] = ('bytev', b[1], b[2]); k, s = 'read', f'Read {b[1]} (the byte with bit {b[2]})'
            elif op == 'orrs' and len(args) == 2 and 'bytev' in (R.get(args[0], ('',))[0], R.get(args[1], ('',))[0]):
                b = R[args[0]] if R.get(args[0], ('',))[0] == 'bytev' else R[args[1]]
                R[args[0]] = ('setv', b[1], b[2]); k, s = 'quiet', f'Turn bit {b[2]} on'
            elif op == 'strb' and len(args) == 2 and R.get(args[0], ('',))[0] == 'setv':
                b = R[args[0]]; k, s = 'write', f'Set bit {b[2]} in {b[1]}'
            elif op == 'asrs' and len(args) == 2 and R.get(args[0], ('',))[0] == 'bytev':
                b = R[args[0]]; R[args[0]] = ('val', f'bit {b[2]} of {b[1]}'); k, s = 'read', f'Check bit {b[2]} of {b[1]}'
            elif op == 'push':
                k, s = 'flow', 'Start of function (save registers)'
            elif op == 'pop' and 'pc' in rest or (op == 'bx' and args and args[0] in ('lr','r0','r1','r2','r3')):
                k, s = 'flow', 'Return' + (f' {desc("r0")}' if R.get('r0') else '')
            elif op == 'pop':
                k, s = 'quiet', 'Restore registers'
            elif op == 'ldr' and '[pc' in rest and 'lit' in l:
                v = l['lit']; r = ra_of(v); reg = args[0]; tx = tlook(v)
                if tx: R[reg] = ('val', tx[1]); k, s = 'text', f'Use {tx[1]}'
                elif r is not None:
                    name = lab(r) or f'RAM 0x{r:06X}'
                    R[reg] = ('addr', name, r); k, s = 'addr', f'{reg} = address of {name}'
                else: R[reg] = ('const', v); k, s = 'quiet', f'{reg} = 0x{v:X}'
            elif op in ('ldr','ldrh','ldrb','ldrsh','ldrsb') and len(args) == 2:
                reg = args[0]; m = re.match(r'\[(r\d+|sp)(?:, (#?-?0x[0-9a-f]+|#?-?\d+|r\d+))?\]', args[1])
                base, off = m.group(1), m.group(2)
                o = 0
                if off and off.startswith('r'):
                    o = R[off][1] if R.get(off, ('',None))[0] == 'const' else None
                elif off: o = NUM(off.lstrip('#'))
                size = {'ldr':'','ldrh':' (16-bit)','ldrsh':' (16-bit)','ldrb':' (8-bit)','ldrsb':' (8-bit)'}[op]
                b = R.get(base)
                if b and b[0] == 'addr' and o is not None:
                    name = lab(b[2] + o) or (b[1] if not o else f'{b[1]}+0x{o:X}')
                    R[reg] = ('val', name); k, s = 'read', f'Read {name}{size}'
                elif base == 'sp':
                    R[reg] = ('val', 'a local'); k, s = 'quiet', f'{reg} = local variable'
                else:
                    R[reg] = mk(f'value at {desc(base)}' + (f'+{o}' if o else ''), reg); k, s = 'quiet', f'{reg} = {R[reg][1]}'
            elif op in ('str','strh','strb') and len(args) == 2:
                src = args[0]; m = re.match(r'\[(r\d+|sp)(?:, (#?-?0x[0-9a-f]+|#?-?\d+|r\d+))?\]', args[1])
                base, off = m.group(1), m.group(2)
                o = 0
                if off and off.startswith('r'): o = R[off][1] if R.get(off, ('',None))[0] == 'const' else None
                elif off: o = NUM(off.lstrip('#'))
                b = R.get(base)
                if b and b[0] == 'addr' and o is not None:
                    name = lab(b[2] + o) or (b[1] if not o else f'{b[1]}+0x{o:X}')
                    v = R.get(src); val = enum(name, v[1]) if v and v[0] == 'const' else desc(src)
                    k, s = 'write', f'Set {name} = {val}'
                elif base == 'sp': k, s = 'quiet', f'Save {desc(src)} to a local variable'
                else: k, s = 'quiet', f'Store {desc(src)} at {desc(base)}'
            elif op in ('movs','mov') and len(args) == 2:
                d, x = args
                if x.startswith('#'): R[d] = ('const', NUM(x[1:])); k, s = 'quiet', f'{d} = {NUM(x[1:])}'
                else: R[d] = R.get(x); k, s = 'quiet', f'{d} = {desc(x)}'
            elif op in ('lsls','lsrs','asrs') and len(args) == 3 and args[2] in ('#0x10','#0x18','#16','#24'):
                R[args[0]] = R.get(args[1]); k, s = 'quiet', '(resize value)'
            elif op == 'cmp' and len(args) == 2:
                x = desc(args[0])
                if args[1].startswith('#'): cmp = (x, NUM(args[1][1:]))
                else: cmp = (x, desc(args[1]))
                k, s = 'quiet', f'Compare {x} with {cmp[1] if isinstance(cmp[1], str) else enum(x, cmp[1])}'
            elif re.match(r'b(eq|ne|gt|lt|ge|le|hi|lo|hs|ls|cs|cc|mi|pl)$', op):
                cc = op[1:]; tgt = NUM(args[0].lstrip('#')); dest = L.get(tgt, f'0x{tgt:08X}')
                if cmp:
                    x, n = cmp; word, sym = COND[cc]
                    nn = n if isinstance(n, str) else enum(x, n)
                    k, s = 'branch', f'If {x} {word} {nn}, go to {dest}'
                else: k, s = 'branch', f'If last result {COND[cc][0]}, go to {dest}'
            elif op in ('b','b.w'):
                tgt = NUM(args[0].lstrip('#')); k, s = 'branch', f'Go to {L.get(tgt, hex(tgt))}'
            elif op in ('bl', 'blx') and args and args[0].startswith('#'):
                tgt = l.get('call', NUM(args[0].lstrip('#')))
                argtxt = ', '.join(desc(r) for r in ('r0','r1','r2','r3') if r in fresh and R.get(r))
                k, s = 'call', f'Call {fname(tgt)}({argtxt})'
                for r in ('r0','r1','r2','r3'): R.pop(r, None)
                R['r0'] = ('val', f'result of {fname(tgt)}'); cmp = None; fresh = set()
            elif op in ('adds','add','subs','sub') and len(args) == 3 and args[2].startswith('#'):
                d, x = args[0], args[1]; n = NUM(args[2][1:]) * (1 if op.startswith('add') else -1); v = R.get(x)
                if n == 0: R[d] = v; k, s = 'quiet', f'{d} = {desc(x)}'
                elif v and v[0] == 'const': R[d] = ('const', v[1]+n); k, s = 'quiet', f'{d} = {v[1]+n}'
                else: R[d] = mk(f'{desc(x)} {"+" if n>0 else "-"} {abs(n)}', d); k, s = 'quiet', f'{d} = {R[d][1]}'
                cmp = (desc(d), 0)
            elif op in ('adds','add','subs','sub') and len(args) == 2 and args[1].startswith('#'):
                d = args[0]; n = NUM(args[1][1:]) * (1 if op.startswith('add') else -1); v = R.get(d)
                if v and v[0] == 'addr': R[d] = ('addr', lab(v[2]+n) or f'{v[1]}+0x{n:X}', v[2]+n); k, s = 'addr', f'{d} = address of {R[d][1]}'
                elif v and v[0] == 'const': R[d] = ('const', v[1]+n); k, s = 'quiet', f'{d} = {v[1]+n}'
                else: R[d] = mk(f'{desc(d)} {"+" if n>0 else "-"} {abs(n)}', d); k, s = 'quiet', f'{d} {"+=" if n>0 else "-="} {abs(n)}'
                cmp = (R[d][1] if R[d][0]!='const' else str(R[d][1]), 0)
            elif op in ('orrs','ands','eors','adds','subs','muls','bics') and len(args) >= 2:
                sym = {'orrs':'|','ands':'&','eors':'^','adds':'+','subs':'-','muls':'*','bics':'& ~'}[op]
                d = args[0]; y = args[-1]
                yv = y[1:] if y.startswith('#') else desc(y)
                R[d] = mk(f'{desc(d)} {sym} {yv}', d); k, s = 'quiet', f'{d} = {R[d][1]}'
                cmp = (R[d][1], 0)
            elif op in ('lsls','lsrs','asrs') and len(args) >= 2:
                sym = '<<' if op == 'lsls' else '>>'; d = args[0]; x = args[1] if len(args) == 3 else args[0]; n = args[-1].lstrip('#')
                R[d] = mk(f'{desc(x)} {sym} {n}', d); k, s = 'quiet', f'{d} = {R[d][1]}'
        except Exception:
            k, s = 'misc', None
        if args and re.fullmatch(r'r[0-3]', args[0]) and not op.startswith(('str','cmp','tst','b','push','pop')): fresh.add(args[0])
        out[a] = (k, s)
    return out, L

"""Disassembler for the Game Boy / Game Boy Color CPU (Sharp SM83). Table-built from the opcode bit fields."""
R8 = ['b', 'c', 'd', 'e', 'h', 'l', '(hl)', 'a']
RP = ['bc', 'de', 'hl', 'sp']
RP2 = ['bc', 'de', 'hl', 'af']
CC = ['nz', 'z', 'nc', 'c']
ALU = ['add a,', 'adc a,', 'sub', 'sbc a,', 'and', 'xor', 'or', 'cp']
ROT = ['rlc', 'rrc', 'rl', 'rr', 'sla', 'sra', 'swap', 'srl']
X7 = ['rlca', 'rrca', 'rla', 'rra', 'daa', 'cpl', 'scf', 'ccf']

# each entry: (text template, operand kind)  kinds: None, 'd8', 'd16', 'a16', 'e8', 'a8'
OPS = [None] * 256
for op in range(256):
    x, y, z = op >> 6, (op >> 3) & 7, op & 7
    p, q = y >> 1, y & 1
    t, k = None, None
    if x == 0:
        if z == 0:
            t, k = [('nop', None), ('ld ({a16}),sp', 'a16'), ('stop', 'd8'), ('jr {e8}', 'e8')][y] if y < 4 else (f'jr {CC[y - 4]},{{e8}}', 'e8')
        elif z == 1: t, k = (f'ld {RP[p]},{{d16}}', 'd16') if q == 0 else (f'add hl,{RP[p]}', None)
        elif z == 2:
            mem = ['(bc)', '(de)', '(hl+)', '(hl-)'][p]
            t = f'ld {mem},a' if q == 0 else f'ld a,{mem}'
        elif z == 3: t = f'{"inc" if q == 0 else "dec"} {RP[p]}'
        elif z == 4: t = f'inc {R8[y]}'
        elif z == 5: t = f'dec {R8[y]}'
        elif z == 6: t, k = f'ld {R8[y]},{{d8}}', 'd8'
        else: t = X7[y]
    elif x == 1:
        t = 'halt' if (y == 6 and z == 6) else f'ld {R8[y]},{R8[z]}'
    elif x == 2:
        t = f'{ALU[y]} {R8[z]}'.replace(', ', ',')
    else:
        if z == 0:
            t, k = (f'ret {CC[y]}', None) if y < 4 else [('ldh ({a8}),a', 'a8'), ('add sp,{e8}', 'e8'), ('ldh a,({a8})', 'a8'), ('ld hl,sp+{e8}', 'e8')][y - 4]
        elif z == 1: t = f'pop {RP2[p]}' if q == 0 else ['ret', 'reti', 'jp hl', 'ld sp,hl'][p]
        elif z == 2:
            t, k = (f'jp {CC[y]},{{a16}}', 'a16') if y < 4 else [('ld (c),a', None), ('ld ({a16}),a', 'a16'), ('ld a,(c)', None), ('ld a,({a16})', 'a16')][y - 4]
        elif z == 3: t, k = {0: ('jp {a16}', 'a16'), 1: ('cb', None), 6: ('di', None), 7: ('ei', None)}.get(y, (None, None))
        elif z == 4: t, k = (f'call {CC[y]},{{a16}}', 'a16') if y < 4 else (None, None)
        elif z == 5: t, k = (f'push {RP2[p]}', None) if q == 0 else (('call {a16}', 'a16') if p == 0 else (None, None))
        elif z == 6: t, k = (f'{ALU[y]} {{d8}}'.replace(', ', ','), 'd8')
        else: t = f'rst 0x{y * 8:02x}'
    OPS[op] = (t, k)

SIZE = {None: 1, 'd8': 2, 'a8': 2, 'e8': 2, 'd16': 3, 'a16': 3}

def decode(data, off, pc):
    """Decode one instruction at data[off] running at address pc.
    Returns dict: size, t (text), op (mnemonic), imm (number or None), target (for jumps/calls), mem (direct address)."""
    b = data[off]
    if b == 0xCB:
        if off + 1 >= len(data): return None
        c = data[off + 1]; x, y, z = c >> 6, (c >> 3) & 7, c & 7
        t = f'{ROT[y]} {R8[z]}' if x == 0 else f'{["bit", "res", "set"][x - 1]} {y},{R8[z]}'
        return {'size': 2, 't': t, 'op': t.split(' ')[0], 'imm': None}
    t, k = OPS[b]
    if t is None: return None
    n = SIZE[k]
    if off + n > len(data): return None
    imm = None; out = {'size': n}
    if k in ('d8', 'a8'): imm = data[off + 1]
    elif k == 'e8': e = data[off + 1]; imm = e - 256 if e > 127 else e
    elif k in ('d16', 'a16'): imm = data[off + 1] | data[off + 2] << 8
    if k == 'e8' and t.startswith('jr'):
        tgt = (pc + 2 + imm) & 0xFFFF; out['target'] = tgt; txt = t.replace('{e8}', f'0x{tgt:04x}')
    elif k == 'e8': txt = t.replace('{e8}', f'{imm:+d}')
    elif k == 'a8':
        out['mem'] = 0xFF00 + imm; txt = t.replace('{a8}', f'0xff{imm:02x}')
    elif k == 'a16':
        txt = t.replace('{a16}', f'0x{imm:04x}')
        if t.startswith(('jp', 'call')): out['target'] = imm
        else: out['mem'] = imm
    elif k == 'd16': txt = t.replace('{d16}', f'0x{imm:04x}')
    elif k == 'd8': txt = t.replace('{d8}', f'0x{imm:02x}')
    else: txt = t
    if txt.startswith('rst'): out['target'] = int(txt.split()[1], 16)
    out.update(t=txt, op=txt.split(' ')[0], imm=imm)
    return out

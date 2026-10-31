"""GDB remote protocol client, for emulators with a GDB server: DuckStation, mGBA, melonDS, PCSX2 builds with one,
Dolphin (where its GDB stub is available). Speaks the plain packet protocol over TCP."""
import re, socket, time

class GDBError(Exception): pass

def _cs(data): return sum(data) & 0xFF

def _unrle(s):
    out = bytearray(); i = 0
    while i < len(s):
        c = s[i]
        if c == 0x2A and out:   # '*': run-length, next char - 29 repeats
            n = s[i + 1] - 29; out += bytes([out[-1]]) * n; i += 2; continue
        if c == 0x7D: out.append(s[i + 1] ^ 0x20); i += 2; continue   # '}' escape
        out.append(c); i += 1
    return bytes(out)

MIPS_NAMES = ['zero', 'at', 'v0', 'v1', 'a0', 'a1', 'a2', 'a3', 't0', 't1', 't2', 't3', 't4', 't5', 't6', 't7', 's0', 's1', 's2', 's3',
              's4', 's5', 's6', 's7', 't8', 't9', 'k0', 'k1', 'gp', 'sp', 'fp', 'ra', 'sr', 'lo', 'hi', 'bad', 'cause', 'pc']
DEFAULT_REGS = {   # used when the server doesn't describe its registers (no target.xml)
    'mips': [(n, i, 32) for i, n in enumerate(MIPS_NAMES)],
    'arm': [(f'r{i}' if i < 13 else ['sp', 'lr', 'pc'][i - 13], i, 32) for i in range(16)],
    'ppc': [(f'r{i}', i, 32) for i in range(32)] + [(f'f{i}', 32 + i, 64) for i in range(32)] + [(n, 64 + i, 32) for i, n in enumerate(['pc', 'msr', 'cr', 'lr', 'ctr', 'xer'])],
}

class GDB:
    def __init__(self, host='127.0.0.1', port=2345, big_endian=False, timeout=5.0, arch='mips'):
        self.big = big_endian; self.arch = arch; self.code_bps = set(); self.code_bps_len = {}; self.buf = b''; self.noack = False; self.running = False
        try: self.s = socket.create_connection((host, port), timeout=timeout)
        except OSError as e: raise GDBError(f'Couldn\'t connect to a GDB server on {host}:{port} ({e}). Is the emulator\'s GDB server turned on, and a game running?')
        self.s.settimeout(timeout); self.pkt_size = 0x1000
        sup = self.cmd('qSupported:swbreak+;hwbreak+;xmlRegisters=mips,arm,powerpc')
        m = re.search(r'PacketSize=([0-9a-fA-F]+)', sup)
        if m: self.pkt_size = max(0x200, int(m.group(1), 16))
        self.features = sup
        if 'QStartNoAckMode+' in sup and self.cmd('QStartNoAckMode') == 'OK': self.noack = True
        self.stop = self.cmd('?')
        self.regs = self._target_regs() or DEFAULT_REGS.get(arch, [])

    # ---- packets ----
    def _send(self, data):
        if isinstance(data, str): data = data.encode('latin1')
        pkt = b'$' + data + b'#' + f'{_cs(data):02x}'.encode()
        for _ in range(3):
            self.s.sendall(pkt)
            if self.noack: return
            c = self._recv_byte()
            while c not in (b'+', b'-'):
                if c == b'$': self.buf = b'$' + self.buf; return   # some stubs skip the ack
                c = self._recv_byte()
            if c == b'+': return
        raise GDBError('The GDB server kept rejecting packets.')
    def _recv_byte(self):
        while not self.buf: self._fill()
        c, self.buf = self.buf[:1], self.buf[1:]; return c
    def _fill(self, timeout=None):
        if timeout is not None: self.s.settimeout(timeout)
        try: d = self.s.recv(65536)
        finally:
            if timeout is not None: self.s.settimeout(5.0)
        if not d: raise GDBError('The emulator closed the GDB connection.')
        self.buf += d
    def _recv(self, timeout=None):
        """Next packet's payload (as str). Output packets ('O...') are skipped."""
        deadline = None if timeout is None else time.time() + timeout
        while True:
            while True:
                i = self.buf.find(b'$')
                if i >= 0:
                    j = self.buf.find(b'#', i)
                    if j >= 0 and len(self.buf) >= j + 3: break
                if deadline is not None and time.time() > deadline: raise socket.timeout()
                self._fill(None if deadline is None else max(0.01, deadline - time.time()))
            data = self.buf[i + 1:j]; self.buf = self.buf[j + 3:]
            if not self.noack: self.s.sendall(b'+')
            data = _unrle(data).decode('latin1')
            if data.startswith('O') and not data.startswith('OK') and re.fullmatch(r'O[0-9a-fA-F]*', data): continue
            return data
    def cmd(self, data, timeout=None):
        self._send(data); return self._recv(timeout)

    # ---- registers ----
    def _xfer(self, annex):
        out = ''; off = 0
        while True:
            r = self.cmd(f'qXfer:features:read:{annex}:{off:x},{self.pkt_size - 16:x}')
            if not r or r[0] not in 'ml': return None
            out += r[1:]; off += len(r) - 1
            if r[0] == 'l': return out
    def _target_regs(self):
        regs = []
        xml = self._xfer('target.xml') if 'qXfer:features:read+' in self.features else None
        if xml:
            for inc in re.findall(r'<xi:include href="([^"]+)"', xml):
                xml += self._xfer(inc) or ''
            n = 0
            for m in re.finditer(r'<reg\b([^>]*)>', xml):
                a = dict(re.findall(r'(\w+)="([^"]*)"', m.group(1)))
                if 'regnum' in a: n = int(a['regnum'])
                regs.append((a.get('name', f'r{n}'), n, int(a.get('bitsize', 32)))); n += 1
        return regs
    def reg_num(self, name):
        for n_, num, bits in self.regs:
            if n_.lower() == name.lower(): return num, bits
        return None
    def read_reg(self, name, default_num=None):
        r = self.reg_num(name)
        num = r[0] if r else (default_num if default_num is not None else {'mips': 37, 'arm': 15, 'ppc': 64}.get(self.arch) if name == 'pc' else default_num)
        if num is None: raise GDBError(f'This GDB server has no register called {name}.')
        v = self.cmd(f'p{num:x}')
        if not v or v.startswith('E'): raise GDBError(f'Reading {name} failed ({v}).')
        b = bytes.fromhex(v[:16] if len(v) > 16 else v)
        return int.from_bytes(b, 'big' if self.big else 'little')
    def all_regs(self):
        g = self.cmd('g')
        if not g or g.startswith('E'): raise GDBError(f'Reading registers failed ({g}).')
        out = {}; o = 0; raw = bytes.fromhex(g)
        regs = self.regs or []
        for name, num, bits in sorted(regs, key=lambda r: r[1]):
            n = bits // 8
            if o + n > len(raw): break
            out[name] = int.from_bytes(raw[o:o + n], 'big' if self.big else 'little'); o += n
        return out

    # ---- memory ----
    def read(self, addr, n):
        out = bytearray(); step = max(16, (self.pkt_size - 32) // 2)
        while len(out) < n:
            k = min(step, n - len(out))
            r = self.cmd(f'm{addr + len(out):x},{k:x}')
            if not r or r.startswith('E'): raise GDBError(f'Reading memory at 0x{addr + len(out):08X} failed ({r}).')
            out += bytes.fromhex(r)
        return bytes(out)
    def write(self, addr, data):
        step = max(16, (self.pkt_size - 64) // 2)
        for o in range(0, len(data), step):
            ch = data[o:o + step]
            r = self.cmd(f'M{addr + o:x},{len(ch):x}:{ch.hex()}')
            if r != 'OK': raise GDBError(f'Writing memory at 0x{addr + o:08X} failed ({r}).')

    # ---- running ----
    def interrupt(self):
        self.s.sendall(b'\x03')
        try: r = self._recv(3.0)
        except socket.timeout: r = ''
        self.running = False; return r
    def _step_off_bp(self):
        """Continuing from a code breakpoint would hit it again straight away: step past it first."""
        if not self.code_bps: return
        try: pc = self.read_reg('pc')
        except GDBError: return
        if pc in self.code_bps:
            self.cmd(f'z0,{pc:x},{self.code_bps_len.get(pc, 4):x}'); self.step(); self.cmd(f'Z0,{pc:x},{self.code_bps_len.get(pc, 4):x}')
    def cont(self, timeout, should_stop=None):
        """Continue; returns the stop reply, or None if it hadn't stopped by the timeout (then it's paused)."""
        self._step_off_bp()
        self._send('c'); self.running = True
        deadline = time.time() + timeout
        while True:
            try: r = self._recv(min(0.5, max(0.05, deadline - time.time()))); self.running = False; return r
            except socket.timeout:
                if time.time() >= deadline or (should_stop and should_stop()): self.interrupt(); return None
    def resume(self):
        self._step_off_bp(); self._send('c'); self.running = True
    def step(self):
        return self.cmd('s', timeout=5)
    def set_bp(self, kind, addr, length=4, on=True):
        """kind 0 code, 2 write watch, 3 read watch, 4 access watch."""
        r = self.cmd(f'{"Z" if on else "z"}{kind},{addr:x},{length:x}')
        if r != 'OK': raise GDBError(f'The GDB server refused that {"breakpoint" if kind == 0 else "watchpoint"} ({r or "not supported"}).')
        if kind == 0:
            if on: self.code_bps.add(addr); self.code_bps_len[addr] = length
            else: self.code_bps.discard(addr)
    def close(self):
        try:
            if self.running: self.interrupt()
            self._send('D')
        except (OSError, GDBError): pass
        try: self.s.close()
        except OSError: pass

def parse_stop(r):
    """Stop reply -> dict: signal, kind (watch/rwatch/awatch/swbreak/...), addr."""
    if not r: return {}
    out = {'raw': r}
    if r[0] in 'ST': out['signal'] = int(r[1:3], 16)
    for k, v in re.findall(r'([a-z]+):([0-9a-fA-F]+);', r[3:] if r[0] == 'T' else ''):
        if k in ('watch', 'rwatch', 'awatch'): out['kind'] = k; out['addr'] = int(v, 16)
        elif k in ('swbreak', 'hwbreak'): out['kind'] = 'break'
    return out

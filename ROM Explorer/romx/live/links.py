"""Links to emulators that aren't GDB: PINE (PCSX2), PPSSPP's WebSocket debugger, RetroArch network commands,
and Dolphin's RAM read straight from its process (Windows)."""
import base64, json, os, random, socket, struct, sys, time

class LinkError(Exception): pass

# ---------------- PINE (PCSX2, RPCS3) ----------------
class PINE:
    """PINE protocol: [u32 size][u8 opcode][args...], reply [u32 size][u8 result 0=ok][data]."""
    def __init__(self, host='127.0.0.1', port=28011):
        try:
            if sys.platform == 'win32' or host not in ('127.0.0.1', 'localhost') or os.environ.get('ROMX_PINE_TCP'):
                self.s = socket.create_connection((host, port), timeout=5)
            else:   # Linux/macOS: a Unix socket named by the slot number
                base = os.environ.get('XDG_RUNTIME_DIR') or os.environ.get('TMPDIR') or '/tmp'
                path = os.path.join(base, 'pcsx2.sock' if port == 28011 else f'pcsx2.sock.{port}')
                self.s = socket.socket(socket.AF_UNIX); self.s.settimeout(5); self.s.connect(path)
        except OSError as e:
            raise LinkError(f'Couldn\'t reach PCSX2\'s PINE server on port {port} ({e}). Turn it on in PCSX2: Settings > Advanced > Enable PINE, then start the game.')
    def _call(self, payloads):
        msg = b''.join(payloads); self.s.sendall(struct.pack('<I', len(msg) + 4) + msg)
        head = self._recvn(4); n = struct.unpack('<I', head)[0]; body = self._recvn(n - 4)
        if not body or body[0] != 0: raise LinkError('PCSX2 refused the request (is a game running?).')
        return body[1:]
    def _recvn(self, n):
        out = b''
        while len(out) < n:
            d = self.s.recv(n - len(out))
            if not d: raise LinkError('PCSX2 closed the PINE connection.')
            out += d
        return out
    def read(self, addr, n):
        out = bytearray(); a = addr
        while a < addr + n:   # batches of 64-bit reads (+ 8-bit for the tail)
            batch = []; sizes = []
            while a < addr + n and len(batch) < 400:
                if addr + n - a >= 8 and a % 8 == 0: batch.append(struct.pack('<BI', 3, a)); sizes.append(8); a += 8
                else: batch.append(struct.pack('<BI', 0, a)); sizes.append(1); a += 1
            data = self._call(batch)
            out += data[:sum(sizes)]
        return bytes(out[:n])
    def write(self, addr, data):
        batch = [struct.pack('<BIB', 4, addr + i, b) for i, b in enumerate(data)]
        for i in range(0, len(batch), 400): self._call(batch[i:i + 400])
    def save_state(self, slot): self._call([struct.pack('<BB', 9, slot)])
    def load_state(self, slot): self._call([struct.pack('<BB', 10, slot)])
    def _str(self, op):
        d = self._call([bytes([op])]); n = struct.unpack_from('<I', d)[0]; return d[4:4 + n].split(b'\x00')[0].decode('utf-8', 'replace')
    def info(self):
        out = {}
        for k, op in (('title', 11), ('serial', 12), ('version', 8)):
            try: out[k] = self._str(op)
            except (LinkError, struct.error): pass
        try: out['status'] = {0: 'running', 1: 'paused', 2: 'shut down'}.get(struct.unpack('<I', self._call([bytes([15])])[:4])[0], '?')
        except (LinkError, struct.error): pass
        return out
    def close(self):
        try: self.s.close()
        except OSError: pass

# ---------------- RetroArch network commands ----------------
class RetroArch:
    """UDP commands (Settings > Network > Network Commands). READ_CORE_RAM uses RetroAchievements addresses."""
    def __init__(self, host='127.0.0.1', port=55355):
        self.addr = (host, port); self.s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); self.s.settimeout(1.5)
        st = self.ask('GET_STATUS')
        if st is None: raise LinkError(f'RetroArch didn\'t answer on port {port}. Turn on Settings > Network > Network Commands (and check the port), then load the game.')
        self.status = st; self.ram_cmd = None
    def ask(self, cmd, expect=True):
        self.s.setblocking(False)   # drop replies to earlier fire-and-forget commands
        try:
            while self.s.recv(65536): pass
        except (BlockingIOError, OSError): pass
        self.s.settimeout(1.5)
        self.s.sendto(cmd.encode(), self.addr)
        if not expect: return ''
        try: return self.s.recv(65536).decode('latin1').strip()
        except socket.timeout: return None
    def _read_cmd(self, cmd, a, n):
        r = self.ask(f'{cmd} {a:x} {n}')
        if not r: return None
        p = r.split()
        if len(p) < 3 or p[2] == '-1': return None
        return bytes(int(x, 16) for x in p[2:2 + n])
    def read(self, addr, n, ra=True):
        out = bytearray()
        for o in range(0, n, 2048):
            k = min(2048, n - o); d = None
            for cmd in ([self.ram_cmd] if self.ram_cmd else ['READ_CORE_RAM', 'READ_CORE_MEMORY'] if ra else ['READ_CORE_MEMORY']):
                d = self._read_cmd(cmd, addr + o, k)
                if d is not None: self.ram_cmd = cmd; break
            if d is None: raise LinkError(f'RetroArch couldn\'t read 0x{addr + o:X}. (RetroAchievements must be enabled for addresses to match, and the address must be in the console\'s RAM.)')
            out += d
        return bytes(out)
    def write(self, addr, data):
        cmd = 'WRITE_CORE_RAM' if self.ram_cmd != 'READ_CORE_MEMORY' else 'WRITE_CORE_MEMORY'
        for o in range(0, len(data), 1024):
            self.ask(f'{cmd} {addr + o:x} ' + ' '.join(f'{b:02x}' for b in data[o:o + 1024]), expect=False)
    def save_state(self, slot=None):
        self.ask('SAVE_STATE', False)   # RetroArch saves to its current slot (no command picks the slot)
    def load_state(self, slot): self.ask(f'LOAD_STATE_SLOT {int(slot)}', False)
    def pause_toggle(self): self.ask('PAUSE_TOGGLE', False)
    def frame_advance(self, n=1):
        for _ in range(n): self.ask('FRAMEADVANCE', False); time.sleep(0.02)
    def paused(self):
        st = self.ask('GET_STATUS') or ''
        return 'PAUSED' in st
    def screenshot(self): self.ask('SCREENSHOT', False)
    def info(self): return {'status': self.ask('GET_STATUS') or self.status}
    def close(self):
        try: self.s.close()
        except OSError: pass

# ---------------- PPSSPP WebSocket debugger ----------------
class PPSSPP:
    """PPSSPP: Settings > Tools > Developer tools > Allow remote debugger. The port is shown there."""
    def __init__(self, host='127.0.0.1', port=None):
        ports = [port] if port else self._discover()
        if not ports: raise LinkError('Give the PPSSPP debugger port: PPSSPP shows it under Settings > Tools > Developer tools after you turn on "Allow remote debugger".')
        err = None
        for p in ports:
            try: self._open(host, p); self.port = p; break
            except OSError as e: err = e
        else: raise LinkError(f'Couldn\'t connect to PPSSPP\'s debugger ({err}). Check "Allow remote debugger" is on and the port is right.')
        self.events = []; self.t = 0
        self.call('version', name='ROM Explorer', version='1.0')
    def _discover(self):
        """PPSSPP lists itself (local address and port) at report.ppsspp.org when the debugger is on."""
        try:
            import urllib.request
            lst = json.loads(urllib.request.urlopen('http://report.ppsspp.org/match/list', timeout=4).read())
            return [x['p'] for x in lst if str(x.get('ip', '')).startswith(('127.', '192.168.', '10.', '172.'))][:4]
        except Exception: return []
    def _open(self, host, port):
        s = socket.create_connection((host, port), timeout=5)
        key = base64.b64encode(os.urandom(16)).decode()
        s.sendall((f'GET /debugger HTTP/1.1\r\nHost: {host}:{port}\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n'
                   f'Sec-WebSocket-Key: {key}\r\nSec-WebSocket-Version: 13\r\nSec-WebSocket-Protocol: debugger.ppsspp.org\r\n\r\n').encode())
        resp = b''
        while b'\r\n\r\n' not in resp:
            d = s.recv(4096)
            if not d: raise OSError('closed during handshake')
            resp += d
        if b' 101 ' not in resp.split(b'\r\n')[0]: raise OSError('not a WebSocket server')
        self.s = s; self.rbuf = resp.split(b'\r\n\r\n', 1)[1]
    def _send(self, obj):
        data = json.dumps(obj).encode(); mask = os.urandom(4)
        n = len(data); hdr = bytearray([0x81])
        if n < 126: hdr.append(0x80 | n)
        elif n < 65536: hdr += bytes([0x80 | 126]) + struct.pack('>H', n)
        else: hdr += bytes([0x80 | 127]) + struct.pack('>Q', n)
        self.s.sendall(bytes(hdr) + mask + bytes(b ^ mask[i % 4] for i, b in enumerate(data)))
    def _need(self, n, deadline):
        while len(self.rbuf) < n:
            self.s.settimeout(max(0.01, deadline - time.time()))
            try: d = self.s.recv(65536)
            except socket.timeout: raise TimeoutError()
            if not d: raise LinkError('PPSSPP closed the debugger connection.')
            self.rbuf += d
    def _recv(self, timeout):
        deadline = time.time() + timeout; msg = b''
        while True:
            self._need(2, deadline); b0, b1 = self.rbuf[0], self.rbuf[1]; n = b1 & 0x7F; o = 2
            if n == 126: self._need(4, deadline); n = struct.unpack('>H', self.rbuf[2:4])[0]; o = 4
            elif n == 127: self._need(10, deadline); n = struct.unpack('>Q', self.rbuf[2:10])[0]; o = 10
            if b1 & 0x80: o += 4
            self._need(o + n, deadline); payload = self.rbuf[o:o + n]; self.rbuf = self.rbuf[o + n:]
            op = b0 & 0x0F
            if op == 9: continue   # ping (pong not needed for short sessions)
            if op == 8: raise LinkError('PPSSPP closed the debugger connection.')
            msg += payload
            if b0 & 0x80: return json.loads(msg.decode('utf-8', 'replace'))
    def call(self, event, timeout=10, **params):
        self.t += 1; ticket = str(self.t); self._send(dict(params, event=event, ticket=ticket))
        deadline = time.time() + timeout
        while True:
            m = self._recv(max(0.05, deadline - time.time()))
            if m.get('ticket') == ticket:
                if m.get('event') == 'error': raise LinkError(f'PPSSPP: {m.get("message")}')
                return m
            self.events.append(m)
    def wait_event(self, name, timeout):
        for i, m in enumerate(self.events):
            if m.get('event') == name: return self.events.pop(i)
        deadline = time.time() + timeout
        while time.time() < deadline:
            try: m = self._recv(max(0.05, deadline - time.time()))
            except TimeoutError: return None
            if m.get('event') == name: return m
            self.events.append(m)
        return None
    def read(self, addr, n):
        out = bytearray()
        for o in range(0, n, 0x10000):
            out += base64.b64decode(self.call('memory.read', address=addr + o, size=min(0x10000, n - o))['base64'])
        return bytes(out)
    def write(self, addr, data): self.call('memory.write', address=addr, base64=base64.b64encode(data).decode())
    def close(self):
        try: self.s.close()
        except OSError: pass

# ---------------- Dolphin: RAM straight from its process (Windows) ----------------
class DolphinMemory:
    """Like Dolphin Memory Engine: finds the emulated MEM1 (and Wii MEM2) inside Dolphin's process and reads it.
    Works with any Dolphin build; no pausing, breakpoints or input."""
    def __init__(self, game_id=''):
        if sys.platform != 'win32': raise LinkError('Reading Dolphin\'s RAM directly only works on Windows.')
        import ctypes
        from ctypes import wintypes as W
        self.k = ctypes.WinDLL('kernel32', use_last_error=True); self.ct = ctypes; self.W = W
        pid = _find_pid(('dolphin.exe', 'dolphinqt2.exe', 'dolphin-emu.exe'))
        if not pid: raise LinkError('Dolphin isn\'t running.')
        self.h = self.k.OpenProcess(0x0010 | 0x0020 | 0x0008 | 0x0400, False, pid)
        if not self.h: raise LinkError('Couldn\'t open Dolphin\'s process (try running ROM Explorer\'s Claude link as the same user as Dolphin).')
        class MBI(ctypes.Structure):
            _fields_ = [('BaseAddress', ctypes.c_void_p), ('AllocationBase', ctypes.c_void_p), ('AllocationProtect', W.DWORD), ('PartitionId', W.WORD),
                        ('RegionSize', ctypes.c_size_t), ('State', W.DWORD), ('Protect', W.DWORD), ('Type', W.DWORD)]
        mbi = MBI(); a = 0; self.mem1 = self.mem2 = None
        VQ = self.k.VirtualQueryEx; VQ.argtypes = [W.HANDLE, ctypes.c_void_p, ctypes.POINTER(MBI), ctypes.c_size_t]; VQ.restype = ctypes.c_size_t
        while VQ(self.h, a, ctypes.byref(mbi), ctypes.sizeof(mbi)):
            base = mbi.BaseAddress or 0
            if mbi.Type == 0x40000 and mbi.State == 0x1000:   # MEM_MAPPED, MEM_COMMIT
                if mbi.RegionSize == 0x2000000 and self.mem1 is None:
                    head = self._rp(base, 6)
                    if head and (not game_id or head.decode('latin1', 'replace') == game_id[:6]): self.mem1 = base
                elif mbi.RegionSize == 0x4000000 and self.mem1 is not None and self.mem2 is None: self.mem2 = base
            a = base + mbi.RegionSize
            if a >= 0x7FFFFFFFFFFF: break
        if self.mem1 is None: raise LinkError('Found Dolphin, but not the game\'s RAM in it. Is the game running' + (f' (looking for {game_id})?' if game_id else '?'))
    def _rp(self, addr, n):
        buf = self.ct.create_string_buffer(n); got = self.ct.c_size_t()
        ok = self.k.ReadProcessMemory(self.h, self.ct.c_void_p(addr), buf, n, self.ct.byref(got))
        return buf.raw[:got.value] if ok else None
    def _where(self, bus):
        if 0x80000000 <= bus < 0x81800000: return self.mem1 + bus - 0x80000000
        if 0x90000000 <= bus < 0x94000000 and self.mem2: return self.mem2 + bus - 0x90000000
        raise LinkError(f'0x{bus:08X} isn\'t in MEM1' + (' or MEM2' if self.mem2 else '') + '.')
    def read(self, addr, n):
        d = self._rp(self._where(addr), n)
        if d is None: raise LinkError('Reading Dolphin\'s memory failed.')
        return d
    def write(self, addr, data):
        got = self.ct.c_size_t()
        if not self.k.WriteProcessMemory(self.h, self.ct.c_void_p(self._where(addr)), data, len(data), self.ct.byref(got)): raise LinkError('Writing Dolphin\'s memory failed.')
    def close(self):
        try: self.k.CloseHandle(self.h)
        except Exception: pass

def _find_pid(names):
    if sys.platform != 'win32': return None
    import ctypes
    from ctypes import wintypes as W
    class PE(ctypes.Structure):
        _fields_ = [('dwSize', W.DWORD), ('cntUsage', W.DWORD), ('th32ProcessID', W.DWORD), ('th32DefaultHeapID', ctypes.c_void_p),
                    ('th32ModuleID', W.DWORD), ('cntThreads', W.DWORD), ('th32ParentProcessID', W.DWORD), ('pcPriClassBase', ctypes.c_long),
                    ('dwFlags', W.DWORD), ('szExeFile', ctypes.c_wchar * 260)]
    k = ctypes.WinDLL('kernel32'); snap = k.CreateToolhelp32Snapshot(2, 0); pe = PE(); pe.dwSize = ctypes.sizeof(PE)
    ok = k.Process32FirstW(snap, ctypes.byref(pe)); pid = None
    while ok:
        if pe.szExeFile.lower() in names: pid = pe.th32ProcessID; break
        ok = k.Process32NextW(snap, ctypes.byref(pe))
    k.CloseHandle(snap); return pid

# ---------------- mGBA via its scripting (romx_mgba.lua) ----------------
class MGBAScript:
    """mGBA running romx/live/romx_mgba.lua (Tools > Scripting > Load script). Reads don't pause the game."""
    PORT = 61234
    KEYS = {'a': 0, 'b': 1, 'select': 2, 'start': 3, 'right': 4, 'left': 5, 'up': 6, 'down': 7, 'r': 8, 'l': 9}
    def __init__(self, host='127.0.0.1', port=None):
        self.port = port or self.PORT
        try: self.s = socket.create_connection((host, self.port), timeout=3)
        except OSError: raise LinkError('mGBA\'s ROM Explorer script isn\'t running.')
        self.buf = b''
        r = self.ask('PING')
        if not r.startswith('OK'): raise LinkError(f'mGBA script answered oddly: {r}')
        self.game = r[3:].replace('mgba', '', 1).strip()
    def ask(self, line, timeout=5.0):
        self.s.sendall((line + '\n').encode())
        self.s.settimeout(timeout)
        while b'\n' not in self.buf:
            try: d = self.s.recv(65536)
            except socket.timeout: raise LinkError('mGBA didn\'t answer. Is the game running (not paused)?')
            if not d: raise LinkError('mGBA closed the connection (was the script stopped?).')
            self.buf += d
        line, self.buf = self.buf.split(b'\n', 1)
        r = line.decode('latin1').strip()
        if r.startswith('ERR'): raise LinkError('mGBA: ' + r[4:])
        return r
    def read(self, addr, n):
        out = bytearray()
        for o in range(0, n, 2048):
            k = min(2048, n - o); r = self.ask(f'READ {addr + o:x} {k}')
            out += bytes.fromhex(r[3:])
        return bytes(out)
    def read_many(self, items):
        r = self.ask('READ ' + ' '.join(f'{a:x} {n}' for a, n in items))
        return [bytes.fromhex(x) for x in r[3:].split()]
    def write(self, addr, data): self.ask(f'WRITE {addr:x} {data.hex()}')
    def save_state(self, slot): self.ask(f'SAVE {int(slot)}')
    def load_state(self, slot): self.ask(f'LOAD {int(slot)}')
    def press(self, buttons, frames):
        mask = 0
        for b in buttons:
            k = self.KEYS.get(b.lower().strip())
            if k is None: raise LinkError(f'Unknown GBA button "{b}". Use A, B, Select, Start, Up, Down, Left, Right, L, R.')
            mask |= 1 << k
        self.ask(f'KEYS {mask} {max(1, int(frames))}', timeout=max(5, frames / 30 + 3))
    def screenshot(self):
        import tempfile
        p = os.path.join(tempfile.gettempdir(), f'romx_mgba_{os.getpid()}.png')
        try: os.remove(p)
        except OSError: pass
        self.ask('SHOT ' + p.replace('\\', '/'))
        for _ in range(40):
            if os.path.exists(p) and os.path.getsize(p) > 0:
                time.sleep(0.05); return open(p, 'rb').read()
            time.sleep(0.05)
        raise LinkError('mGBA didn\'t save the screenshot.')
    def watch(self, addr, size, timeout, should_stop=None):
        frames = int(timeout * 60)
        self.s.sendall(f'WATCH {addr:x} {size} {frames}\n'.encode())
        deadline = time.time() + timeout + 5
        while time.time() < deadline:
            if should_stop and should_stop():
                self.s.sendall(b'UNWATCH\n'); self._drain_until_ok(); return None
            try: r = self.ask_wait(0.5)
            except socket.timeout: continue
            if r.startswith('CHANGED'):
                _, old, new, after = r.split(); return {'old': int(old), 'new': int(new), 'frames': int(after)}
            return None
        return None
    def ask_wait(self, t):
        self.s.settimeout(t)
        while b'\n' not in self.buf:
            d = self.s.recv(65536)
            if not d: raise LinkError('mGBA closed the connection.')
            self.buf += d
        line, self.buf = self.buf.split(b'\n', 1); return line.decode('latin1').strip()
    def _drain_until_ok(self):
        for _ in range(4):
            try:
                if self.ask_wait(2) == 'OK': return
            except (socket.timeout, LinkError): return
    def info(self): return {'game': self.game}
    def close(self):
        try: self.s.close()
        except OSError: pass

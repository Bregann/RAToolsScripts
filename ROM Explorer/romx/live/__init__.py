"""A live connection to a running emulator, with one interface whatever the emulator is.
Addresses going in and out are RetroAchievements addresses; code addresses (PC, breakpoints) are console addresses.

  retroarch   RetroArch network commands (any core). RAM by RA address, states, pause, frame advance.
  duckstation DuckStation's GDB server (PS1): RAM, pause/step, registers, breakpoints, read/write watchpoints.
  pcsx2       PCSX2's PINE server: RAM and states (and its GDB server too if your build has one: give gdb_port).
  ppsspp      PPSSPP's remote debugger: RAM, pause/step, registers, breakpoints, memory watchpoints, buttons, screenshots, states.
  mgba        mGBA's GDB server (GBA).   melonds  melonDS's GDB server (DS, ARM9).
  dolphin     Dolphin's GDB server if you give a port, otherwise its RAM read straight from the process (Windows).
  gdb         any other GDB server (give the port).
On Windows, screenshots and key presses fall back to capturing / typing into the emulator's window."""
import base64, time
from .gdb import GDB, GDBError, parse_stop
from .links import PINE, PPSSPP, RetroArch, DolphinMemory, MGBAScript, LinkError
from . import win

ARCH = {'ps1': 'mips', 'ps2': 'mips', 'psp': 'mips', 'gba': 'arm', 'nds': 'arm', 'gc': 'ppc', 'gb': None}
DEFAULT_PORT = {'retroarch': 55355, 'duckstation': 2345, 'pcsx2': 28011, 'mgba': 2345, 'melonds': 3333, 'gdb': 2345}
CONSOLES = {'duckstation': ('ps1',), 'pcsx2': ('ps2',), 'ppsspp': ('psp',), 'mgba': ('gba',), 'melonds': ('nds',), 'dolphin': ('gc',)}
PSP_BUTTONS = {'x': 'cross', 'cross': 'cross', 'o': 'circle', 'circle': 'circle', 'triangle': 'triangle', 'square': 'square', 'up': 'up', 'down': 'down',
               'left': 'left', 'right': 'right', 'start': 'start', 'select': 'select', 'l': 'ltrigger', 'r': 'rtrigger', 'ltrigger': 'ltrigger', 'rtrigger': 'rtrigger', 'home': 'home'}

class LiveError(Exception): pass

class Session:
    def __init__(self, emulator, P, img, host='127.0.0.1', port=None, gdb_port=None, keymap=''):
        self.emu = emulator = emulator.lower().strip(); self.P = P; self.img = img
        if emulator in CONSOLES and P.KEY not in CONSOLES[emulator]:
            raise LiveError(f'{emulator} doesn\'t run {P.NAME} games. Open the right project, or pick another emulator.')
        self.keymap = win.parse_keymap(keymap, emulator)
        self.big = P.KEY == 'gc'; self.ra_space = False
        self.gdb = self.link = None; self.paused = False
        port = port or DEFAULT_PORT.get(emulator)
        try:
            if emulator == 'retroarch':
                self.link = RetroArch(host, port); self.ra_space = True
            elif emulator == 'pcsx2':
                self.link = PINE(host, port)
                if gdb_port: self.gdb = GDB(host, gdb_port, arch='mips')
            elif emulator == 'ppsspp':
                self.link = PPSSPP(host, port if port != DEFAULT_PORT.get('ppsspp') else None)
            elif emulator == 'dolphin':
                if port: self.gdb = GDB(host, port, big_endian=True, arch='ppc')
                else: self.link = DolphinMemory(getattr(img, 'game_id', ''))
            elif emulator == 'mgba' and not gdb_port:
                # prefer the ROM Explorer script inside mGBA (no slowdown); fall back to mGBA's GDB server
                try: self.link = MGBAScript(host)
                except LinkError as e1:
                    try: self.gdb = GDB(host, port, big_endian=False, arch='arm')
                    except GDBError:
                        raise LiveError('mGBA isn\'t reachable. In mGBA: Tools > Scripting… > File > Load script…, and pick '
                                        'romx\\live\\romx_mgba.lua in your ROM Explorer folder (best: no slowdown, buttons and screenshots work). '
                                        'Or Tools > Start GDB server for breakpoints (slower).')
            elif emulator in ('duckstation', 'mgba', 'melonds', 'gdb'):
                if not ARCH.get(P.KEY): raise LiveError(f'GDB isn\'t available for {P.NAME} games. Use RetroArch.')
                self.gdb = GDB(host, port, big_endian=self.big, arch=ARCH[P.KEY])
            else:
                raise LiveError(f'Unknown emulator "{emulator}". Use retroarch, duckstation, pcsx2, ppsspp, mgba, melonds, dolphin or gdb.')
        except (GDBError, LinkError) as e:
            raise LiveError(str(e))
        if self.gdb:   # GDB servers halt the game when you connect; let it carry on so you can keep playing
            self.gdb.resume()

    # ---- what this link can do ----
    def caps(self):
        c = {'read', 'write', 'snapshot'}
        if self.gdb or isinstance(self.link, PPSSPP): c |= {'pause', 'step', 'registers', 'breakpoints', 'watchpoints'}
        if isinstance(self.link, RetroArch): c |= {'pause', 'frame_advance'}
        if isinstance(self.link, (PINE, RetroArch, PPSSPP)): c |= {'states'}
        if isinstance(self.link, MGBAScript): c |= {'buttons', 'screenshot', 'states', 'watch (every frame)'}
        if isinstance(self.link, PPSSPP): c |= {'buttons', 'screenshot'}
        elif not isinstance(self.link, MGBAScript):
            c |= {'screenshot (window)'}
            if self.keymap: c |= {'buttons (keys)'}
        return sorted(c)

    def describe(self):
        parts = [f'Connected to {self.emu}.']
        try:
            if isinstance(self.link, (PINE, RetroArch)): parts.append(str(self.link.info()))
        except (LinkError, OSError): pass
        parts.append('Can: ' + ', '.join(self.caps()) + '.')
        chk = self.check_game()
        if chk: parts.append(chk)
        return ' '.join(parts)

    def check_game(self):
        """Compare a piece of the game's code in RAM with the ROM Explorer project, to catch the wrong game being open."""
        try:
            from ..states import code_pieces
            pcs = code_pieces(self.img, self.P)[:6]
            if not pcs: return ''
            hit = 0
            for a, w in pcs:
                r = self.P.ra(a)
                if r is None: continue
                if self.read(r, len(w)) == w: hit += 1
            return 'The game in the emulator matches this project.' if hit else 'Warning: the code in the emulator\'s RAM doesn\'t match this project. Is the same game (and version) running?'
        except (LiveError, LinkError, GDBError, OSError, ValueError): return ''

    # ---- addresses ----
    def _bus(self, ra):
        b = self.P.bus(ra)
        return b
    def _with_gdb_halted(self, fn):
        g = self.gdb; was = g.running
        if was: g.interrupt()
        try: return fn()
        finally:
            if was and not self.paused: g.resume()

    def read(self, ra, n):
        try:
            if self.link is not None and not (self.gdb and isinstance(self.link, DolphinMemory)):
                return self.link.read(ra if self.ra_space else self._bus(ra), n)
            return self._with_gdb_halted(lambda: self.gdb.read(self._bus(ra), n))
        except (GDBError, LinkError, OSError) as e: raise LiveError(str(e))
    @property
    def pauses_to_read(self):
        """GDB servers can only read memory while the game is stopped, so every read is a tiny pause."""
        return self.gdb is not None and (self.link is None or isinstance(self.link, DolphinMemory))
    def read_many(self, items):
        """[(ra, size), ...] -> [bytes, ...], with a single pause on GDB links."""
        if isinstance(self.link, MGBAScript):
            try: return self.link.read_many([(self._bus(r), n) for r, n in items])
            except (LinkError, OSError) as e: raise LiveError(str(e))
        if not self.pauses_to_read: return [self.read(r, n) for r, n in items]
        lo = min(r for r, _ in items); hi = max(r + n for r, n in items)
        try:
            if hi - lo <= 512:   # close together: one read covers them all
                blob = self._with_gdb_halted(lambda: self.gdb.read(self._bus(lo), hi - lo))
                return [blob[r - lo:r - lo + n] for r, n in items]
            return self._with_gdb_halted(lambda: [self.gdb.read(self._bus(r), n) for r, n in items])
        except (GDBError, OSError) as e: raise LiveError(str(e))
    should_stop = None   # set by the caller: returns True when the request was cancelled
    def write(self, ra, data):
        try:
            if self.link is not None: return self.link.write(ra if self.ra_space else self._bus(ra), data)
            return self._with_gdb_halted(lambda: self.gdb.write(self._bus(ra), data))
        except (GDBError, LinkError, OSError) as e: raise LiveError(str(e))

    # ---- running ----
    def pause(self):
        if self.gdb:
            if self.gdb.running: self.gdb.interrupt()
        elif isinstance(self.link, PPSSPP):
            self.link._send({'event': 'cpu.stepping'}); self.link.wait_event('cpu.stepping', 3)
        elif isinstance(self.link, RetroArch):
            if not self.link.paused(): self.link.pause_toggle()
        else: raise LiveError(f'{self.emu} can\'t be paused from here.')
        self.paused = True
    def resume(self):
        if self.gdb:
            if not self.gdb.running: self.gdb.resume()
        elif isinstance(self.link, PPSSPP): self.link._send({'event': 'cpu.resume'})
        elif isinstance(self.link, RetroArch):
            if self.link.paused(): self.link.pause_toggle()
        else: raise LiveError(f'{self.emu} can\'t be paused or resumed from here.')
        self.paused = False
    def pc(self):
        if self.gdb: return self._with_gdb_halted(lambda: self.gdb.read_reg('pc'))
        if isinstance(self.link, PPSSPP): return self.link.call('cpu.getReg', name='pc')['uintValue']
        raise LiveError('This link has no registers.')
    def step(self, n=1):
        """Step n instructions (pauses first). Returns the PC afterwards."""
        if self.gdb:
            if self.gdb.running: self.gdb.interrupt()
            self.paused = True
            for _ in range(n): self.gdb.step()
            return self.gdb.read_reg('pc')
        if isinstance(self.link, PPSSPP):
            if not self.paused: self.pause()
            for _ in range(n):
                self.link._send({'event': 'cpu.stepInto'}); self.link.wait_event('cpu.stepping', 3)
            return self.pc()
        if isinstance(self.link, RetroArch):
            if not self.paused: self.pause()
            self.link.frame_advance(n); return None
        raise LiveError(f'{self.emu} can\'t be stepped from here.')
    def registers(self):
        if self.gdb: return self._with_gdb_halted(self.gdb.all_regs)
        if isinstance(self.link, PPSSPP):
            r = self.link.call('cpu.getAllRegs'); out = {}
            for cat in r.get('categories', []):
                if cat.get('name') in ('GPR', 'gpr') or cat.get('id') == 0:
                    for n_, v in zip(cat.get('registerNames', []), cat.get('uintValues', [])): out[n_] = v
            return out
        raise LiveError('This link has no registers.')

    def watch(self, ra, size=1, mode='write', timeout=30):
        """Run until the address is written (or read). Returns a hit dict, or None on timeout.
        With a debugger link it stops on the exact instruction; otherwise it polls RAM about every frame."""
        bus = self._bus(ra)
        use_gdb = bool(self.gdb)
        if use_gdb:
            g = self.gdb
            if g.running: g.interrupt()
            try: g.set_bp({'write': 2, 'read': 3, 'access': 4, 'change': 2}[mode], bus, size)
            except GDBError:   # no watchpoints on this server: fall back to polling
                use_gdb = False
                if not self.paused: g.resume()
        if use_gdb:
            before = g.read(bus, size)
            try:
                deadline = time.time() + timeout
                while True:
                    r = g.cont(max(0.1, deadline - time.time()), self.should_stop)
                    if r is None: return None
                    st = parse_stop(r); pc = g.read_reg('pc'); now = g.read(bus, size)
                    if mode == 'change' and now == before and time.time() < deadline: continue
                    self.paused = True
                    return {'pc': pc, 'old': before, 'new': now, 'stop': st, 'exact': True}
            finally:
                try: g.set_bp({'write': 2, 'read': 3, 'access': 4, 'change': 2}[mode], bus, size, on=False)
                except GDBError: pass
        if isinstance(self.link, PPSSPP):
            L = self.link; before = L.read(bus, size)
            L.call('memory.breakpoint.add', address=bus, size=size, enabled=True, read=mode in ('read', 'access'), write=mode in ('write', 'access'), change=mode == 'change')
            try:
                if self.paused: self.resume()
                ev = L.wait_event('cpu.stepping', timeout)
                if not ev: return None
                self.paused = True
                return {'pc': ev.get('pc'), 'old': before, 'new': L.read(bus, size), 'exact': True}
            finally:
                try: L.call('memory.breakpoint.remove', address=bus, size=size)
                except LinkError: pass
        if isinstance(self.link, MGBAScript):   # checked by mGBA itself every frame
            before = self.read(ra, size)
            try: r = self.link.watch(bus, size, timeout, self.should_stop)
            except LinkError as e: raise LiveError(str(e))
            if not r: return None
            big = 'little'
            return {'pc': None, 'old': r['old'].to_bytes(size, big), 'new': r['new'].to_bytes(size, big), 'after': round(r['frames'] / 60, 2), 'frames': r['frames'], 'exact': False}
        # polling (gently on links that pause the game to read)
        before = self.read(ra, size); t0 = time.time(); gap = 0.1 if self.pauses_to_read else 0.012
        while time.time() - t0 < timeout:
            if self.should_stop and self.should_stop(): return None
            time.sleep(gap)
            now = self.read(ra, size)
            if now != before: return {'pc': None, 'old': before, 'new': now, 'after': round(time.time() - t0, 2), 'exact': False}
        return None

    def run_to(self, bus_pc, timeout=30):
        if self.gdb:
            g = self.gdb
            if g.running: g.interrupt()
            kind = 2 if ARCH.get(self.P.KEY) == 'arm' and bus_pc & 1 else 4
            g.set_bp(0, bus_pc & ~1, kind)
            try:
                r = g.cont(timeout, self.should_stop)
                if r is None: return None
                self.paused = True; return {'pc': g.read_reg('pc')}
            finally:
                try: g.set_bp(0, bus_pc & ~1, kind, on=False)
                except GDBError: pass
        if isinstance(self.link, PPSSPP):
            L = self.link; L.call('cpu.breakpoint.add', address=bus_pc, enabled=True)
            try:
                if self.paused: self.resume()
                ev = L.wait_event('cpu.stepping', timeout)
                if not ev: return None
                self.paused = True; return {'pc': ev.get('pc')}
            finally:
                try: L.call('cpu.breakpoint.remove', address=bus_pc)
                except LinkError: pass
        raise LiveError(f'{self.emu} can\'t stop at a code address from here (needs a debugger link).')

    # ---- states, screenshots, buttons ----
    def save_state(self, slot):
        if isinstance(self.link, PPSSPP): self.link.call('game.state.save', slot=int(slot)); return
        if isinstance(self.link, (PINE, RetroArch, MGBAScript)): self.link.save_state(int(slot)); return
        k = self.keymap.get(f'save{slot}') or self.keymap.get('savestate')
        if k: win.press(self.emu, [k], 2); return
        raise LiveError(f'Saving states in {self.emu} from here isn\'t possible. Add a "savestate = F1" line to Settings > Emulator keys to use its hotkey.')
    def load_state(self, slot):
        if isinstance(self.link, PPSSPP): self.link.call('game.state.load', slot=int(slot)); return
        if isinstance(self.link, (PINE, RetroArch, MGBAScript)): self.link.load_state(int(slot)); return
        k = self.keymap.get(f'load{slot}') or self.keymap.get('loadstate')
        if k: win.press(self.emu, [k], 2); return
        raise LiveError(f'Loading states in {self.emu} from here isn\'t possible. Add a "loadstate = F3" line to Settings > Emulator keys to use its hotkey.')
    def screenshot(self):
        if isinstance(self.link, MGBAScript):
            try: return self.link.screenshot()
            except LinkError as e: raise LiveError(str(e))
        if isinstance(self.link, PPSSPP):
            r = self.link.call('gpu.buffer.screenshot', type='uri', timeout=15)
            uri = r.get('uri', '')
            if ',' in uri: return base64.b64decode(uri.split(',', 1)[1])
        try: return win.screenshot(self.emu)
        except win.WinError_ as e: raise LiveError(str(e))
    def press(self, buttons, frames=6):
        if isinstance(self.link, MGBAScript):
            try: return self.link.press(buttons, frames)
            except LinkError as e: raise LiveError(str(e))
        if isinstance(self.link, PPSSPP):
            names = [PSP_BUTTONS.get(b.lower(), b.lower()) for b in buttons]
            self.link.call('input.buttons.send', buttons={n: True for n in names})
            time.sleep(max(1, frames) / 60.0)
            self.link.call('input.buttons.send', buttons={n: False for n in names}); return
        keys = []
        for b in buttons:
            k = self.keymap.get(b.lower())
            if not k: raise LiveError(f'No key set for "{b}" in {self.emu}. In ROM Explorer go to Settings > Emulator keys and add lines like "{self.emu}: {b} = X" matching the keys bound in {self.emu}.')
            keys.append(k)
        try: win.press(self.emu, keys, frames)
        except win.WinError_ as e: raise LiveError(str(e))

    def snapshot(self):
        """The whole RA memory, read live, for keeping as a save state in the project."""
        from ..states import RA_SIZE
        size = RA_SIZE.get(self.P.KEY)
        if not size: raise LiveError('Snapshots aren\'t set up for this console.')
        regions = []
        if self.P.KEY == 'gba': regions = [(0, 0x8000), (0x8000, 0x40000)]
        elif self.P.KEY == 'ps1': regions = [(0, 0x200000), (0x200000, 0x400)]
        elif self.P.KEY == 'ps2': regions = [(0, 0x2000000), (0x2000000, 0x4000)]
        elif self.P.KEY == 'psp': regions = [(0x800000, 0x1800000)]   # user RAM (kernel RAM isn't readable on most links)
        else: regions = [(0, size)]
        mem = bytearray(size)
        if self.gdb and self.gdb.running: self.gdb.interrupt(); resume = True
        else: resume = False
        try:
            for start, n in regions:
                for o in range(0, n, 0x10000):
                    k = min(0x10000, n - o)
                    try: mem[start + o:start + o + k] = self.read(start + o, k)
                    except LiveError:
                        if start + o == regions[0][0]: raise
        finally:
            if resume and not self.paused: self.gdb.resume()
        return bytes(mem)

    def close(self):
        for x in (self.gdb, self.link):
            if x is not None:
                try: x.close()
                except Exception: pass

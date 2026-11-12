"""Helpers for emulators without their own screenshot or input commands: capture the emulator's window
and press keys in it (using the keys you've bound in that emulator, from Settings > Emulator keys).
Windows uses the Windows API. Linux uses xdotool (X11 or XWayland windows) and ImageMagick's `import` for screenshots."""
import shutil, struct, subprocess, sys, time, zlib

class WinError_(Exception): pass

def png(width, height, rgb):
    """Minimal PNG writer (RGB, 8-bit)."""
    rows = b''.join(b'\x00' + rgb[y * width * 3:(y + 1) * width * 3] for y in range(height))
    def chunk(t, d): return struct.pack('>I', len(d)) + t + d + struct.pack('>I', zlib.crc32(t + d) & 0xFFFFFFFF)
    return b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)) + chunk(b'IDAT', zlib.compress(rows, 6)) + chunk(b'IEND', b'')

def _procs(emulator):
    from ..setup import PROCS
    return PROCS.get(emulator, (emulator.lower() + '.exe', emulator.lower()))

def _u():
    if sys.platform != 'win32': raise WinError_('Window screenshots and key presses only work on Windows and Linux.')
    import ctypes
    return ctypes, ctypes.WinDLL('user32', use_last_error=True), ctypes.WinDLL('gdi32'), ctypes.WinDLL('kernel32')

def find_window(emulator):
    ctypes, u, g, k = _u()
    from ctypes import wintypes as W
    names = _procs(emulator)
    found = []
    def proc_name(pid):
        h = k.OpenProcess(0x1000, False, pid)
        if not h: return ''
        buf = ctypes.create_unicode_buffer(520); n = W.DWORD(520)
        ok = k.QueryFullProcessImageNameW(h, 0, buf, ctypes.byref(n)); k.CloseHandle(h)
        return buf.value.rsplit('\\', 1)[-1].lower() if ok else ''
    CB = ctypes.WINFUNCTYPE(W.BOOL, W.HWND, W.LPARAM)
    def cb(hwnd, _):
        if not u.IsWindowVisible(hwnd): return True
        pid = W.DWORD(); u.GetWindowThreadProcessId(hwnd, ctypes.byref(pid))
        if proc_name(pid.value) in names:
            r = W.RECT(); u.GetClientRect(hwnd, ctypes.byref(r)); area = r.right * r.bottom
            title = ctypes.create_unicode_buffer(256); u.GetWindowTextW(hwnd, title, 256)
            found.append((area, hwnd, title.value))
        return True
    u.EnumWindows(CB(cb), 0)
    if not found: raise WinError_(f'No {emulator} window found. Is it running (and not minimised)?')
    found.sort(reverse=True)   # the biggest window is the game display (not a debugger or log window)
    return found[0][1]

def screenshot(emulator):
    if sys.platform.startswith('linux'): return X11.screenshot(emulator)
    ctypes, u, g, k = _u()
    from ctypes import wintypes as W
    hwnd = find_window(emulator)
    r = W.RECT(); u.GetClientRect(hwnd, ctypes.byref(r)); w, h = r.right, r.bottom
    if w <= 0 or h <= 0: raise WinError_('The emulator window is minimised.')
    hdc = u.GetDC(hwnd); mdc = g.CreateCompatibleDC(hdc); bmp = g.CreateCompatibleBitmap(hdc, w, h); g.SelectObject(mdc, bmp)
    if not u.PrintWindow(hwnd, mdc, 3):   # PW_CLIENTONLY | PW_RENDERFULLCONTENT (works for GPU-drawn windows)
        g.BitBlt(mdc, 0, 0, w, h, hdc, 0, 0, 0x00CC0020)
    class BIH(ctypes.Structure):
        _fields_ = [('biSize', W.DWORD), ('biWidth', W.LONG), ('biHeight', W.LONG), ('biPlanes', W.WORD), ('biBitCount', W.WORD), ('biCompression', W.DWORD),
                    ('biSizeImage', W.DWORD), ('biXPelsPerMeter', W.LONG), ('biYPelsPerMeter', W.LONG), ('biClrUsed', W.DWORD), ('biClrImportant', W.DWORD)]
    bi = BIH(ctypes.sizeof(BIH), w, -h, 1, 32, 0, 0, 0, 0, 0, 0)
    buf = ctypes.create_string_buffer(w * h * 4)
    g.GetDIBits(mdc, bmp, 0, h, buf, ctypes.byref(bi), 0)
    g.DeleteObject(bmp); g.DeleteDC(mdc); u.ReleaseDC(hwnd, hdc)
    raw = buf.raw; rgb = bytearray(w * h * 3); rgb[0::3] = raw[2::4]; rgb[1::3] = raw[1::4]; rgb[2::3] = raw[0::4]
    if w > 960:   # keep images a sensible size
        f = (w + 959) // 960; w2, h2 = w // f, h // f; small = bytearray(w2 * h2 * 3)
        for y in range(h2):
            row = rgb[(y * f) * w * 3:(y * f + 1) * w * 3]
            small[y * w2 * 3:(y + 1) * w2 * 3] = b''.join(row[x * f * 3:x * f * 3 + 3] for x in range(w2))
        rgb, w, h = small, w2, h2
    return png(w, h, bytes(rgb))

VK = {'enter': 0x0D, 'return': 0x0D, 'space': 0x20, 'tab': 0x09, 'backspace': 0x08, 'escape': 0x1B, 'esc': 0x1B, 'shift': 0x10, 'lshift': 0xA0, 'rshift': 0xA1,
      'ctrl': 0x11, 'control': 0x11, 'alt': 0x12, 'up': 0x26, 'down': 0x28, 'left': 0x25, 'right': 0x27, 'home': 0x24, 'end': 0x23, 'pageup': 0x21,
      'pagedown': 0x22, 'insert': 0x2D, 'delete': 0x2E, ',': 0xBC, '.': 0xBE, '/': 0xBF, ';': 0xBA, "'": 0xDE, '[': 0xDB, ']': 0xDD, '-': 0xBD, '=': 0xBB, '\\': 0xDC}
VK.update({f'f{i}': 0x6F + i for i in range(1, 13)}); VK.update({f'numpad{i}': 0x60 + i for i in range(10)}); VK.update({f'kp{i}': 0x60 + i for i in range(10)})
EXTENDED = {0x25, 0x26, 0x27, 0x28, 0x24, 0x23, 0x21, 0x22, 0x2D, 0x2E}

def vk_of(name):
    n = name.strip().lower()
    if n in VK: return VK[n]
    if len(n) == 1 and n.isalnum(): return ord(n.upper())
    raise WinError_(f'Unknown key "{name}".')

def press(emulator, keys, frames=6):
    """Hold the given keyboard keys in the emulator's window for about `frames` frames (60 per second)."""
    if sys.platform.startswith('linux'): return X11.press(emulator, keys, frames)
    ctypes, u, g, k = _u()
    from ctypes import wintypes as W
    hwnd = find_window(emulator)
    # bring it to the front (Windows only lets the foreground app do this, so nudge with Alt first)
    u.keybd_event(0x12, 0, 0, 0); u.keybd_event(0x12, 0, 2, 0)
    u.ShowWindow(hwnd, 9); u.SetForegroundWindow(hwnd); time.sleep(0.15)
    class KI(ctypes.Structure): _fields_ = [('wVk', W.WORD), ('wScan', W.WORD), ('dwFlags', W.DWORD), ('time', W.DWORD), ('dwExtraInfo', ctypes.c_size_t)]
    class MI(ctypes.Structure): _fields_ = [('dx', W.LONG), ('dy', W.LONG), ('mouseData', W.DWORD), ('dwFlags', W.DWORD), ('time', W.DWORD), ('dwExtraInfo', ctypes.c_size_t)]
    class U_(ctypes.Union): _fields_ = [('ki', KI), ('mi', MI)]
    class INP(ctypes.Structure): _fields_ = [('type', W.DWORD), ('u', U_)]
    def send(vk, up):
        sc = u.MapVirtualKeyW(vk, 0); fl = 0x0008 | (0x0002 if up else 0) | (0x0001 if vk in EXTENDED else 0)
        i = INP(1, U_(ki=KI(0, sc, fl, 0, 0))); u.SendInput(1, ctypes.byref(i), ctypes.sizeof(INP))
    vks = [vk_of(x) for x in keys]
    for v in vks: send(v, False)
    time.sleep(max(1, frames) / 60.0)
    for v in reversed(vks): send(v, True)
    time.sleep(0.05)

# ---------------- Linux ----------------
# key names as X knows them
XKEY = {'enter': 'Return', 'return': 'Return', 'space': 'space', 'tab': 'Tab', 'backspace': 'BackSpace', 'escape': 'Escape', 'esc': 'Escape',
        'shift': 'Shift_L', 'lshift': 'Shift_L', 'rshift': 'Shift_R', 'ctrl': 'Control_L', 'control': 'Control_L', 'alt': 'Alt_L',
        'up': 'Up', 'down': 'Down', 'left': 'Left', 'right': 'Right', 'home': 'Home', 'end': 'End', 'pageup': 'Prior', 'pagedown': 'Next',
        'insert': 'Insert', 'delete': 'Delete', ',': 'comma', '.': 'period', '/': 'slash', ';': 'semicolon', "'": 'apostrophe',
        '[': 'bracketleft', ']': 'bracketright', '-': 'minus', '=': 'equal', '\\': 'backslash'}
XKEY.update({f'f{i}': f'F{i}' for i in range(1, 13)}); XKEY.update({f'numpad{i}': f'KP_{i}' for i in range(10)}); XKEY.update({f'kp{i}': f'KP_{i}' for i in range(10)})

class X11:
    @staticmethod
    def _run(args, binary=False):
        try: r = subprocess.run(args, capture_output=True, timeout=10)
        except FileNotFoundError: raise WinError_(f'{args[0]} isn\'t installed. Install it with your package manager (e.g. sudo apt install {args[0] if args[0] != "import" else "imagemagick"}).')
        except subprocess.TimeoutExpired: raise WinError_(f'{args[0]} didn\'t answer.')
        if r.returncode != 0: raise WinError_(f'{args[0]} failed: {r.stderr.decode("utf-8", "replace").strip() or r.returncode}')
        return r.stdout if binary else r.stdout.decode('utf-8', 'replace')

    @staticmethod
    def find_window(emulator):
        from ..procs import find_pids
        if not shutil.which('xdotool'): raise WinError_('Window screenshots and key presses on Linux need xdotool (sudo apt install xdotool).')
        pids = find_pids(_procs(emulator))
        if not pids: raise WinError_(f'{emulator} isn\'t running.')
        ids = []
        for pid in pids:
            try: ids += X11._run(['xdotool', 'search', '--onlyvisible', '--pid', str(pid)]).split()
            except WinError_: pass
        if not ids:   # windows that don't say which program they belong to: go by their class name instead
            try: ids = X11._run(['xdotool', 'search', '--onlyvisible', '--class', emulator]).split()
            except WinError_: pass
        found = []
        for w in ids:
            try: g = X11._run(['xdotool', 'getwindowgeometry', '--shell', w])
            except WinError_: continue
            d = dict(l.split('=', 1) for l in g.splitlines() if '=' in l)
            found.append((int(d.get('WIDTH', 0)) * int(d.get('HEIGHT', 0)), w))
        if not found: raise WinError_(f'No {emulator} window found. Is it running (and not minimised)? On Wayland only windows running through XWayland can be reached.')
        found.sort(reverse=True)   # the biggest window is the game display
        return found[0][1]

    @staticmethod
    def screenshot(emulator):
        w = X11.find_window(emulator)
        if shutil.which('import'): return X11._run(['import', '-silent', '-window', w, '-resize', '960x>', 'png:-'], binary=True)
        raise WinError_('Window screenshots on Linux need ImageMagick (sudo apt install imagemagick).')

    @staticmethod
    def press(emulator, keys, frames=6):
        names = []
        for x in keys:
            n = x.strip().lower()
            if n in XKEY: names.append(XKEY[n])
            elif len(n) == 1 and n.isalnum(): names.append(n)
            else: raise WinError_(f'Unknown key "{x}".')
        w = X11.find_window(emulator)
        try: X11._run(['xdotool', 'windowactivate', '--sync', w])
        except WinError_: X11._run(['xdotool', 'windowfocus', '--sync', w])   # no window manager that can raise windows
        time.sleep(0.1)
        X11._run(['xdotool', 'keydown', *names])
        time.sleep(max(1, frames) / 60.0)
        X11._run(['xdotool', 'keyup', *reversed(names)]); time.sleep(0.05)

def parse_keymap(text, emulator):
    """Lines like 'Cross = X' or 'pcsx2: Cross = X, Circle = C'. Emulator-specific lines win."""
    general, own = {}, {}
    for line in (text or '').splitlines():
        line = line.strip()
        if not line or line.startswith('#'): continue
        target = general
        if ':' in line.split('=')[0]:
            emu, line = line.split(':', 1)
            if emu.strip().lower() != emulator: continue
            target = own
        for part in line.split(','):
            if '=' in part:
                b, key = part.split('=', 1); target[b.strip().lower()] = key.strip()
    general.update(own); return general

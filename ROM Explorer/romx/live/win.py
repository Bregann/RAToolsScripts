"""Windows helpers for emulators without their own screenshot or input commands: capture the emulator's window
and press keys in it (using the keys you've bound in that emulator, from Settings > Emulator keys)."""
import struct, sys, time, zlib

class WinError_(Exception): pass

def png(width, height, rgb):
    """Minimal PNG writer (RGB, 8-bit)."""
    rows = b''.join(b'\x00' + rgb[y * width * 3:(y + 1) * width * 3] for y in range(height))
    def chunk(t, d): return struct.pack('>I', len(d)) + t + d + struct.pack('>I', zlib.crc32(t + d) & 0xFFFFFFFF)
    return b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)) + chunk(b'IDAT', zlib.compress(rows, 6)) + chunk(b'IEND', b'')

PROCS = {'pcsx2': ('pcsx2-qt.exe', 'pcsx2.exe', 'pcsx2-qtx64.exe', 'pcsx2-qtx64-avx2.exe'), 'duckstation': ('duckstation-qt-x64-releaseltcg.exe', 'duckstation-qt.exe', 'duckstation.exe'),
         'dolphin': ('dolphin.exe',), 'ppsspp': ('ppssppwindows64.exe', 'ppssppwindows.exe'), 'retroarch': ('retroarch.exe',),
         'mgba': ('mgba.exe',), 'melonds': ('melonds.exe',)}

def _u():
    if sys.platform != 'win32': raise WinError_('Window screenshots and key presses only work on Windows.')
    import ctypes
    return ctypes, ctypes.WinDLL('user32', use_last_error=True), ctypes.WinDLL('gdi32'), ctypes.WinDLL('kernel32')

def find_window(emulator):
    ctypes, u, g, k = _u()
    from ctypes import wintypes as W
    names = PROCS.get(emulator, (emulator.lower() + '.exe',))
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

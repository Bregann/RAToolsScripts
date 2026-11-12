"""Finding running programs by name, on Windows (process snapshot) and Linux (/proc). Names are compared lower-case;
on Linux a program matches by its executable name, the name it was started as, or its process name."""
import os, sys

def _windows():
    import ctypes
    from ctypes import wintypes as W
    class PE(ctypes.Structure):
        _fields_ = [('dwSize', W.DWORD), ('cntUsage', W.DWORD), ('th32ProcessID', W.DWORD), ('th32DefaultHeapID', ctypes.c_void_p),
                    ('th32ModuleID', W.DWORD), ('cntThreads', W.DWORD), ('th32ParentProcessID', W.DWORD), ('pcPriClassBase', ctypes.c_long),
                    ('dwFlags', W.DWORD), ('szExeFile', ctypes.c_wchar * 260)]
    k = ctypes.WinDLL('kernel32'); snap = k.CreateToolhelp32Snapshot(2, 0); pe = PE(); pe.dwSize = ctypes.sizeof(PE)
    ok = k.Process32FirstW(snap, ctypes.byref(pe))
    try:
        while ok:
            yield pe.th32ProcessID, {pe.szExeFile.lower()}
            ok = k.Process32NextW(snap, ctypes.byref(pe))
    finally: k.CloseHandle(snap)

def _proc():
    for d in os.listdir('/proc'):
        if not d.isdigit(): continue
        names = set()
        try: names.add(os.path.basename(os.readlink(f'/proc/{d}/exe')).removesuffix(' (deleted)').lower())
        except OSError: pass
        try:
            with open(f'/proc/{d}/cmdline', 'rb') as f: argv0 = f.read().split(b'\0', 1)[0].decode('utf-8', 'replace')
            if argv0: names.add(os.path.basename(argv0).lower())
        except OSError: pass
        try:
            with open(f'/proc/{d}/comm') as f: names.add(f.read().strip().lower())
        except OSError: pass
        yield int(d), names

def processes():
    """(pid, {names}) for every running program, or nothing where that can't be read."""
    if sys.platform == 'win32': return _windows()
    if os.path.isdir('/proc'): return _proc()
    return iter(())

def find_pids(names):
    names = {n.lower() for n in names}
    # Linux shortens process names to 15 characters
    short = {n[:15] for n in names}
    try: return [pid for pid, have in processes() if have & names or have & short]
    except Exception: return []

def find_pid(names):
    p = find_pids(names); return p[0] if p else None

def can_tell():
    """Whether find_pid can see running programs on this system."""
    return sys.platform == 'win32' or os.path.isdir('/proc')

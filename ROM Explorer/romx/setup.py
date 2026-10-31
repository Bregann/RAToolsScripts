"""Setup checker: what's installed, which emulators are on this PC and whether their links are on, whether Claude
can start ROM Explorer. Also "fix it for me" actions where that's safe (installing packages, filling in folders,
turning an emulator's link on in its settings file while the emulator is closed, with a backup)."""
import importlib.util, json, os, re, socket, subprocess, sys, threading, time
from pathlib import Path
from . import settings as S

ROOT = Path(__file__).resolve().parent.parent
IS_WIN = sys.platform == 'win32'

# ---------------- packages ----------------
PACKAGES = [('capstone', 'capstone', True, 'Reads the game code (disassembler)'), ('numpy', 'numpy', True, 'Save state comparing'),
            ('zstandard', 'zstandard', True, 'Dolphin .rvz discs and some save states'), ('lz4', 'lz4', False, 'PSP .zso discs only')]
def packages():
    out = []
    for mod, pip, req, why in PACKAGES:
        ok = importlib.util.find_spec(mod) is not None; ver = ''
        if ok:
            try: ver = getattr(__import__(mod), '__version__', '')
            except Exception: pass
        out.append({'name': pip, 'ok': ok, 'required': req, 'why': why, 'version': str(ver)})
    return out

INSTALL = {'state': 'idle', 'log': ''}
def install_packages(optional=False):
    if INSTALL['state'] == 'running': return INSTALL
    names = [p['name'] for p in packages() if not p['ok'] and (p['required'] or optional)]
    if not names: INSTALL.update(state='done', log='Everything is already installed.'); return INSTALL
    def run():
        INSTALL.update(state='running', log=f'Installing {", ".join(names)}…\n')
        try:
            p = subprocess.run([sys.executable, '-m', 'pip', 'install', '--disable-pip-version-check', *names], capture_output=True, text=True, timeout=600)
            INSTALL['log'] += (p.stdout or '')[-3000:] + (p.stderr or '')[-2000:]
            INSTALL['state'] = 'done' if p.returncode == 0 else 'error'
            if p.returncode == 0: INSTALL['log'] += '\nDone. Restart ROM Explorer to use them.'
        except Exception as e: INSTALL.update(state='error', log=INSTALL['log'] + str(e))
    threading.Thread(target=run, daemon=True).start(); return INSTALL

# ---------------- emulators ----------------
def _env(name, default=''): return os.environ.get(name, default)
HOME = Path.home(); DOCS = HOME / 'Documents'
APPDATA = Path(_env('APPDATA', str(HOME / 'AppData' / 'Roaming'))); LOCAL = Path(_env('LOCALAPPDATA', str(HOME / 'AppData' / 'Local')))
PF = [Path(_env('ProgramFiles', r'C:\Program Files')), Path(_env('ProgramFiles(x86)', r'C:\Program Files (x86)'))]
STEAM = [p / 'Steam' / 'steamapps' / 'common' for p in PF]

EMUS = {
    'retroarch': {'name': 'RetroArch', 'consoles': 'GB/GBC, GBA, DS, PS1, PSP and more (with cores)', 'procs': ('retroarch.exe',),
                  'dirs': [APPDATA / 'RetroArch', Path(r'C:\RetroArch-Win64'), Path(r'C:\RetroArch'), *[p / 'RetroArch' for p in PF], *[s / 'RetroArch' for s in STEAM], HOME / '.config' / 'retroarch'],
                  'config': 'retroarch.cfg', 'states': 'states', 'port': 55355,
                  'how': 'Settings > Network > Network Commands: On (port 55355). Also have RetroAchievements turned on, so addresses match.'},
    'ralibretro': {'name': 'RALibretro', 'consoles': 'RetroAchievements\' dev emulator (code notes live here)', 'procs': ('ralibretro.exe',),
                   'dirs': [Path(r'C:\RALibretro'), HOME / 'RALibretro', DOCS / 'RALibretro', HOME / 'Desktop' / 'RALibretro', *[p / 'RALibretro' for p in PF]],
                   'config': None, 'states': 'States', 'port': None, 'how': 'No link needed. ROM Explorer reads your code notes from its RACache folder.'},
    'duckstation': {'name': 'DuckStation', 'consoles': 'PS1', 'procs': ('duckstation-qt-x64-releaseltcg.exe', 'duckstation-qt.exe', 'duckstation.exe'),
                    'dirs': [DOCS / 'DuckStation', LOCAL / 'DuckStation', HOME / '.local' / 'share' / 'duckstation'],
                    'config': 'settings.ini', 'states': 'savestates', 'port': 2345,
                    'how': 'Settings > Advanced > Enable GDB Server (port 2345). If you can\'t see it, turn on the advanced/debug options there first.'},
    'pcsx2': {'name': 'PCSX2', 'consoles': 'PS2', 'procs': ('pcsx2-qt.exe', 'pcsx2.exe', 'pcsx2-qtx64.exe', 'pcsx2-qtx64-avx2.exe'),
              'dirs': [DOCS / 'PCSX2', APPDATA / 'PCSX2', HOME / '.config' / 'PCSX2'],
              'config': 'inis/PCSX2.ini', 'states': 'sstates', 'port': 28011,
              'how': 'Settings > Advanced > Enable PINE (slot 28011).'},
    'ppsspp': {'name': 'PPSSPP', 'consoles': 'PSP', 'procs': ('ppssppwindows64.exe', 'ppssppwindows.exe'),
               'dirs': [DOCS / 'PPSSPP', *[p / 'PPSSPP' / 'memstick' for p in PF], HOME / '.config' / 'ppsspp'],
               'config': 'PSP/SYSTEM/ppsspp.ini', 'states': 'PSP/PPSSPP_STATE', 'port': None,
               'how': 'Settings > Tools > Developer tools > Allow remote debugger. ROM Explorer finds the port by itself.'},
    'dolphin': {'name': 'Dolphin', 'consoles': 'GameCube / Wii', 'procs': ('dolphin.exe',),
                'dirs': [DOCS / 'Dolphin Emulator', APPDATA / 'Dolphin Emulator', HOME / '.local' / 'share' / 'dolphin-emu'],
                'config': 'Config/Dolphin.ini', 'states': None, 'port': None,
                'how': 'Nothing to turn on: ROM Explorer reads the game\'s RAM straight from Dolphin while it runs (Windows). Dolphin\'s own save states can\'t be read; use Claude\'s live snapshot instead.'},
    'mgba': {'name': 'mGBA', 'consoles': 'GBA', 'procs': ('mgba.exe',), 'dirs': [APPDATA / 'mGBA', LOCAL / 'mGBA', HOME / '.config' / 'mgba'],
             'config': None, 'states': None, 'port': 61234, 'how': 'Each time: Tools > Scripting… > File > Load script… and pick romx\\live\\romx_mgba.lua in your ROM Explorer folder (no slowdown; buttons and screenshots work). Only for finding the exact instruction that writes an address: Tools > Start GDB server (slows the game while it\'s on).'},
    'melonds': {'name': 'melonDS', 'consoles': 'DS', 'procs': ('melonds.exe',), 'dirs': [APPDATA / 'melonDS', LOCAL / 'melonDS', HOME / '.config' / 'melonDS'],
                'config': None, 'states': None, 'port': 3333, 'how': 'Config > Emu settings > DevTools: enable the GDB stub (ARM9 port 3333).'},
}

# Emulators kept in their own folder (portable installs, RetroAchievements dev builds): how to recognise them
# from the program file, and where their settings and save states sit inside that folder.
PORTABLE = {
    'retroarch': {'exe': ('retroarch.exe',), 'config': 'retroarch.cfg', 'states': 'states'},
    'ralibretro': {'exe': ('ralibretro.exe',), 'config': None, 'states': 'Saves'},
    'duckstation': {'exe': ('duckstation-qt-x64-releaseltcg.exe', 'duckstation-qt.exe', 'duckstation.exe'), 'config': 'settings.ini', 'states': 'savestates'},
    'pcsx2': {'exe': ('pcsx2-qt.exe', 'pcsx2.exe', 'pcsx2-qtx64.exe', 'pcsx2-qtx64-avx2.exe'), 'config': 'inis/PCSX2.ini', 'states': 'sstates'},
    'ppsspp': {'exe': ('ppssppwindows64.exe', 'ppssppwindows.exe'), 'config': 'memstick/PSP/SYSTEM/ppsspp.ini', 'states': 'memstick/PSP/PPSSPP_STATE'},
    'dolphin': {'exe': ('dolphin.exe',), 'config': 'User/Config/Dolphin.ini', 'states': None},
    'mgba': {'exe': ('mgba.exe',), 'config': None, 'states': None},
    'melonds': {'exe': ('melonds.exe',), 'config': None, 'states': None},
}
EXE_TO_EMU = {x: k for k, v in PORTABLE.items() for x in v['exe']}
JUNK_DIRS = {'bios', 'system', 'sys', 'cores', 'assets', 'qtplugins', 'languages', 'resources', 'shaders', 'textures', 'overlay', 'plugins', '__pycache__', '.git', 'racache'}

def scan_folder(root, max_depth=5, limit=60000):
    """Look through one folder (like an "RA Dev" folder) for emulators, Ghidra, RetroAchievements code notes and games."""
    from .platforms import EXTS
    root = Path(root)
    if not root.is_dir(): raise ValueError(f'No folder at {root}')
    emus, tools, notes, game_files = [], {}, [], []
    seen = 0; skip = set()
    def walk(d, depth):
        nonlocal seen
        try: entries = list(os.scandir(d))
        except OSError: return
        names = {e.name.lower(): e for e in entries}
        here_emu = next((EXE_TO_EMU[n] for n in names if n in EXE_TO_EMU), None)
        if here_emu:
            emus.append({'key': here_emu, 'dir': str(d)}); skip.add(str(d))
            if 'racache' in names and Path(d, 'RACache', 'Data').is_dir(): notes.append(str(d))
            # don't walk through the emulator's own files (caches, shaders, its user folder); only folders that hold games
            for e in entries:
                if e.is_dir(follow_symlinks=False) and e.name.lower() in ('games', 'roms', 'isos', 'iso', 'roms_ps1', 'content') and depth < max_depth: walk(e.path, depth + 1)
            return
        if 'racache' in names and Path(d, 'RACache', 'Data').is_dir(): notes.append(str(d))
        if 'support' in names and (Path(d, 'support', 'analyzeHeadless.bat').exists() or Path(d, 'support', 'analyzeHeadless').exists()):
            tools['ghidra'] = str(d); return
        for e in entries:
            seen += 1
            if seen > limit: return
            if e.is_dir(follow_symlinks=False):
                if depth < max_depth and e.name.lower() not in JUNK_DIRS and not e.name.startswith('.'): walk(e.path, depth + 1)
            elif not here_emu and Path(e.name).suffix.lower() in EXTS and d.lower() not in JUNK_DIRS:
                game_files.append(e.path)
    walk(str(root), 0)
    games = [g for g in game_files if looks_like_game(g)]
    folders = []
    for f in sorted({str(Path(g).parent) for g in games}, key=len):   # a folder already covers the folders inside it
        if not any(f == k or f.startswith(k.rstrip('\\/') + os.sep) for k in folders): folders.append(f)
    return {'root': str(root), 'emulators': emus, 'ghidra': tools.get('ghidra', ''), 'notes': notes, 'games': games, 'game_folders': folders}

def best_install(key, dirs):
    """Several copies of one emulator: prefer a portable one, then the one whose settings changed most recently."""
    def score(d):
        d = Path(d); cfg = PORTABLE[key]['config']; t = 0
        for f in ([d / cfg] if cfg else []) + [d / x for x in PORTABLE[key]['exe']]:
            try: t = max(t, f.stat().st_mtime)
            except OSError: pass
        return ((d / 'portable.txt').exists() or (d / 'portable.ini').exists(), t)
    return max(dirs, key=score)

def looks_like_game(path):
    p = Path(path); suf = p.suffix.lower()
    if suf in ('.exe', '.elf', '.prx'):   # only console programs: a PS1 boot program or a PS2/PSP ELF, not Windows tools
        try:
            with open(p, 'rb') as fh: head = fh.read(8)
        except OSError: return False
        if suf == '.exe' and head != b'PS-X EXE': return False
        if suf in ('.elf', '.prx') and head[:4] != b'\x7fELF': return False
    if any(part.lower() in JUNK_DIRS for part in p.parts[:-1][-3:]): return False
    try: size = p.stat().st_size
    except OSError: return False
    if suf == '.bin':   # PS1 discs come with a .cue (listed instead); lone .bin files are usually BIOS or firmware
        return size >= 32 * 1024 * 1024 and not p.with_suffix('.cue').exists()
    if suf == '.elf': return size >= 256 * 1024
    if suf in ('.iso', '.cso', '.zso', '.rvz', '.wia', '.gcm'): return size >= 16 * 1024 * 1024
    return size >= 16 * 1024

def read_cfg(path):
    """Read an INI (section/key = value) or RetroArch-style (key = "value") file into {'section.key': value}."""
    out = {}; sec = ''
    try: text = Path(path).read_text(encoding='utf-8-sig', errors='replace')
    except OSError: return None
    for line in text.splitlines():
        line = line.strip()
        if not line or line[0] in ';#': continue
        if line.startswith('[') and line.endswith(']'): sec = line[1:-1]; continue
        if '=' in line:
            k, v = line.split('=', 1); out[(sec + '.' if sec else '') + k.strip()] = v.strip().strip('"')
    return out

def write_cfg(path, changes):
    """Set keys in an INI or RetroArch cfg, keeping everything else. changes: {'section.key' or 'key': value}. Keeps a backup."""
    p = Path(path); raw = p.read_bytes() if p.exists() else b''
    (p.parent / (p.name + '.romx-backup')).write_bytes(raw)
    bom = raw.startswith(b'\xef\xbb\xbf'); nl = '\r\n' if b'\r\n' in raw else '\n'
    text = raw.decode('utf-8-sig', errors='replace')
    lines = text.splitlines(); quoted = p.suffix == '.cfg'
    for full, val in changes.items():
        sec, key = full.rsplit('.', 1) if '.' in full else ('', full)
        v = f'"{val}"' if quoted else val
        cur = ''; done = False; sec_end = None
        for i, line in enumerate(lines):
            s_ = line.strip()
            if s_.startswith('[') and s_.endswith(']'):
                if cur == sec and sec_end is None and sec: sec_end = i
                cur = s_[1:-1]; continue
            if cur == sec and re.match(rf'\s*{re.escape(key)}\s*=', line):
                lines[i] = f'{key} = {v}'; done = True; break
        if not done:
            if not sec: lines.append(f'{key} = {v}')
            elif any(l.strip() == f'[{sec}]' for l in lines):
                idx = sec_end if sec_end is not None else len(lines)
                while idx > 0 and not lines[idx - 1].strip(): idx -= 1   # before the blank line that ends the section
                lines.insert(idx, f'{key} = {v}')
            else: lines += ['', f'[{sec}]', f'{key} = {v}']
    p.write_bytes(('\ufeff' if bom else '').encode('utf-8') + (nl.join(lines) + nl).encode('utf-8'))

def running(procs):
    if not IS_WIN: return False
    try:
        out = subprocess.run(['tasklist', '/fo', 'csv', '/nh'], capture_output=True, text=True, timeout=10).stdout.lower()
        return any(f'"{p}"' in out for p in procs)
    except Exception: return False

def listening(port):
    """True/False from the system's list of listening ports, or None if that can't be read."""
    try:
        if IS_WIN: out = subprocess.run(['netstat', '-ano', '-p', 'tcp'], capture_output=True, text=True, timeout=10).stdout
        else: out = subprocess.run(['ss', '-ltn'], capture_output=True, text=True, timeout=10).stdout
    except Exception: return None
    return any(re.search(rf'[:.]{port}\s', l) and ('LISTEN' in l.upper()) for l in out.splitlines())

def find_dir(e):
    for d in e['dirs']:
        if not d.is_dir(): continue
        if e['config'] and (d / e['config']).exists(): return d
        if not e['config'] and any(d.iterdir()): return d
    return None

def link_setting(key, cfg):
    """Is the emulator's link turned on in its settings file? True / False / None (can't tell)."""
    if cfg is None: return None
    t = lambda v: str(v).strip().lower() in ('true', '1', 'yes', 'on')
    if key == 'retroarch': return t(cfg.get('network_cmd_enable', 'false'))
    if key == 'duckstation': return t(cfg.get('Debug.EnableGDBServer', 'false'))
    if key == 'pcsx2': return t(cfg.get('EmuCore.EnablePINE', 'false'))
    if key == 'ppsspp':
        for k, v in cfg.items():
            if k.endswith('RemoteDebuggerOnStartup') or k.endswith('EnableRemoteDebugger'): return t(v)
        return None
    return None

FIXES = {'retroarch': {'network_cmd_enable': 'true', 'network_cmd_port': '55355'},
         'duckstation': {'Debug.EnableGDBServer': 'true', 'Debug.GDBServerPort': '2345'},
         'pcsx2': {'EmuCore.EnablePINE': 'true', 'EmuCore.PINESlot': '28011'},
         'ppsspp': {'General.RemoteDebuggerOnStartup': 'True'}}

def game_dirs_from(key, d, cfg):
    """Game folders the emulator already knows about."""
    out = []
    if not cfg: return out
    for k, v in cfg.items():
        kl = k.lower()
        if (key == 'retroarch' and kl in ('rgui_browser_directory', 'content_directory')) or \
           (key in ('duckstation', 'pcsx2') and kl.startswith('gamelist.') and ('paths' in kl)) or \
           (key == 'dolphin' and re.fullmatch(r'general\.isopath\d+', kl)) or \
           (key == 'ppsspp' and kl in ('general.currentdirectory',)):
            for part in re.split(r'[;|]', v):
                part = part.strip()
                if part and part.lower() not in ('default', '') and Path(part).is_dir(): out.append(part)
    return out

def emulators(test=False):
    s = S.load(); out = []
    known = s.get('emu_dirs') or {}
    for key, e in EMUS.items():
        d = None; cfg_rel = e['config']; states_rel = e['states']
        prog = None
        if known.get(key) and Path(known[key]).is_dir():
            d = prog = Path(known[key]); cfg_rel = PORTABLE[key]['config']; states_rel = PORTABLE[key]['states']
            if cfg_rel and not (d / cfg_rel).exists():   # not a portable install: its settings are in the usual place
                home = find_dir(e)
                if home: d, cfg_rel, states_rel = home, e['config'], e['states']
        else: d = find_dir(e)
        cfgp = (d / cfg_rel) if d and cfg_rel else None
        cfg = read_cfg(cfgp) if cfgp else None
        item = {'program_dir': str(prog) if prog else '', 'key': key, 'name': e['name'], 'consoles': e['consoles'], 'how': e['how'], 'found': bool(d), 'dir': str(d) if d else '',
                'config': str(cfgp) if cfgp else '', 'link_on': link_setting(key, cfg), 'can_fix': key in FIXES and cfgp is not None,
                'running': running(e['procs']), 'states_dir': '', 'notes_dir': '', 'game_dirs': game_dirs_from(key, d, cfg) if d else []}
        if d and states_rel and (d / states_rel).is_dir(): item['states_dir'] = str(d / states_rel)
        if d and (d / 'RACache' / 'Data').is_dir(): item['notes_dir'] = str(d)
        if cfgp is not None and not cfgp.exists(): item['config'] = ''; item['can_fix'] = False
        if key == 'retroarch' and cfg:
            sd = cfg.get('savestate_directory', '')
            if sd.startswith(':'): sd = str(d / sd[1:].lstrip('\\/'))   # ':\states' means inside RetroArch's folder
            if sd and sd != 'default' and Path(sd).is_dir(): item['states_dir'] = sd
            item['cheevos_on'] = cfg.get('cheevos_enable', 'false').lower() == 'true'
        item['states_added'] = bool(item['states_dir']) and item['states_dir'] in s.get('states_dirs', [])
        item['notes_added'] = bool(item['notes_dir']) and item['notes_dir'] in s.get('emulator_dirs', [])
        if test: item['test'] = probe(key)
        out.append(item)
    return out

def probe(key, timeout=1.5):
    """Is the emulator's link answering right now? Never sends anything that pauses or changes the game."""
    e = EMUS[key]
    if IS_WIN and not running(e['procs']): return {'ok': None, 'msg': 'Not open right now. Start a game in it, then test again.'}
    try:
        if key == 'retroarch':
            u = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); u.settimeout(timeout); u.sendto(b'GET_STATUS', ('127.0.0.1', 55355))
            try: r = u.recv(4096).decode('latin1', 'replace').strip()
            except socket.timeout: return {'ok': False, 'msg': 'No answer on port 55355. Is RetroArch open with Network Commands on?'}
            finally: u.close()
            return {'ok': True, 'msg': 'Answering. ' + ('A game is running.' if 'PLAYING' in r or 'PAUSED' in r else 'No game loaded yet.')}
        if key == 'ppsspp':
            from .live.links import PPSSPP
            try: L = PPSSPP(); L.close(); return {'ok': True, 'msg': f'Answering on port {L.port}.'}
            except Exception as ex: return {'ok': False, 'msg': str(ex)}
        if key == 'dolphin':
            if not IS_WIN: return {'ok': None, 'msg': 'Only works on Windows.'}
            if not running(e['procs']): return {'ok': False, 'msg': 'Dolphin isn\'t running.'}
            from .live.links import DolphinMemory
            try: DolphinMemory(); return {'ok': True, 'msg': 'Found the running game\'s RAM.'}
            except Exception as ex: return {'ok': False, 'msg': str(ex)}
        if key == 'pcsx2':
            from .live.links import PINE
            try:
                L = PINE(port=28011); i = L.info(); L.close()
                return {'ok': True, 'msg': 'Answering.' + (f' Running: {i["title"]}.' if i.get('title') else ' No game running yet.')}
            except Exception as ex: return {'ok': False, 'msg': 'PCSX2\'s PINE link isn\'t answering. Turn on Settings > Advanced > Enable PINE, and start a game.'}
        if e['port']:
            # don't connect: a GDB connection pauses some emulators. Just look at which ports are open.
            l = listening(e['port'])
            if l is None:
                c = socket.create_connection(('127.0.0.1', e['port']), timeout=timeout); c.close(); l = True
            if l: return {'ok': True, 'msg': f'Its GDB server is listening on port {e["port"]}.'}
            raise OSError()
        return {'ok': None, 'msg': 'Nothing to test.'}
    except OSError:
        return {'ok': False, 'msg': f'Nothing on port {e["port"]}. ' + ('Start a game with the GDB server on.' if key != 'mgba' else 'In mGBA: Tools > Start GDB server… > Start.')}

def fix_emulator(key):
    e = EMUS[key]; d = find_dir(e)
    if key not in FIXES or not d: raise ValueError(f'Turn it on in {e["name"]} itself: {e["how"]}')
    if running(e['procs']): raise ValueError(f'Close {e["name"]} first (it would overwrite the change when it quits), then press this again.')
    write_cfg(d / e['config'], FIXES[key])
    if key == 'retroarch':
        cfg = read_cfg(d / e['config']) or {}
        if cfg.get('cheevos_enable', 'false').lower() != 'true': pass   # leave achievements settings to the user
    return emulators()

def scan(folder=''):
    """Scan the usual places, plus a folder you choose (remembered for next time). Returns what would be added."""
    s = S.load(); found = None
    if folder:
        found = scan_folder(folder)
        dirs = list(dict.fromkeys([folder] + s.get('scan_dirs', [])))[:6]
        emu = dict(s.get('emu_dirs') or {})
        for k in {e['key'] for e in found['emulators']}:
            if k in emu and Path(emu[k]).is_dir(): continue
            emu[k] = best_install(k, [e['dir'] for e in found['emulators'] if e['key'] == k])
        S.save({'scan_dirs': dirs, 'emu_dirs': emu})
    elif s.get('scan_dirs'):
        found = scan_folder(s['scan_dirs'][0]) if Path(s['scan_dirs'][0]).is_dir() else None
    LAST['found'] = found; LAST['t'] = time.time()
    return {'folder': found, 'emulators': emulators(), 'plan': plan(found)}
LAST = {}

def plan(found):
    s = S.load(); add = {'games_dirs': [], 'states_dirs': [], 'emulator_dirs': [], 'ghidra_dir': ''}
    for it in emulators():
        if it['states_dir'] and it['states_dir'] not in s['states_dirs']: add['states_dirs'].append(it['states_dir'])
        if it['notes_dir'] and it['notes_dir'] not in s['emulator_dirs']: add['emulator_dirs'].append(it['notes_dir'])
        for g in it['game_dirs']:
            if g not in s['games_dirs']: add['games_dirs'].append(g)
    if found:
        for g in found['game_folders']:
            if g not in s['games_dirs'] and not any(g.startswith(x.rstrip('\\/') + os.sep) for x in s['games_dirs']): add['games_dirs'].append(g)
        for n in found['notes']:
            if n not in s['emulator_dirs']: add['emulator_dirs'].append(n)
        if found['ghidra'] and not s.get('ghidra_dir'): add['ghidra_dir'] = found['ghidra']
    for k in ('games_dirs', 'states_dirs', 'emulator_dirs'): add[k] = list(dict.fromkeys(add[k]))
    return add

def use_found_folders():
    """Add everything the last scan found to Settings."""
    s = S.load()
    if LAST.get('found') is not None and time.time() - LAST.get('t', 0) < 900: found = LAST['found']   # the scan just shown
    else: found = scan_folder(s['scan_dirs'][0]) if s.get('scan_dirs') and Path(s['scan_dirs'][0]).is_dir() else None
    add = plan(found)
    new = {k: list(dict.fromkeys(s[k] + add[k])) for k in ('games_dirs', 'states_dirs', 'emulator_dirs')}
    if add['ghidra_dir']: new['ghidra_dir'] = add['ghidra_dir']
    S.save(new); return {k: v for k, v in add.items() if v}

def pick_folder():
    """Open the system's folder picker on this PC (ROM Explorer runs locally)."""
    try:
        import tkinter as tk
        from tkinter import filedialog
    except ImportError:
        raise ValueError('The folder picker isn\'t available. Paste the folder path instead.')
    root = tk.Tk(); root.withdraw(); root.attributes('-topmost', True)
    try: d = filedialog.askdirectory(title='Pick the folder with your games and emulators', mustexist=True)
    finally: root.destroy()
    return {'folder': os.path.normpath(d) if d else ''}

def pick_file(kind='game'):
    """Open the system's file picker on this PC, for a game or a save state."""
    try:
        import tkinter as tk
        from tkinter import filedialog
    except ImportError:
        raise ValueError('The file picker isn\'t available. Paste the file path instead.')
    s = S.load(); start = ''
    if kind == 'game':
        from .platforms import EXTS
        types = [('Games and disc images', ' '.join('*' + e for e in sorted(set(EXTS)))), ('All files', '*.*')]
        start = (s.get('games_dirs') or s.get('scan_dirs') or [''])[0]
        title = 'Pick a game to open'
    else:
        types = [('Save states and RAM dumps', '*.state* *.ss* *.p2s *.ppst *.sav *.sgm *.dsv *.mst *.raw *.bin *.dmp *.st*'), ('All files', '*.*')]
        start = (s.get('states_dirs') or [''])[0]
        title = 'Pick a save state'
    root = tk.Tk(); root.withdraw(); root.attributes('-topmost', True)
    try: f = filedialog.askopenfilename(title=title, filetypes=types, initialdir=start if start and Path(start).is_dir() else None)
    finally: root.destroy()
    return {'path': os.path.normpath(f) if f else ''}

def _old_use_found_folders():
    s = S.load(); add = {'states_dirs': [], 'emulator_dirs': [], 'games_dirs': []}
    for it in emulators():
        if it['states_dir'] and it['states_dir'] not in s['states_dirs']: add['states_dirs'].append(it['states_dir'])
        if it['notes_dir'] and it['notes_dir'] not in s['emulator_dirs']: add['emulator_dirs'].append(it['notes_dir'])
        for g in it['game_dirs']:
            if g not in s['games_dirs'] and g not in add['games_dirs']: add['games_dirs'].append(g)
    new = {k: list(dict.fromkeys(s[k] + v)) for k, v in add.items()}
    S.save(new); return {k: v for k, v in add.items() if v}

# ---------------- Claude ----------------
def claude_test():
    """Start ROM Explorer's MCP server the way Claude will, and check it answers."""
    t0 = time.time()
    try:
        p = subprocess.Popen([sys.executable, str(ROOT / 'romx_mcp.py')], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, encoding='utf-8')
        msgs = [{'jsonrpc': '2.0', 'id': 1, 'method': 'initialize', 'params': {'protocolVersion': '2025-06-18', 'capabilities': {}, 'clientInfo': {'name': 'setup-check', 'version': '1'}}},
                {'jsonrpc': '2.0', 'method': 'notifications/initialized'}, {'jsonrpc': '2.0', 'id': 2, 'method': 'tools/list'}]
        out, err = p.communicate('\n'.join(json.dumps(m) for m in msgs) + '\n', timeout=30)
        replies = [json.loads(l) for l in out.splitlines() if l.strip().startswith('{')]
        tools = next((r['result']['tools'] for r in replies if r.get('id') == 2 and 'result' in r), None)
        if tools: return {'ok': True, 'msg': f'Claude\'s side starts and offers {len(tools)} tools ({time.time() - t0:.1f}s).'}
        return {'ok': False, 'msg': 'It started but didn\'t answer properly. ' + (err or '')[-600:]}
    except subprocess.TimeoutExpired:
        p.kill(); return {'ok': False, 'msg': 'It didn\'t answer within 30 seconds.'}
    except Exception as e: return {'ok': False, 'msg': str(e)}

def overview():
    """Everything the Setup page shows, in one go (without the slower live tests)."""
    from . import server as SV
    s = S.load(); chk = S.check(s)
    pk = packages(); st = SV.state(); cl = SV.claude_info()
    games = len(SV.games()) if s['games_dirs'] else 0
    steps = [
        {'id': 'packages', 'title': 'ROM Explorer\'s parts', 'ok': all(p['ok'] for p in pk if p['required']), 'packages': pk, 'python': sys.version.split()[0], 'python_path': sys.executable},
        {'id': 'folders', 'title': 'Your game folders', 'ok': bool(s['games_dirs']) and chk['games_dirs'][0] == 'ok', 'games': games, 'dirs': s['games_dirs'], 'check': chk['games_dirs']},
        {'id': 'project', 'title': 'Open your first game', 'ok': bool(st['projects']), 'projects': len(st['projects'])},
        {'id': 'claude', 'title': 'Connect Claude', 'ok': cl['installed'], 'claude': cl},
        {'id': 'emulators', 'title': 'Emulators (optional)', 'ok': None},
        {'id': 'ghidra', 'title': 'Ghidra for decompiled C (optional)', 'ok': chk['ghidra_dir'][0] == 'ok' if s.get('ghidra_dir') else None, 'check': chk['ghidra_dir']},
    ]
    return {'steps': steps, 'windows': IS_WIN, 'install': INSTALL}

"""App settings: folders the tool works with. Stored as JSON in the user's app-data folder."""
import json, os, sys
from pathlib import Path

def config_dir():
    if sys.platform == 'win32' and os.environ.get('APPDATA'):
        return Path(os.environ['APPDATA']) / 'ROM Explorer'
    return Path.home() / '.romx'

APP = Path(__file__).resolve().parent.parent   # the ROM Explorer folder itself
OLD_HOME = Path.home() / 'ROM Explorer'          # where projects went before they moved into the app folder
DEFAULTS = {
    'work_dir': str(APP / 'Work'),           # analysis cache and exported files
    'projects_dir': str(APP / 'Projects'),   # one .romx.json per game: your names, labels and notes
    'games_dirs': [],                        # folders to list ROMs and disc images from
    'emulator_dirs': [],                     # RetroAchievements emulators (RALibretro, RAPCSX2, ...) for code notes
    'states_dirs': [],                       # emulator save-state folders, to pick states from
    'scan_dirs': [],                         # folders the Setup scan looks through (e.g. an RA Dev folder)
    'emu_dirs': {},                          # emulator -> its folder, found by the scan
    'live_keys': [],                         # emulator key bindings, for pressing buttons in emulators without an input API
    'ghidra_dir': '',                        # optional: Ghidra install, for the decompiled C view
    'port': 8765,
}
FIELDS = {
    'work_dir': ('Work folder', 'Where the tool keeps its analysis cache and files it exports.'),
    'projects_dir': ('Projects folder', 'One project file per game with your function names, labels and notes. Back this up.'),
    'games_dirs': ('Game folders', 'Folders with your ROMs and disc images. The Open screen lists games from here. One folder per line.'),
    'emulator_dirs': ('RetroAchievements emulator folders', 'RALibretro, RAPCSX2 and other RAIntegration emulators. Used to import and compare your code notes from RACache\\Data. One folder per line.'),
    'states_dirs': ('Save state folders (optional)', 'Where your emulators keep save states (RetroArch states, PPSSPP PSP\\PPSSPP_STATE, PCSX2 sstates, DuckStation savestates...). Save states tab lists the newest ones from here. One folder per line.'),
    'live_keys': ('Emulator keys (optional)', 'So Claude can press buttons in emulators that have no input link (Windows): the keyboard keys you bound in each emulator, one emulator per line, e.g.  pcsx2: Cross = X, Circle = C, Start = Enter, Up = Up, savestate = F1, loadstate = F3'),
    'ghidra_dir': ('Ghidra folder (optional)', 'The Ghidra install folder, the one containing support\\analyzeHeadless. Only needed for the decompiled C view.'),
}

def path():
    return config_dir() / 'settings.json'

def load():
    s = dict(DEFAULTS)
    try:
        s.update(json.loads(path().read_text(encoding='utf-8')))
    except (OSError, ValueError):
        pass
    if s.get('projects_dir') == str(OLD_HOME / 'Projects') or s.get('work_dir') == str(OLD_HOME / 'Work'):
        s = move_to_app_folder(s)
    return s

def move_to_app_folder(s):
    """Projects used to live in your user folder (ROM Explorer\\Projects). Copy them into the app's own folder once
    and point the settings there. The old copies are left where they were."""
    import shutil
    new_p, new_w = Path(DEFAULTS['projects_dir']), Path(DEFAULTS['work_dir'])
    try:
        new_p.mkdir(parents=True, exist_ok=True)
        old_p = OLD_HOME / 'Projects'
        if s.get('projects_dir') == str(old_p):
            if old_p.is_dir():
                for f in old_p.iterdir():
                    dest = new_p / f.name
                    if dest.exists(): continue
                    if f.is_dir(): shutil.copytree(f, dest)
                    else: shutil.copy2(f, dest)
            s['projects_dir'] = str(new_p)
        if s.get('work_dir') == str(OLD_HOME / 'Work'): s['work_dir'] = str(new_w)
        new_w.mkdir(parents=True, exist_ok=True)
        config_dir().mkdir(parents=True, exist_ok=True)
        saved = {}
        try: saved = json.loads(path().read_text(encoding='utf-8'))
        except (OSError, ValueError): pass
        saved.update(projects_dir=s['projects_dir'], work_dir=s['work_dir'])
        path().write_text(json.dumps(saved, indent=2), encoding='utf-8')
    except OSError:
        pass   # app folder not writable: keep using the old place
    return s

def save(new):
    s = load()
    for k in DEFAULTS:
        if k in new:
            v = new[k]
            if isinstance(DEFAULTS[k], dict) and not isinstance(v, dict): continue
            if isinstance(DEFAULTS[k], list) and isinstance(v, str):
                v = [x.strip() for x in v.splitlines() if x.strip()]
            s[k] = v
    config_dir().mkdir(parents=True, exist_ok=True)
    path().write_text(json.dumps(s, indent=2), encoding='utf-8')
    for k in ('work_dir', 'projects_dir'):
        try: Path(s[k]).mkdir(parents=True, exist_ok=True)
        except OSError: pass
    return s

def notes_dirs(s):
    """RACache\\Data folders found under the emulator folders."""
    out = []
    for d in s.get('emulator_dirs', []):
        for cand in (Path(d) / 'RACache' / 'Data', Path(d)):
            if cand.is_dir() and any(cand.glob('*-Notes.json')):
                out.append(cand); break
    return out

def check(s):
    """Status per field: ('ok'|'warn'|'error', message)."""
    res = {}
    for k in ('work_dir', 'projects_dir'):
        p = Path(s[k])
        res[k] = ('ok', 'Folder exists.') if p.is_dir() else ('warn', 'Will be created when you save.')
    gd = s.get('games_dirs', [])
    if not gd: res['games_dirs'] = ('warn', 'No folders yet. You can still open a game by pasting its full path.')
    else:
        bad = [d for d in gd if not Path(d).is_dir()]
        res['games_dirs'] = ('error', 'Not found: ' + ', '.join(bad)) if bad else ('ok', f'{len(gd)} folder(s) found.')
    ed = s.get('emulator_dirs', [])
    if not ed: res['emulator_dirs'] = ('warn', 'Not set. Code notes import is off until you add one.')
    else:
        nd = notes_dirs(s)
        bad = [d for d in ed if not Path(d).is_dir()]
        if bad: res['emulator_dirs'] = ('error', 'Not found: ' + ', '.join(bad))
        elif not nd: res['emulator_dirs'] = ('warn', 'Folder found, but no RACache\\Data\\*-Notes.json inside yet. Open a game in the emulator once.')
        else: res['emulator_dirs'] = ('ok', 'Code notes found in ' + ', '.join(str(x) for x in nd))
    sd = s.get('states_dirs', [])
    if not sd: res['states_dirs'] = ('warn', 'Not set. You can still add a save state by pasting its path.')
    else:
        bad = [d for d in sd if not Path(d).is_dir()]
        res['states_dirs'] = ('error', 'Not found: ' + ', '.join(bad)) if bad else ('ok', f'{len(sd)} folder(s) found.')
    g = s.get('ghidra_dir', '')
    if not g: res['ghidra_dir'] = ('warn', 'Not set. Everything except the decompiled C view works without it.')
    else:
        p = Path(g) / 'support'
        if (p / 'analyzeHeadless.bat').exists() or (p / 'analyzeHeadless').exists():
            res['ghidra_dir'] = ('ok', 'analyzeHeadless found.')
        else:
            res['ghidra_dir'] = ('error', 'No support\\analyzeHeadless in that folder. Pick the folder Ghidra was unzipped to.')
    return res

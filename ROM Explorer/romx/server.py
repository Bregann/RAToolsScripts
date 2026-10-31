"""Local web server: serves the UI and a small JSON API. Listens on 127.0.0.1 only."""
import json, pickle, threading, traceback, os, subprocess, sys, time
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
from pathlib import Path
from urllib.parse import urlparse, parse_qs
from . import settings as S, project as PR, core, statestore as SS, progress as PG
from .platforms import detect, BY_KEY, PLATFORMS, EXTS

UI = Path(__file__).parent / 'ui' / 'index.html'
LOCK = threading.Lock()
CACHE = {}   # project id -> {'img', 'F', 'data'}

def state():
    s = S.load()
    projs = []
    if Path(s['projects_dir']).is_dir():
        for p in PR.all_projects(s['projects_dir']):
            projs.append({'id': p.id, 'game': p.game, 'platform': BY_KEY[p.platform].NAME if p.platform in BY_KEY else p.platform,
                          'rom': p.rom, 'named': len(p.funcs), 'labels': len(p.labels), 'ra_game_id': p.ra_game_id,
                          'missing': not Path(p.rom).exists()})
    return {'settings': s, 'checks': S.check(s), 'fields': S.FIELDS, 'settings_file': str(S.path()),
            'projects': projs, 'platforms': [{'key': p.KEY, 'name': p.NAME, 'cpu': p.CPU, 'exts': p.EXTS} for p in PLATFORMS]}

GAMES_CACHE = {}
def games(refresh=False):
    """Games in your game folders. Looking through big folders takes a few seconds, so the list is kept for
    10 minutes (or until the folders change); refresh=True looks again."""
    s = S.load(); key = tuple(s['games_dirs'])
    hit = GAMES_CACHE.get(key)
    if hit and not refresh and time.time() - hit[0] < 600: return hit[1]
    from .setup import scan_folder
    out = []; seen = set()
    for d in s['games_dirs']:
        root = Path(d)
        if not root.is_dir(): continue
        try: found = scan_folder(root)['games']
        except (OSError, ValueError): found = []
        for g in sorted(found):
            if len(out) >= 2000: break
            if g in seen: continue
            seen.add(g); p = Path(g)
            try: out.append({'path': str(p), 'name': p.name, 'folder': str(p.parent), 'size': p.stat().st_size})
            except OSError: pass
    GAMES_CACHE.clear(); GAMES_CACHE[key] = (time.time(), out)
    return out

def get_project(pid):
    s = S.load()
    p = Path(s['projects_dir']) / f'{pid}.romx.json'
    if not p.exists(): raise KeyError('That project no longer exists.')
    return PR.load(p)

def analysis(proj):
    """Load the game and its analysis (cached on disk in the work folder)."""
    if proj.id in CACHE: return CACHE[proj.id]
    s = S.load(); P = BY_KEY[proj.platform]
    rom = Path(proj.rom)
    if not rom.exists(): raise FileNotFoundError(f'The game file is missing: {rom}')
    PG.say(f'Reading {rom.name} ({rom.stat().st_size / 1048576:,.1f} MB)…')
    img = P.load(str(rom))
    PG.say(f'Loaded {img.info}: {len(img.data) / 1024:,.0f} KB of code and data.')
    st = rom.stat(); stamp = (st.st_size, int(st.st_mtime))
    cache = Path(s['work_dir']) / f'{proj.id}.analysis.pkl'
    F = None
    try:
        saved = pickle.loads(cache.read_bytes())
        if saved.get('stamp') == stamp and saved.get('v') == 2: F = saved['F']; PG.say(f'Using the saved analysis from last time ({len(F):,} functions).')
    except (OSError, ValueError, pickle.UnpicklingError, EOFError):
        pass
    if F is None:
        PG.say(f'Finding the functions in the {P.CPU} code and the RAM each one uses…')
        F = P.analyze(img)
        PG.say(f'Found {len(F):,} functions, {sum(len(f["refs"]) for f in F.values()):,} RAM references.')
        try:
            cache.parent.mkdir(parents=True, exist_ok=True); cache.write_bytes(pickle.dumps({'stamp': stamp, 'v': 2, 'F': F}))
        except OSError:
            pass
    CACHE[proj.id] = {'img': img, 'F': F, 'P': P, 'data': None}
    return CACHE[proj.id]

def data(pid):
    proj = get_project(pid); a = analysis(proj)
    try: stamp = proj.path.stat().st_mtime_ns   # the project file can also be changed by Claude (MCP), so rebuild when it changes
    except OSError: stamp = None
    if a.get('stamp') != stamp: a['data'] = None; a['stamp'] = stamp
    if a['data'] is None:
        import copy
        PG.say('Explaining the code in plain English and applying your names and labels…')
        a['data'] = core.build(a['P'], a['img'], copy.deepcopy(a['F']), proj)
        d = a['data']; named = sum(1 for f in d['funcs'] if not f['name'].startswith('sub_'))
        PG.say(f'Done: {len(d["funcs"]):,} functions ({named:,} named), {len(d["addrs"]):,} RAM addresses, {len(d["text"]):,} text strings, {len(d["labels"]):,} labels.')
    a['data']['ghidra'] = ghidra_has_results(pid)
    a['data']['ghidra_ok'] = hasattr(a['P'], 'ghidra_import')
    return a['data']

def page_data(pid):
    """What the page loads up front: everything except each function's code lines (fetched when you open one).
    Keeps big games (10,000+ functions) quick to open and to reload after an edit."""
    d = data(pid); a = CACHE[pid]
    if a.get('slim_of') is not d:
        a['by_addr'] = {f['a']: f for f in d['funcs']}
        a['slim'] = dict(d, funcs=[dict({k: v for k, v in f.items() if k != 'lines'}, nl=sum(1 for l in f['lines'] if l[3] != 'label')) for f in d['funcs']])
        a['slim_of'] = d
    a['slim']['ghidra'] = d['ghidra']; return a['slim']

def func_lines(pid, addr):
    page_data(pid); f = CACHE[pid]['by_addr'].get(int(addr))
    if not f: raise KeyError('No function at that address.')
    return {'a': f['a'], 'lines': f['lines']}

# ---------------- Ghidra (optional) ----------------
GH = {}        # project id -> run status
GH_RES = {}    # project id -> {entry: record}
SCRIPTS = Path(__file__).parent / 'ghidra'
def ghidra_dir():
    return Path(S.load()['work_dir']) / 'ghidra'
def ghidra_out(pid): return ghidra_dir() / f'{pid}.ghidra.json'
def ghidra_has_results(pid): return ghidra_out(pid).exists()
def headless():
    g = S.load().get('ghidra_dir', '')
    if not g: raise ValueError('Set your Ghidra folder in Settings first.')
    sup = Path(g) / 'support'
    for n in ('analyzeHeadless.bat', 'analyzeHeadless'):
        if (sup / n).exists(): return sup / n
    raise FileNotFoundError(f'No analyzeHeadless in {sup}. Check the Ghidra folder in Settings.')

def ghidra_run(b):
    pid = b['id']
    if GH.get(pid, {}).get('state') == 'running': return ghidra_status(pid)
    proj = get_project(pid); a = analysis(proj); P = a['P']
    if not hasattr(P, 'ghidra_import'): raise ValueError(f'Decompiling {P.NAME} games with Ghidra is not set up yet.')
    exe = headless()
    work = ghidra_dir(); work.mkdir(parents=True, exist_ok=True)
    imp = P.ghidra_import(a['img'], proj.rom, work)
    starts = work / f'{pid}.starts.txt'
    reg = imp.get('region')
    keys = sorted(k for k in a['F'] if reg is None or (k >> 32) == reg)
    if imp.get('thumb') == 'per-start':
        starts.write_text('\n'.join(f'{k & 0xFFFFFFFF:x} {"t" if a["F"][k].get("mode") == "thumb" else "a"}' for k in keys), encoding='utf-8')
    else:
        starts.write_text('\n'.join(f'{k & 0xFFFFFFFF:x}' for k in keys), encoding='utf-8')
    out = ghidra_out(pid); log = work / f'{pid}.ghidra.log'
    tmp = out.with_suffix('.partial.json')
    cmd = [str(exe), str(work / 'projects'), pid, '-import', imp['file'], *imp['args'], '-overwrite',
           '-scriptPath', str(SCRIPTS), '-preScript', 'RomxExport.java', 'pre', str(starts), {'per-start': '2', True: '1'}.get(imp.get('thumb'), '0'),
           '-postScript', 'RomxExport.java', 'post', str(tmp), '-deleteProject']
    if sys.platform == 'win32': cmd = ['cmd', '/c'] + cmd
    (work / 'projects').mkdir(exist_ok=True)
    GH[pid] = {'state': 'running', 'started': time.time(), 'msg': 'Ghidra is analysing the game. Big games can take a long time.'}
    def go():
        try:
            with open(log, 'w', encoding='utf-8', errors='replace') as lf:
                r = subprocess.run(cmd, stdout=lf, stderr=subprocess.STDOUT)
            if tmp.exists() and tmp.stat().st_size > 20:
                tmp.replace(out); GH_RES.pop(pid, None)
                GH[pid] = {'state': 'done', 'msg': f'Finished in {int(time.time() - GH[pid]["started"])} seconds.'}
            else:
                GH[pid] = {'state': 'error', 'msg': f'Ghidra stopped without writing results (exit code {r.returncode}). The log below says why.'}
        except Exception as e:
            GH[pid] = {'state': 'error', 'msg': f'Could not start Ghidra: {e}'}
    threading.Thread(target=go, daemon=True).start()
    return ghidra_status(pid)

def ghidra_status(pid):
    st = dict(GH.get(pid) or ({'state': 'done', 'msg': 'Results from an earlier run.'} if ghidra_has_results(pid) else {'state': 'none', 'msg': ''}))
    log = ghidra_dir() / f'{pid}.ghidra.log'
    if log.exists():
        lines = log.read_text(encoding='utf-8', errors='replace').splitlines()
        st['log'] = '\n'.join(lines[-14:])
        lang = [l for l in lines if 'Using Language/Compiler' in l or 'language' in l.lower() and 'using' in l.lower()]
        if lang: st['language'] = lang[-1].strip()[-120:]
    if st.get('state') == 'running': st['elapsed'] = int(time.time() - st.get('started', time.time()))
    st.pop('started', None)
    return st

def ghidra_func(pid, a):
    if pid not in GH_RES:
        f = ghidra_out(pid)
        if not f.exists(): raise FileNotFoundError('No Ghidra results yet. Run it from Project & notes.')
        GH_RES[pid] = {r['entry']: r for r in json.loads(f.read_text(encoding='utf-8'))['functions']}
    r = GH_RES[pid].get(int(a))
    if not r:
        near = [e for e in GH_RES[pid] if e <= int(a) <= GH_RES[pid][e]['end']]
        if near: r = GH_RES[pid][max(near)]
    if not r: return {'c': '', 'name': None, 'missing': True}
    return {'c': r['c'], 'name': r['name'], 'entry': r['entry']}

def open_game(path):
    path = path.strip().strip('"')
    if not Path(path).is_file(): raise FileNotFoundError(f'No file at {path}')
    PG.say(f'Checking what {Path(path).name} is…')
    P = detect(path)
    if P: PG.say(f'It\'s a {P.NAME} game.')
    if not P: raise ValueError('Not a game this tool can read yet. Supported: ' + ', '.join(f'{p.NAME} ({" ".join(p.EXTS)})' for p in PLATFORMS))
    img = P.load(path)
    seed = P.seed_key(img) if hasattr(P, 'seed_key') else None
    proj = PR.create(S.load()['projects_dir'], path, P.KEY, img.info, seed)
    PG.say(f'Project: {proj.game}' + (f' (started from the built-in notes for this game: {len(proj.labels)} labels)' if proj.labels and seed else ''))
    analysis(proj)
    return {'id': proj.id}

def edit(b):
    proj = get_project(b['id'])
    if b['kind'] == 'func':
        proj.set_func(int(b['addr']), b.get('name', ''), b.get('note', ''))
    elif b['kind'] == 'label':
        ra = int(b['ra']); proj.set_label(ra, b.get('name', ''), b.get('size', 1), b.get('note', ''))
        vals = b.get('values')
        if vals is not None and b.get('name'):
            name = [l['name'] for l in proj.labels if l['ra'] == ra][0]
            parsed = {}
            for line in vals.splitlines():
                if '=' in line:
                    k, v = line.split('=', 1)
                    try: parsed[str(int(k.strip(), 0))] = v.strip()
                    except ValueError: pass
            if parsed: proj.enums[name] = parsed
            else: proj.enums.pop(name, None)
    elif b['kind'] == 'project':
        proj.game = b.get('game', proj.game)
        gid = str(b.get('ra_game_id', '') or '').strip(); proj.ra_game_id = int(gid) if gid.isdigit() else None
    proj.save()
    if proj.id in CACHE: CACHE[proj.id]['data'] = None
    return {'ok': True}

def import_notes(b):
    proj = get_project(b['id']); s = S.load()
    gid = str(b.get('ra_game_id') or proj.ra_game_id or '').strip()
    if not gid.isdigit(): raise ValueError('Enter the RetroAchievements game ID first (the number in the game page URL).')
    for d in S.notes_dirs(s):
        f = d / f'{gid}-Notes.json'
        if f.exists():
            a, u, k = proj.import_notes(f, bool(b.get('overwrite')))
            proj.ra_game_id = int(gid); proj.save()
            if proj.id in CACHE: CACHE[proj.id]['data'] = None
            return {'added': a, 'updated': u, 'skipped': k, 'file': str(f)}
    raise FileNotFoundError(f'No {gid}-Notes.json in your emulator folders. Load the game once in a RetroAchievements emulator so it downloads the notes.')

def paste_notes(b):
    proj = get_project(b['id'])
    entries = PR.parse_pasted_notes(b.get('text', ''))
    if not entries: raise ValueError('No code notes found in that text. Copy the whole notes table from the game\'s Code Notes page, including the 0x... address lines.')
    a, u, k = proj.import_entries(entries, bool(b.get('overwrite'))); proj.save()
    if proj.id in CACHE: CACHE[proj.id]['data'] = None
    return {'added': a, 'updated': u, 'skipped': k, 'file': 'pasted text', 'found': len(entries)}

def export_notes(b):
    proj = get_project(b['id']); s = S.load()
    name = f'{proj.ra_game_id or proj.id}-Notes.export.json'
    out = Path(s['work_dir']) / name; out.parent.mkdir(parents=True, exist_ok=True)
    n = proj.export_notes(out)
    return {'file': str(out), 'count': n}

# ---------------- save states ----------------
def st_ctx(pid):
    proj = get_project(pid); a = analysis(proj); return proj, a
def states_list(pid):
    proj, a = st_ctx(pid)
    return {'states': SS.listing(proj), 'suggest': SS.suggestions(S.load(), proj.rom), 'supported': a['P'].KEY in SS.ST.RA_SIZE}
def states_add(b):
    proj, a = st_ctx(b['id']); path = Path(str(b['path']).strip().strip('"'))
    if not path.is_file(): raise FileNotFoundError(f'No file at {path}')
    stem = Path(proj.rom).stem
    short = path.name[len(stem):].strip(' ._-') if path.name.lower().startswith(stem.lower()) else path.name
    st = SS.add(proj, a['img'], a['P'], path.read_bytes(), b.get('name') or short or path.name, str(path), b.get('note', ''))
    return {'state': st, 'states': SS.listing(proj)}
def states_upload(pid, name, raw):
    proj, a = st_ctx(pid)
    st = SS.add(proj, a['img'], a['P'], raw, name or 'uploaded state', '', '')
    return {'state': st, 'states': SS.listing(proj)}
def states_edit(b):
    proj, a = st_ctx(b['id']); act = b.get('action', 'edit'); sid = int(b.get('sid', 0))
    if act == 'remove': SS.remove(proj, sid)
    elif act == 'reread': SS.reread(proj, a['img'], a['P'], sid)
    else: SS.edit(proj, sid, b.get('name'), b.get('note'), b.get('order'))
    return {'states': SS.listing(proj)}
def states_compare(b):
    proj, a = st_ctx(b['id']); size = int(b.get('size', 1))
    if size not in (1, 2, 4): raise ValueError('Size must be 8, 16 or 32-bit.')
    sids = [int(x) for x in b['sids']]
    if not sids: raise ValueError('Pick at least one save state.')
    only = None
    if b.get('only_code'):
        d = data(proj.id); only = {r['ra'] - r['ra'] % size for r in d['addrs']} | {l['ra'] - l['ra'] % size for l in d['labels']}
    n, rows = SS.compare(proj, a['P'], sids, size, b.get('steps', []), only)
    return {'count': n, 'rows': rows}
def states_values(pid, ra, size):
    proj, a = st_ctx(pid); return SS.values(proj, a['P'], int(ra), int(size))

# ---------------- connecting to Claude (MCP) ----------------
ROOT = Path(__file__).resolve().parent.parent
def claude_config_path():
    if sys.platform == 'win32':
        local = Path(os.environ.get('LOCALAPPDATA', ''))
        for pk in (local / 'Packages').glob('Claude_*') if local.is_dir() and (local / 'Packages').is_dir() else []:   # Microsoft Store install
            c = pk / 'LocalCache' / 'Roaming' / 'Claude'
            if c.is_dir(): return c / 'claude_desktop_config.json'
        return Path(os.environ.get('APPDATA', str(Path.home()))) / 'Claude' / 'claude_desktop_config.json'
    if sys.platform == 'darwin': return Path.home() / 'Library' / 'Application Support' / 'Claude' / 'claude_desktop_config.json'
    return Path.home() / '.config' / 'Claude' / 'claude_desktop_config.json'
def claude_entry():
    return {'command': sys.executable, 'args': [str(ROOT / 'romx_mcp.py')]}
def claude_info():
    f = claude_config_path(); cur = None
    try: cur = json.loads(f.read_text(encoding='utf-8')).get('mcpServers', {}).get('rom-explorer')
    except (OSError, ValueError, AttributeError): pass
    e = claude_entry()
    return {'config_file': str(f), 'app_found': f.parent.is_dir(), 'installed': cur == e, 'other': bool(cur) and cur != e,
            'snippet': json.dumps({'mcpServers': {'rom-explorer': e}}, indent=2),
            'claude_code': f'claude mcp add rom-explorer -- "{e["command"]}" "{e["args"][0]}"'}
def claude_install(b):
    f = claude_config_path()
    if not f.parent.is_dir(): raise FileNotFoundError('The Claude desktop app\'s settings folder wasn\'t found. Install the Claude desktop app and open it once, or add the snippet by hand (Claude > Settings > Developer > Edit Config).')
    try: cfg = json.loads(f.read_text(encoding='utf-8')) if f.exists() else {}
    except ValueError: raise ValueError(f'{f} isn\'t valid JSON, so it wasn\'t changed. Fix it or add the snippet by hand.')
    if f.exists(): (f.parent / (f.name + '.romx-backup')).write_text(f.read_text(encoding='utf-8'), encoding='utf-8')
    cfg.setdefault('mcpServers', {})['rom-explorer'] = claude_entry()
    f.write_text(json.dumps(cfg, indent=2), encoding='utf-8')
    return claude_info()

from . import setup as SU, ranotes as RN
def ranotes_info(pid, d=None):
    proj = get_project(pid); gid = proj.ra_game_id
    dirs = RN.ra_data_dirs()
    used = [x for x in dirs if gid and ((Path(x) / f'{gid}-Notes.json').exists() or (Path(x) / f'{gid}.json').exists() or (Path(x) / f'{gid}-User.txt').exists())]
    pick = d if d in dirs else (used[0] if used else (dirs[0] if dirs else ''))
    rows = RN.plan(proj, pick) if pick and gid else []
    local = RN.local_notes(pick, gid) if pick and gid else {}
    for r in rows:
        if r['ra'] in local: r['local'] = local[r['ra']]
    return {'game_id': gid, 'dirs': dirs, 'used': used, 'dir': pick, 'rows': rows}
def ranotes_write(b):
    proj = get_project(b['id']); d = b.get('dir')
    if d not in RN.ra_data_dirs(): raise ValueError('Pick one of the RACache folders listed.')
    inc = tuple(b.get('include') or ('new',))
    r = RN.write(proj, d, inc, set(int(x) for x in b['addresses']) if b.get('addresses') else None)
    return dict(r, info=ranotes_info(b['id'], d))
ROUTES = {'/api/ranotes/write': ranotes_write, '/api/settings': lambda b: (S.save(b), GAMES_CACHE.clear(), state())[2], '/api/setup/install': lambda b: SU.install_packages(bool(b.get('optional'))), '/api/setup/fix': lambda b: SU.fix_emulator(b['key']),
          '/api/setup/use_folders': lambda b: (GAMES_CACHE.clear(), SU.use_found_folders())[1], '/api/setup/scan': lambda b: SU.scan(str(b.get('folder') or '').strip().strip('"')), '/api/setup/pick_folder': lambda b: SU.pick_folder(), '/api/pick_file': lambda b: SU.pick_file(b.get('kind', 'game')), '/api/setup/claude_test': lambda b: SU.claude_test(),
          '/api/claude/install': claude_install, '/api/states/add': states_add, '/api/states/edit': states_edit, '/api/states/compare': states_compare,
          '/api/open': lambda b: open_game(b['path']),
          '/api/edit': edit, '/api/ghidra/run': ghidra_run, '/api/notes/import': import_notes, '/api/notes/paste': paste_notes, '/api/notes/export': export_notes}

class H(BaseHTTPRequestHandler):
    def log_message(self, *a): pass
    def send(self, code, body, ctype='application/json'):
        raw = body if isinstance(body, bytes) else json.dumps(body, separators=(',', ':')).encode()
        self.send_response(code); self.send_header('Content-Type', ctype); self.send_header('Content-Length', str(len(raw)))
        self.send_header('Cache-Control', 'no-store'); self.end_headers(); self.wfile.write(raw)
    def fail(self, e):
        msg = str(e) if isinstance(e, (ValueError, KeyError, FileNotFoundError, OSError)) else f'Something went wrong: {e}'
        if not isinstance(e, (ValueError, KeyError, FileNotFoundError)): traceback.print_exc()
        self.send(400, {'error': msg.strip("'")})
    def do_GET(self):
        u = urlparse(self.path); q = {k: v[0] for k, v in parse_qs(u.query).items()}
        try:
            if u.path in ('/', '/index.html'): return self.send(200, UI.read_bytes(), 'text/html; charset=utf-8')
            if u.path == '/api/state': return self.send(200, state())
            if u.path == '/api/games': return self.send(200, games(q.get('refresh') == '1'))
            if u.path == '/api/ghidra/status': return self.send(200, ghidra_status(q['id']))
            if u.path == '/api/ghidra/func': return self.send(200, ghidra_func(q['id'], q['a']))
            if u.path == '/api/claude': return self.send(200, claude_info())
            if u.path == '/api/ranotes': return self.send(200, ranotes_info(q['id'], q.get('dir')))
            if u.path == '/api/setup': return self.send(200, SU.overview())
            if u.path == '/api/setup/emulators': return self.send(200, SU.emulators(q.get('test') == '1'))
            if u.path == '/api/states':
                with LOCK: return self.send(200, states_list(q['id']))
            if u.path == '/api/states/values':
                with LOCK: return self.send(200, states_values(q['id'], q['ra'], q.get('size', 1)))
            if u.path == '/api/func':
                with LOCK: return self.send(200, func_lines(q['id'], q['a']))
            if u.path == '/api/progress': return self.send(200, PG.get(q.get('job', ''), int(q.get('since', 0))))
            if u.path == '/api/data':
                PG.start(q.get('job'))
                try:
                    with LOCK: return self.send(200, page_data(q['id']))
                finally: PG.end()
            self.send(404, {'error': 'Not found'})
        except Exception as e: self.fail(e)
    def do_POST(self):
        u = urlparse(self.path)
        try:
            n = int(self.headers.get('Content-Length') or 0)
            if u.path == '/api/states/upload':
                q = {k: v[0] for k, v in parse_qs(u.query).items()}; raw = self.rfile.read(n)
                with LOCK: return self.send(200, states_upload(q['id'], q.get('name', ''), raw))
            b = json.loads(self.rfile.read(n) or b'{}')
            if u.path not in ROUTES: return self.send(404, {'error': 'Not found'})
            PG.start(b.get('job') if isinstance(b, dict) else None)
            try:
                with LOCK: return self.send(200, ROUTES[u.path](b))
            finally: PG.end()
        except Exception as e: self.fail(e)

def serve(port=None, open_browser=True):
    s = S.load(); port = port or s.get('port', 8765)
    for k in ('work_dir', 'projects_dir'):
        try: Path(s[k]).mkdir(parents=True, exist_ok=True)
        except OSError: pass
    srv = ThreadingHTTPServer(('127.0.0.1', port), H)
    url = f'http://127.0.0.1:{port}/'
    print(f'ROM Explorer is running at {url}  (close this window to stop it)')
    if open_browser:
        import webbrowser; threading.Timer(0.6, lambda: webbrowser.open(url)).start()
    srv.serve_forever()

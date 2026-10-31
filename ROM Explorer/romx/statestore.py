"""Save states attached to a project. Each added state is read once: its RAM (by RA address) is kept,
compressed, next to the project file in <project id>.states/, so later re-saves in the emulator don't change it
unless you press Re-read."""
import json, time, zlib
from pathlib import Path
from . import states as ST

STATE_EXTS = ('.state', '.ss0', '.ss1', '.ss2', '.ss3', '.ss4', '.ss5', '.ss6', '.ss7', '.ss8', '.ss9', '.p2s', '.ppst',
              '.sav', '.sgm', '.dsv', '.mst', '.raw', '.bin', '.dmp', '.st0', '.st1', '.st2', '.st3', '.st4', '.st5')
MEM = {}   # (project id, state id) -> RA memory bytes

def _dir(proj): return proj.path.parent / f'{proj.id}.states'
def _meta(proj):
    f = _dir(proj) / 'states.json'
    try: return json.loads(f.read_text(encoding='utf-8'))
    except (OSError, ValueError): return []
def _save_meta(proj, m):
    d = _dir(proj); d.mkdir(parents=True, exist_ok=True)
    (d / 'states.json').write_text(json.dumps(m, indent=1, ensure_ascii=False), encoding='utf-8')

def mem(proj, sid):
    k = (proj.id, sid)
    if k not in MEM:
        MEM[k] = zlib.decompress((_dir(proj) / f'{sid}.ram.z').read_bytes())
    return MEM[k]

def listing(proj): return _meta(proj)

def add(proj, img, P, raw, name, source='', note=''):
    m, how = ST.extract(raw, img, P)
    return add_memory(proj, m, name, note, how, source)

def add_memory(proj, m, name, note='', how='', source=''):
    meta = _meta(proj); sid = max([s['sid'] for s in meta] + [0]) + 1
    d = _dir(proj); d.mkdir(parents=True, exist_ok=True)
    (d / f'{sid}.ram.z').write_bytes(zlib.compress(m, 1)); MEM[(proj.id, sid)] = m
    meta.append({'sid': sid, 'name': name, 'note': note, 'source': source, 'how': how, 'added': int(time.time())})
    _save_meta(proj, meta); return meta[-1]

def reread(proj, img, P, sid):
    meta = _meta(proj); s = next((x for x in meta if x['sid'] == sid), None)
    if not s or not s.get('source'): raise ValueError('This state was uploaded, so there is no file to read again.')
    raw = Path(s['source']).read_bytes()
    m, how = ST.extract(raw, img, P)
    (_dir(proj) / f'{sid}.ram.z').write_bytes(zlib.compress(m, 1)); MEM[(proj.id, sid)] = m
    s['how'] = how; s['added'] = int(time.time()); _save_meta(proj, meta); return s

def edit(proj, sid, name=None, note=None, order=None):
    meta = _meta(proj)
    for s in meta:
        if s['sid'] == sid:
            if name is not None: s['name'] = name
            if note is not None: s['note'] = note
    if order: meta.sort(key=lambda s: order.index(s['sid']) if s['sid'] in order else 999)
    _save_meta(proj, meta)

def remove(proj, sid):
    meta = [s for s in _meta(proj) if s['sid'] != sid]; _save_meta(proj, meta)
    try: (_dir(proj) / f'{sid}.ram.z').unlink()
    except OSError: pass
    MEM.pop((proj.id, sid), None)

def suggestions(settings, rom_path, limit=40):
    """Newest save-state files in the state and emulator folders; ones named after the game first."""
    stem = Path(rom_path).stem.lower()
    found = []
    for d in list(settings.get('states_dirs', [])) + list(settings.get('emulator_dirs', [])):
        root = Path(d)
        if not root.is_dir(): continue
        n = 0
        for p in root.rglob('*'):
            n += 1
            if n > 20000: break
            suf = p.suffix.lower()
            if not (suf in STATE_EXTS or suf.startswith('.state') or '.state' in p.name.lower()): continue
            if suf in ('.bin', '.sav', '.raw', '.dmp') and 'state' not in str(p.parent).lower() and 'dump' not in p.name.lower() and 'mem' not in p.name.lower(): continue
            try: st = p.stat()
            except OSError: continue
            if not p.is_file() or st.st_size < 0x4000: continue
            found.append({'path': str(p), 'name': p.name, 'folder': str(p.parent), 'mtime': int(st.st_mtime), 'size': st.st_size,
                          'match': p.name.lower().startswith(stem[:20])})
    found.sort(key=lambda x: (not x['match'], -x['mtime']))
    seen = set(); out = []
    for f in found:
        if f['path'] in seen: continue
        seen.add(f['path']); out.append(f)
    return out[:limit]

def compare(proj, P, sids, size, steps, only=None):
    mems = [mem(proj, s) for s in sids]
    return ST.compare(mems, size, steps, big=P.KEY in ST.BIG_ENDIAN, only=only)

def values(proj, P, ra, size):
    meta = _meta(proj)
    vals = ST.values_at([mem(proj, s['sid']) for s in meta], ra, size, big=P.KEY in ST.BIG_ENDIAN)
    return [{'sid': s['sid'], 'name': s['name'], 'value': v} for s, v in zip(meta, vals)]

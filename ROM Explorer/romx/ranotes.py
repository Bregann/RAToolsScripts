"""Send ROM Explorer's labels to RAIntegration as unpublished code notes.

RAIntegration keeps a game's local (not yet published) changes in RACache\\Data\\<game id>-User.txt. Code notes there
are lines like   N0:0x0000cc6c:"[16-bit] WinFlag\\r\\n0x00 = not won\\r\\n0x01 = won"
When you next load the game in that emulator, they show in the Code Notes window as unpublished, ready to publish.
The published notes (from the website) are cached in <game id>-Notes.json, which this never changes."""
import json, re, time
from pathlib import Path
from . import settings as S

def ra_data_dirs(s=None):
    """Every RACache\\Data folder in the emulator folders and the emulators the Setup scan found."""
    s = s or S.load(); out = []
    cands = list(s.get('emulator_dirs', [])) + list((s.get('emu_dirs') or {}).values())
    for d in cands:
        p = Path(d) / 'RACache' / 'Data'
        if p.is_dir() and str(p) not in out: out.append(str(p))
    return out

def note_text(label, enums):
    """The note as RA developers write it: '[16-bit] Name' line, the note, then '0x00 = value' lines."""
    note = (label.get('note') or '').strip()
    size = label.get('size', 1)
    tag = {1: '[8-bit]', 2: '[16-bit]', 3: '[24-bit]', 4: '[32-bit]'}.get(size, f'[{size} bytes]')
    first = note.splitlines()[0] if note else ''
    has_tag = bool(re.match(r'\s*\[', first))
    lines = [note if has_tag else (f'{tag} {label["name"]}' + (f' - {note}' if note and '\n' not in note else ''))]
    if note and not has_tag and '\n' in note: lines.append(note)
    vals = enums.get(label['name']) or {}
    width = 2 if size <= 1 else size * 2
    for k, v in sorted(vals.items(), key=lambda kv: int(kv[0], 0) if isinstance(kv[0], str) else kv[0]):
        n = int(k, 0) if isinstance(k, str) else k
        line = f'0x{n:0{width}x} = {v}'
        if line.lower() not in '\n'.join(lines).lower(): lines.append(line)
    return '\r\n'.join(lines)

def _esc(t): return t.replace('\\', '\\\\').replace('"', '\\"').replace('\r\n', '\n').replace('\n', '\\r\\n')
def _unesc(t): return t.replace('\\r\\n', '\n').replace('\\"', '"').replace('\\\\', '\\')

def published(data_dir, gid):
    f = Path(data_dir) / f'{gid}-Notes.json'
    try: notes = json.loads(f.read_text(encoding='utf-8'))
    except (OSError, ValueError): return {}
    out = {}
    for n in notes:
        a = n.get('Address')
        try: out[int(a, 16) if isinstance(a, str) else int(a)] = (n.get('Note') or '').replace('\r\n', '\n').strip()
        except (TypeError, ValueError): pass
    return out

def plan(proj, data_dir, only_new=True):
    """What would be written: [{ra, note, status}] with status 'new', 'changed' (differs from RA) or 'same'."""
    gid = proj.ra_game_id
    if not gid: raise ValueError('Set the RetroAchievements game ID in Project & notes first.')
    pub = published(data_dir, gid); rows = []
    for l in sorted(proj.labels, key=lambda l: l['ra']):
        text = note_text(l, proj.enums)
        cur = pub.get(l['ra'])
        if cur is None: st = 'new'
        elif cur.replace('\r\n', '\n').strip() == text.replace('\r\n', '\n').strip() or l.get('from') == 'ra-notes': st = 'same'
        else: st = 'changed'
        rows.append({'ra': l['ra'], 'name': l['name'], 'note': text, 'status': st, 'published': cur})
    return rows

def write(proj, data_dir, include=('new',), addresses=None):
    """Add or replace N0 lines in <id>-User.txt (keeping everything else). Returns what was written."""
    gid = proj.ra_game_id
    rows = [r for r in plan(proj, data_dir) if r['status'] in include and (addresses is None or r['ra'] in addresses)]
    f = Path(data_dir) / f'{gid}-User.txt'
    raw = f.read_text(encoding='utf-8', errors='replace') if f.exists() else ''
    if f.exists(): (f.parent / (f.name + '.romx-backup')).write_text(raw, encoding='utf-8')
    lines = raw.splitlines()
    if not lines: lines = ['1.4.0.0', proj.game or '']
    want = {r['ra']: r for r in rows}
    out = []
    for line in lines:
        m = re.match(r'N0:0x([0-9a-fA-F]+):', line)
        if m and int(m.group(1), 16) in want: continue   # replaced below
        out.append(line)
    for r in rows: out.append(f'N0:0x{r["ra"]:08x}:"{_esc(r["note"])}"')
    f.write_text('\n'.join(out) + '\n', encoding='utf-8')
    return {'file': str(f), 'written': len(rows), 'rows': rows}

def local_notes(data_dir, gid):
    """Unpublished notes already in <id>-User.txt."""
    f = Path(data_dir) / f'{gid}-User.txt'; out = {}
    try:
        for line in f.read_text(encoding='utf-8', errors='replace').splitlines():
            m = re.match(r'N0:0x([0-9a-fA-F]+):"(.*)"\s*$', line)
            if m: out[int(m.group(1), 16)] = _unesc(m.group(2))
    except OSError: pass
    return out

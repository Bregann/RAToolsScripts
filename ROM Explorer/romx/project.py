"""A project is one game: which file it is, plus everything you've named, labelled and noted."""
import json, re, hashlib
from pathlib import Path

SEEDS = Path(__file__).parent / 'seeds'

def slug(s):
    return re.sub(r'[^a-z0-9]+', '-', s.lower()).strip('-')[:40] or 'game'

class Project:
    def __init__(self, path, d):
        self.path = Path(path)
        self.id = d['id']; self.game = d.get('game', ''); self.platform = d['platform']; self.rom = d['rom']
        self.ra_game_id = d.get('ra_game_id')
        self.labels = d.get('labels', []); self.funcs = d.get('funcs', {}); self.enums = d.get('enums', {})
    def to_json(self):
        return {'id': self.id, 'game': self.game, 'platform': self.platform, 'rom': self.rom, 'ra_game_id': self.ra_game_id,
                'labels': sorted(self.labels, key=lambda l: l['ra']), 'funcs': dict(sorted(self.funcs.items())), 'enums': self.enums}
    def save(self):
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self.path.write_text(json.dumps(self.to_json(), indent=1, ensure_ascii=False), encoding='utf-8')

    # ---- edits ----
    def set_func(self, addr, name, note):
        k = f'0x{addr:08X}'
        name = re.sub(r'[^A-Za-z0-9_]', '', name.replace(' ', '_'))
        if not name and not note: self.funcs.pop(k, None)
        else: self.funcs[k] = {'name': name, 'note': note}
    def set_label(self, ra, name, size, note):
        self.labels = [l for l in self.labels if l['ra'] != ra]
        name = re.sub(r'[^A-Za-z0-9_]', '', name.replace(' ', '_'))
        if name: self.labels.append({'ra': ra, 'size': max(1, int(size or 1)), 'name': name, 'note': note})

    # ---- RetroAchievements code notes ----
    def import_notes(self, notes_file, overwrite=False):
        """Merge a RAIntegration <id>-Notes.json into the labels. Returns (added, updated, skipped)."""
        return self.import_entries(json.loads(Path(notes_file).read_text(encoding='utf-8')), overwrite)
    def import_entries(self, raw, overwrite=False):
        have = {l['ra']: l for l in self.labels}
        names = {l['name'] for l in self.labels}
        added = updated = skipped = 0
        for n in raw:
            a = n.get('Address'); text = (n.get('Note') or '').strip()
            if a is None or not text: continue
            ra = int(a, 16) if isinstance(a, str) else int(a)
            name, size = note_to_label(text)
            vals = note_values(text)
            if ra in have:
                if overwrite or not have[ra].get('note'):
                    have[ra].update(note=text, size=have[ra].get('size') or size); updated += 1
                    if vals and (overwrite or have[ra]['name'] not in self.enums): self.enums[have[ra]['name']] = vals
                else: skipped += 1
                continue
            if name in names: name = f'{name}_{ra:X}'
            names.add(name)
            lab = {'ra': ra, 'size': size, 'name': name, 'note': text, 'from': 'ra-notes'}
            self.labels.append(lab); have[ra] = lab; added += 1
            if vals: self.enums[name] = vals
        return added, updated, skipped
    def export_notes(self, out_file):
        out = [{'Address': f'0x{l["ra"]:06x}', 'Note': l.get('note') or l['name']} for l in sorted(self.labels, key=lambda l: l['ra'])]
        Path(out_file).write_text(json.dumps(out, indent=1, ensure_ascii=False), encoding='utf-8')
        return len(out)

# Size / type tags people put in code notes, in [] or (): [8-bit], (16-bit BE), [Bitflag], (Bitfield), [Flags],
# [u32], [Word], [Float], [4 bytes], [0x10 bytes], [BCD], [ASCII] ...
TAG_RX = re.compile(r'[\[(]\s*([^\])]{1,40}?)\s*[\])]')
def tag_size(t):
    """Size in bytes a tag means, or None if the bracket isn't a size/type tag."""
    t = t.lower().strip()
    m = re.search(r'\b(8|16|24|32|64)\s*-?\s*bits?\b', t) or re.fullmatch(r'[us](8|16|24|32|64)', t)
    if m: return int(m.group(1)) // 8
    m = re.search(r'\b(0x[0-9a-f]+|\d+)\s*bytes?\b', t)
    if m: return int(m.group(1), 0)
    if re.search(r'\b(bit\s*(flags?|fields?|masks?|count)|flags?|bits|bitwise|bool(ean)?|byte|bcd|lower4|upper4|nibble|ascii|char)\b', t): return 1
    if re.search(r'\b(word|short|half)\b', t) and 'dword' not in t: return 2
    if re.search(r'\b(dword|long|int|float|pointer|ptr|address)\b', t): return 4
    if re.search(r'\b(double|qword)\b', t): return 8
    return None

def note_to_label(text):
    """First line of a code note -> a short CamelCase name, and the size if the note gives one."""
    first = text.splitlines()[0] if text else ''
    size = 1; found = False
    for m in TAG_RX.finditer(first):
        z = tag_size(m.group(1))
        if z and not found: size = z; found = True
    first = TAG_RX.sub(lambda m: '' if tag_size(m.group(1)) else m.group(0), first)
    first = next((x for x in re.split(r'[:=(]', first) if re.search(r'[A-Za-z0-9]', x)), '')
    words = re.findall(r'[A-Za-z0-9]+', first)[:5]
    name = ''.join(w[:1].upper() + w[1:] for w in words) or 'Note'
    if name[0].isdigit(): name = 'N' + name
    return name, size

def create(projects_dir, rom_path, platform_key, info, seed_key=None):
    h = hashlib.sha1(str(Path(rom_path).resolve()).encode()).hexdigest()[:6]
    pid = f'{slug(info)}-{h}'
    p = Path(projects_dir) / f'{pid}.romx.json'
    if p.exists(): return load(p)
    d = {'id': pid, 'game': info, 'platform': platform_key, 'rom': str(rom_path)}
    seed = SEEDS / f'{seed_key}.json' if seed_key else None
    if seed and seed.exists():
        s = json.loads(seed.read_text(encoding='utf-8')); d.update({k: s[k] for k in ('game', 'labels', 'funcs', 'enums', 'ra_game_id') if k in s})
    proj = Project(p, d); proj.save(); return proj

def load(p):
    return Project(p, json.loads(Path(p).read_text(encoding='utf-8')))

def all_projects(projects_dir):
    out = []
    for p in sorted(Path(projects_dir).glob('*.romx.json')):
        try: out.append(load(p))
        except (OSError, ValueError, KeyError): pass
    return out

VAL_RX = re.compile(r'^\s*(0x[0-9a-fA-F]+|\d+)\s*[=:]\s*(.+?)\s*$')
def note_values(text):
    """Lines like '0x02 = Gold' or '2=Gold' in a note -> {'2': 'Gold'}. Repeated values are joined with ' / '."""
    out = {}
    for line in text.splitlines()[1:]:
        m = VAL_RX.match(line)
        if m:
            k = str(int(m.group(1), 0)); v = m.group(2)
            out[k] = v if k not in out or out[k] == v else f'{out[k]} / {v}'
    return out

ADDR_LINE = re.compile(r'^\s*(0x[0-9a-fA-F]{2,8})\s*$')
def parse_pasted_notes(text):
    """Text copied from a game's Code Notes page on retroachievements.org -> [{'Address', 'Note'}]."""
    out = []; cur = None; buf = []
    def flush():
        if cur is not None and any(l.strip() for l in buf):
            out.append({'Address': cur, 'Note': '\n'.join(l.rstrip() for l in buf).strip()})
    for line in text.splitlines():
        m = ADDR_LINE.match(line.replace('\t', ' '))
        if m:
            flush(); cur = m.group(1); buf = []; continue
        if cur is None: continue
        if line.strip() in ('Edit', 'Delete') or re.match(r'^\s*Edit\s*$', line): flush(); cur = None; buf = []; continue
        buf.append(line.replace('\t', ' '))
    flush()
    return out

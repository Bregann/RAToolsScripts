"""Turns a platform's raw analysis plus a project's names and notes into the data the UI shows."""
from . import progress as PG
import re, struct, collections

def clean(s):
    return s.decode('latin1').replace('\xff', ' / ').replace('|', '').replace('\xa6', '').strip()

def looks_like_words(s):
    letters = [c for c in s if 65 <= c <= 90 or 97 <= c <= 122]
    if len(set(letters)) < 3: return False
    top = collections.Counter(s).most_common(1)[0][1]
    return top <= len(s) * 0.4 and any(c in b'AEIOUYaeiouy' for c in s)

def find_text(img, fmt='<I'):
    """Strings in the image and the pointer tables that point at them."""
    D = img.data; base = img.base; N = len(D)
    def str_at(a):
        o = img.off(a)
        if o is None: return None
        e = D.find(b'\x00', o, o + 300)
        if e <= o: return None
        s = D[o:e]
        if all(0x20 <= c < 0x7f or c >= 0xa0 for c in s) and any(65 <= c <= 90 or 97 <= c <= 122 for c in s): return clean(s)
    TEXT = {}
    for m in re.finditer(rb'[A-Za-z0-9 ,.\'!?:\-|\xa6\xff&%/()]{8,}\x00', D):
        s = m.group(0)[:-1]
        if sum(65 <= c <= 90 or 97 <= c <= 122 for c in s) >= len(s) * 0.5 and looks_like_words(s):
            TEXT[base + m.start()] = clean(s)
    TABLES = []; o = 0
    while o < N - 4:
        n = 0; ents = []
        while o + 4 * n < N - 4:
            v = struct.unpack_from(fmt, D, o + 4 * n)[0]
            s = str_at(v)
            if s is None: break
            ents.append(v); n += 1
        if n >= 4:
            for v in ents: TEXT.setdefault(v, str_at(v))
            TABLES.append({'a': base + o, 'n': n, 'e': ents}); o += 4 * n
        else: o += 4
    for t in TABLES:
        t['name'] = f'text list "{TEXT[t["e"][0]][:28]}…" ({t["n"]} entries)'
    return TEXT, TABLES

def build(P, img, F, project):
    """P: platform module, img: loaded image, F: {start: raw function}, project: Project."""
    own = {l['ra'] for l in project.labels}
    builtin = [l for l in (P.builtin_labels(img) if hasattr(P, 'builtin_labels') else []) if l['ra'] not in own]
    labels = sorted(project.labels + builtin, key=lambda l: l['ra'])
    names = {int(k, 16): v for k, v in project.funcs.items()}
    enums = {k: {int(v, 0) if isinstance(v, str) else v: t for v, t in e.items()} for k, e in project.enums.items()}
    canon = P.canon if hasattr(P, 'canon') else (lambda r: r)   # e.g. GB echo RAM 0xE000-0xFDFF is the same memory as 0xC000
    def lab(r):
        hits = [(l['size'], l['ra'], l['name']) for l in labels if canon(l['ra']) <= r < canon(l['ra']) + max(1, l['size'])]
        if not hits: return None
        sz, a, n = min(hits); return n if r == a else f'{n}+0x{r - a:X}'
    def fname(a):
        if a in names and names[a].get('name'): return names[a]['name']
        if a in F and F[a].get('auto') and F[a]['auto'][0]: return F[a]['auto'][0]
        return P.sub_name(a) if hasattr(P, 'sub_name') else f'sub_{a:08X}'
    PG.say('Looking for text in the game…')
    TEXT, TABLES = P.find_text(img) if hasattr(P, 'find_text') else find_text(img, getattr(P, 'PTR_FMT', '<I'))
    PG.say(f'Found {len(TEXT):,} text string{"" if len(TEXT) == 1 else "s"}' + (f' and {len(TABLES):,} list{"" if len(TABLES) == 1 else "s"} of text' if TABLES else '') + '.')
    is_text = lambda r: P.bus(r) in TEXT  # a pointer to a string inside the executable is text, not a variable
    xr = {}
    for k, f in F.items():
        f['refs'] = [rf for rf in f['refs'] if not is_text(rf['ra'])]
        for rf in f['refs']:
            xr.setdefault(rf['ra'], set()).add((k, rf['at'], rf['rw']))
    addrs = [{'ra': r, 'bus': P.bus(r), 'label': lab(r), 'n': len(x), 'x': sorted(list(t) for t in x)} for r, x in xr.items()]
    addrs.sort(key=lambda d: d['ra'])
    TAB_AT = {}
    for ti, t in enumerate(TABLES):
        for k in range(t['n']): TAB_AT[t['a'] + t.get('step', 4) * k] = (ti, k)
    EXACT = {}
    funcs = []
    keys = sorted(F)
    for fi, k in enumerate(keys):
        PG.count(fi + 1, len(keys), 'functions explained')
        f = F[k]
        pool = P.pool(f) if hasattr(P, 'pool') else set()
        def tlook(v, k_func=k):
            if v in TAB_AT:
                ti, e = TAB_AT[v]; t = TABLES[ti]
                if e: EXACT.setdefault(t['e'][e], set()).add(k_func)
                return (ti, f'text "{TEXT[t["e"][e]]}"' if e else t['name'])
            if v not in TEXT and hasattr(P, 'text_at'):
                s_ = P.text_at(img, v)
                if s_: TEXT[v] = s_
            if v in TEXT:  # code points straight at a string (common on PS1)
                EXACT.setdefault(v, set()).add(k_func)
                return (None, f'text "{TEXT[v]}"')
            return None
        tr, L = P.translate(f['ins'], lab, fname, pool, tlook, enums)
        lines = []
        for l in f['ins']:
            if l['a'] in L: lines.append([l['a'], '', '', 'label', L[l['a']]])
            if l['a'] in pool:
                if l['a'] % 4 == 0:
                    o = img.off(l['a']); v = int.from_bytes(img.data[o:o + 4], 'big' if getattr(P, 'PTR_FMT', '<I').startswith('>') else 'little')
                    lines.append([l['a'], f'.word 0x{v:08X}', 'literal pool', 'pool', 'Data (a constant the code above loads)'])
                continue
            c = ''
            if 'lit' in l:
                v = l['lit']; r = P.ra(v)
                c = f'0x{v:08X}' + (f'  RA 0x{r:06X}' + (f'  {lab(r)}' if lab(r) else '') if r is not None else '')
            if 'call' in l: c = fname(l['call'])
            kd, pl = tr.get(l['a'], ('misc', None))
            lines.append([l['a'], l['t'], c, kd, pl or ''])
        ftabs = sorted({TAB_AT[l['lit']][0] for l in f['ins'] if 'lit' in l and l['lit'] in TAB_AT})
        for ti in ftabs: TABLES[ti].setdefault('fns', []).append(k)
        note = names.get(k, {}).get('note', '') or (f.get('auto') or ('', ''))[1]
        funcs.append({'tabs': ftabs, 'a': k, 'name': fname(k), 'note': note, 'fmt': P.fmt(k) if hasattr(P, 'fmt') else None,
                      'callers': f['callers'], 'ptr': f.get('ptrrefs', []), 'callees': f['callees'],
                      'refs': sorted({r['ra'] for r in f['refs']}), 'lines': lines})
    return {'regions': getattr(img, 'region_names', None), 'pkey': P.KEY, 'enums': project.enums, 'ra_game_id': project.ra_game_id, 'project': project.id, 'rom': project.game or img.info, 'platform': P.NAME, 'busname': P.BUS, 'cpu': P.CPU, 'ra_ranges': getattr(P, 'RA_RANGES', None),
            'labels': [dict(l, bus=P.bus(l['ra']), region=P.mem_region(l['ra']), match=canon(l['ra'])) for l in labels],
            'addrs': addrs, 'funcs': funcs, 'text': sorted([a, s] for a, s in TEXT.items()),
            'exact': {str(a): sorted(v) for a, v in EXACT.items()},
            'tables': [{'a': t['a'], 'n': t['n'], 'name': t['name'], 'e': t['e'], 'fns': t.get('fns', [])} for t in TABLES]}

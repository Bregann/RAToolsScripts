"""ROM Explorer as an MCP server, so Claude (the desktop app, or Claude Code) can explore a game with you.
Speaks MCP over stdin/stdout (newline-delimited JSON-RPC). Run:  python -m romx --mcp
It uses the same settings, projects and save states as the web UI, and edits made here show up there."""
import json, re, sys, time, traceback
from . import server as SV, settings as S, project as PR, statestore as SS, states as STS
from .platforms import BY_KEY

VERSION = '1.0'
OUT = sys.stdout

def h(v, w=6): return f'0x{v:0{w}X}'

# ---------------- helpers ----------------
def proj_id(q):
    """Accept a project id, a game name or part of one. With one project, it's used by default."""
    ps = PR.all_projects(S.load()['projects_dir'])
    if not ps: raise ValueError('No projects yet. Use open_game with the path of a ROM or disc image first.')
    if not q:
        if len(ps) == 1: return ps[0].id
        raise ValueError('Which project? ' + ', '.join(f'{p.id} ({p.game})' for p in ps))
    for p in ps:
        if p.id == q: return p.id
    ql = str(q).lower()
    hits = [p for p in ps if ql in p.id.lower() or ql in (p.game or '').lower()]
    if len(hits) == 1: return hits[0].id
    if not hits: raise ValueError(f'No project matches "{q}". Projects: ' + ', '.join(f'{p.id} ({p.game})' for p in ps))
    raise ValueError(f'"{q}" matches several projects: ' + ', '.join(f'{p.id} ({p.game})' for p in hits))

def ctx(q):
    pid = proj_id(q); d = SV.data(pid); proj = SV.get_project(pid); a = SV.analysis(proj)
    return pid, d, proj, a['P']

def num(s):
    if isinstance(s, int): return s
    s = str(s).strip().replace('_', '')
    if re.fullmatch(r'[0-9A-Fa-f]{2}:[0-9A-Fa-f]{4}', s): b, a = s.split(':'); return (int(b, 16) << 16) | int(a, 16)   # GB bank:address
    m = re.fullmatch(r'(arm7|ov(\d+)):(?:0x)?([0-9A-Fa-f]+)', s, re.I)                                                    # DS region:address
    if m: return ((1 if m.group(1).lower() == 'arm7' else 2 + int(m.group(2))) << 32) | int(m.group(3), 16)
    if s.lower().startswith('0x'): return int(s, 16)
    if re.fullmatch(r'\d+', s) and len(s) < 6: return int(s)
    return int(s, 16)

def fa(d, P, a):
    """Address as shown to people: console address, plus RA address when the code sits in RA-visible RAM."""
    if d['pkey'] == 'gb': return f'{a >> 16:02X}:{a & 0xFFFF:04X}'
    if d['pkey'] == 'nds' and a >> 32: return f'{(d["regions"] or [])[a >> 32] if a >> 32 < len(d["regions"] or []) else a >> 32}:{a & 0xFFFFFFFF:08X}'
    r = P.ra(a & 0xFFFFFFFF) if d['pkey'] not in ('gb',) else None
    return f'{a:08X}' + (f' (RA {h(r)})' if r is not None and r != a else '')

def func_index(d): return {f['a']: f for f in d['funcs']}

def find_func(d, P, q):
    F = func_index(d); ql = str(q).strip()
    for f in d['funcs']:
        if f['name'].lower() == ql.lower(): return f
    try: v = num(ql.replace('sub_', '').replace('FUN_', ''))
    except ValueError: v = None
    if v is None:
        hits = [f for f in d['funcs'] if ql.lower() in f['name'].lower()]
        if len(hits) == 1: return hits[0]
        raise ValueError(f'No function called "{q}".' + (' Close: ' + ', '.join(f['name'] for f in hits[:10]) if hits else ''))
    for cand in (v, P.bus(v) if hasattr(P, 'bus') and d['pkey'] != 'gb' else None):
        if cand in F: return F[cand]
    best = None   # an address inside a function
    for f in d['funcs']:
        if f['a'] <= v and (best is None or f['a'] > best['a']) and any(l[0] >= v for l in f['lines']): best = f
    if best: return best
    raise ValueError(f'No function at {q}.')

def container(d, a):
    best = None
    for f in d['funcs']:
        if f['a'] <= a and (best is None or f['a'] > best['a']): best = f
    return best

def label_for(d, ra):
    for l in d['labels']:
        m0 = l.get('match', l['ra'])
        if m0 <= ra < m0 + max(1, l['size']): return l
    return None

def ra_name(d, ra):
    l = label_for(d, ra)
    if not l: return h(ra)
    off = ra - l.get('match', l['ra'])
    return f'{l["name"]}{f"+0x{off:X}" if off else ""} ({h(ra)})'

def text_users(d, a):
    users = set(d['exact'].get(str(a), []))
    for t in d['tables']:
        if a in t['e']: users |= set(t['fns'])
    return users

# ---------------- tools ----------------
def t_list_projects(args):
    st = SV.state()
    if not st['projects']: return 'No projects yet. Use open_game with the path of a ROM or disc image.'
    return '\n'.join(f'- {p["id"]}: {p["game"]} [{p["platform"]}] {p["named"]} named functions, {p["labels"]} labels'
                     + (f', RA game {p["ra_game_id"]}' if p['ra_game_id'] else '') + (' (game file missing)' if p['missing'] else '') for p in st['projects'])

def t_list_games(args):
    g = SV.games(); q = (args.get('filter') or '').lower()
    g = [x for x in g if q in x['name'].lower()]
    if not g: return 'No games found in the game folders set in ROM Explorer\'s Settings.' if not q else 'No games match.'
    return '\n'.join(f'- {x["path"]}' for x in g[:100]) + (f'\n... {len(g) - 100} more' if len(g) > 100 else '')

def t_open_game(args):
    r = SV.open_game(args['path']); pid = r['id']; d = SV.data(pid)
    return f'Opened. Project id: {pid}\n' + t_summary({'project': pid})

def t_summary(args):
    pid, d, proj, P = ctx(args.get('project'))
    named = [f for f in d['funcs'] if not re.match(r'sub_', f['name'])]
    sts = SS.listing(proj)
    out = [f'# {d["rom"]}', f'Platform: {d["platform"]} ({d["cpu"]}). Project id: {pid}.' + (f' RetroAchievements game {d["ra_game_id"]}.' if d['ra_game_id'] else ''),
           f'{len(d["funcs"])} functions ({len(named)} named), {len(d["addrs"])} RAM addresses used by the code, {len(d["labels"])} labels, {len(d["text"])} text strings, {len(sts)} save states.',
           f'Ghidra decompiled C: {"available" if d.get("ghidra") else "not run yet"}.',
           'RAM addresses are RetroAchievements addresses. Function addresses are console addresses.', '', '## Labels']
    out += [f'- {h(l["ra"])} {l["name"]} ({l["size"]} byte{"s" if l["size"] > 1 else ""}){": " + l["note"].splitlines()[0][:120] if l.get("note") else ""}' for l in d['labels']] or ['(none)']
    out += ['', '## Named functions'] + ([f'- {fa(d, P, f["a"])} {f["name"]}{": " + f["note"][:100] if f["note"] else ""}' for f in named[:80]] or ['(none)'])
    if len(named) > 80: out.append(f'... {len(named) - 80} more')
    if sts: out += ['', '## Save states'] + [f'- #{s["sid"]} {s["name"]}{": " + s["note"] if s.get("note") else ""}' for s in sts]
    return '\n'.join(out)

def t_search(args):
    pid, d, proj, P = ctx(args.get('project')); q = str(args['query']).strip(); ql = q.lower(); lim = int(args.get('limit') or 25)
    kinds = args.get('kind') or 'all'; out = []
    try: v = num(q)
    except ValueError: v = None
    if kinds in ('all', 'functions'):
        fs = [f for f in d['funcs'] if ql in f['name'].lower() or ql in (f['note'] or '').lower() or (v is not None and (f['a'] == v or P.bus(v) == f['a']))]
        if fs: out += [f'## Functions ({len(fs)})'] + [f'- {fa(d, P, f["a"])} {f["name"]}{": " + f["note"][:100] if f["note"] else ""}' for f in fs[:lim]]
    if kinds in ('all', 'addresses'):
        ls = [l for l in d['labels'] if ql in l['name'].lower() or ql in (l.get('note') or '').lower() or (v is not None and l['ra'] <= v < l['ra'] + l['size'])]
        if ls: out += [f'## Labels ({len(ls)})'] + [f'- {h(l["ra"])} {l["name"]}: {(l.get("note") or "").splitlines()[0][:120] if l.get("note") else ""}' for l in ls[:lim]]
        if v is not None:
            ad = [a for a in d['addrs'] if a['ra'] == v]
            if ad: out += [f'## RAM address {h(v)}: used {ad[0]["n"]} times by the code (get_address for details)']
    if kinds in ('all', 'text'):
        ts = [t for t in d['text'] if ql in t[1].lower()]
        if ts:
            F = func_index(d); out += [f'## Text ({len(ts)})']
            for a, s in ts[:lim]:
                us = sorted(text_users(d, a))
                out.append(f'- {fa(d, P, a)} "{s[:100]}"' + (f'  used by: {", ".join(F[u]["name"] for u in us[:5] if u in F)}' if us else ''))
    return '\n'.join(out) or f'Nothing matches "{q}".'

def t_list_functions(args):
    pid, d, proj, P = ctx(args.get('project')); which = args.get('which') or 'all'
    fs = d['funcs']
    if which == 'named': fs = [f for f in fs if not f['name'].startswith('sub_')]
    elif which == 'unnamed': fs = [f for f in fs if f['name'].startswith('sub_')]
    if args.get('touches'):
        r = num(args['touches']); fs = [f for f in fs if any(r <= x < r + int(args.get('size') or 1) for x in f['refs'])]
    order = args.get('sort') or 'address'
    if order == 'callers': fs = sorted(fs, key=lambda f: -(len(f['callers']) + len(f['ptr'])))
    elif order == 'size': fs = sorted(fs, key=lambda f: -len(f['lines']))
    off, lim = int(args.get('offset') or 0), int(args.get('limit') or 50)
    rows = [f'- {fa(d, P, f["a"])} {f["name"]}  ({len(f["callers"]) + len(f["ptr"])} callers, {len(f["lines"])} lines, {len(f["refs"])} RAM refs)'
            + (f': {f["note"][:80]}' if f['note'] else '') for f in fs[off:off + lim]]
    return f'{len(fs)} functions' + (f', showing {off + 1}-{off + len(rows)}' if len(fs) > lim else '') + ':\n' + '\n'.join(rows)

def t_get_function(args):
    pid, d, proj, P = ctx(args.get('project')); f = find_func(d, P, args['function']); F = func_index(d)
    view = args.get('view') or 'steps'
    callers = sorted({c['a'] for c in (container(d, x) for x in f['callers']) if c})
    out = [f'# {f["name"]}  at {fa(d, P, f["a"])}', f['note'] or '(no note)',
           'Called from: ' + (', '.join(F[c]['name'] for c in callers) or 'nothing found') + (f'; reached through {len(f["ptr"])} function pointer(s)' if f['ptr'] else ''),
           'Calls: ' + (', '.join(F[c]['name'] if c in F else fa(d, P, c) for c in f['callees']) or 'nothing'),
           'RAM it uses: ' + (', '.join(ra_name(d, r) for r in f['refs'][:40]) or 'none found') + (' ...' if len(f['refs']) > 40 else '')]
    if f['tabs']: out.append('Text lists it uses: ' + ', '.join(d['tables'][t]['name'] for t in f['tabs']))
    lim = int(args.get('max_lines') or 400)
    if view == 'c':
        try: r = SV.ghidra_func(pid, f['a'] & 0xFFFFFFFF)
        except FileNotFoundError as e: return '\n'.join(out) + f'\n\n{e} (run_ghidra starts it)'
        out += ['', '## Decompiled C (Ghidra)' + (f', part of {r["name"]}' if r.get('entry') not in (None, f['a'] & 0xFFFFFFFF) else ''), r['c'] or '(Ghidra has no function here)']
    elif view == 'instructions':
        out += ['', '## Every instruction (address | instruction | what it means)']
        for a, t, c, k, p in f['lines'][:lim]:
            if k == 'label': out.append(f'{p}:'); continue
            out.append(f'{fa(d, P, a).split(" ")[0]}  {t:<34} {p or ""}{"  [" + c + "]" if c and c not in (p or "") else ""}')
    else:
        out += ['', '## What it does (key steps)']
        for a, t, c, k, p in f['lines'][:lim * 2]:
            if k == 'label': out.append(f'{p}:'); continue
            if k in ('read', 'write', 'branch', 'call', 'text', 'addr', 'flow') and p: out.append(f'- {p}')
    if len(f['lines']) > lim and view != 'steps': out.append(f'... {len(f["lines"]) - lim} more lines (raise max_lines)')
    return '\n'.join(out)

def t_get_address(args):
    pid, d, proj, P = ctx(args.get('project')); r = num(args['address']); F = func_index(d)
    l = label_for(d, r); size = int(args.get('size') or (l['size'] if l and l['size'] in (1, 2, 4) else 1))
    m0 = l.get('match', l['ra']) if l else r; span = l['size'] if l else size
    users = [a for a in d['addrs'] if m0 <= a['ra'] < m0 + span]
    out = [f'# {l["name"] if l else "Unlabelled"}  RA {h(r)}  ({d["busname"]} 0x{P.bus(r):08X}, {P.mem_region(r) or "RAM"})']
    if l: out += [f'Size: {l["size"]} byte(s)', 'Note: ' + (l.get('note') or '(none)')]
    en = (d['enums'] or {}).get(l['name']) if l else None
    if en: out.append('Values: ' + ', '.join(f'{k} = {v}' for k, v in en.items()))
    xs = [(a['ra'], x) for a in users for x in a['x']]
    out.append(f'\n## Code that touches it ({len(xs)})')
    for ra_, (fn, at, rw) in xs[:80]:
        out.append(f'- {rw:<3} {ra_name(d, ra_) if ra_ != r else h(ra_)} in {F[fn]["name"] if fn in F else fa(d, P, fn)} at {fa(d, P, at).split(" ")[0]}')
    if not xs: out.append('No direct references (it may be reached through a pointer to a bigger block or struct).')
    sts = SS.listing(proj)
    if sts:
        vals = SS.values(proj, P, r, size)
        out.append(f'\n## In the save states ({size * 8}-bit)')
        out += [f'- #{v["sid"]} {v["name"]}: {v["value"]}' + (f' = {en.get(str(v["value"])) or en.get(v["value"])}' if en and (en.get(str(v["value"])) or en.get(v["value"])) else '') for v in vals]
    return '\n'.join(out)

def t_get_text(args):
    pid, d, proj, P = ctx(args.get('project')); F = func_index(d)
    q = str(args['text']).lower(); ts = [t for t in d['text'] if q in t[1].lower()]
    if not ts: return 'No text matches.'
    out = []
    for a, s in ts[:int(args.get('limit') or 20)]:
        us = sorted(text_users(d, a)); lists = [t['name'] for t in d['tables'] if a in t['e']]
        out.append(f'- {fa(d, P, a)} "{s}"' + (f'\n  in text list(s): {", ".join(lists[:3])}' if lists else '') + (f'\n  used by: {", ".join(F[u]["name"] for u in us if u in F)}' if us else '\n  no code found that uses it directly'))
    return '\n'.join(out)

def t_rename_function(args):
    pid, d, proj, P = ctx(args.get('project')); f = find_func(d, P, args['function'])
    note = args.get('note'); note = f['note'] if note is None and not f['name'].startswith('sub_') else (note or '')
    SV.edit({'id': pid, 'kind': 'func', 'addr': f['a'], 'name': args['name'], 'note': note})
    if not args['name']: return f'Removed the name of {f["name"]} at {fa(d, P, f["a"])}.'
    return f'Renamed {f["name"]} at {fa(d, P, f["a"])} to {args["name"]}.' + (f' Note: {note}' if note else '')

def t_set_label(args):
    pid, d, proj, P = ctx(args.get('project')); r = num(args['address'])
    l = next((x for x in proj.labels if x['ra'] == r), None)
    b = {'id': pid, 'kind': 'label', 'ra': r, 'name': args['name'], 'size': args.get('size') or (l['size'] if l else 1), 'note': args.get('note') if args.get('note') is not None else (l.get('note', '') if l else '')}
    if args.get('values'): b['values'] = '\n'.join(f'{k} = {v}' for k, v in args['values'].items()) if isinstance(args['values'], dict) else str(args['values'])
    SV.edit(b)
    return f'Labelled {h(r)} as {args["name"]}.' if args['name'] else f'Removed the label at {h(r)}.'

def t_set_project(args):
    pid, d, proj, P = ctx(args.get('project'))
    SV.edit({'id': pid, 'kind': 'project', 'game': args.get('game_name', proj.game), 'ra_game_id': args.get('ra_game_id', proj.ra_game_id)})
    return 'Project updated.'

def t_import_notes(args):
    pid = proj_id(args.get('project'))
    if args.get('text'): r = SV.paste_notes({'id': pid, 'text': args['text'], 'overwrite': args.get('overwrite')})
    else: r = SV.import_notes({'id': pid, 'ra_game_id': args.get('ra_game_id'), 'overwrite': args.get('overwrite')})
    return f'Code notes from {r["file"]}: {r["added"]} added, {r["updated"]} updated, {r["skipped"]} kept as they were.'

def t_export_notes(args):
    pid, d, proj, P = ctx(args.get('project'))
    return '\n'.join(f'0x{l["ra"]:06x}  {l.get("note") or l["name"]}'.replace('\n', '\n          ') for l in sorted(proj.labels, key=lambda l: l['ra'])) or 'No labels yet.'

def t_send_notes(args):
    from . import ranotes as RN
    pid = proj_id(args.get('project')); info = SV.ranotes_info(pid, args.get('folder'))
    if not info['game_id']: raise ValueError('Set the RetroAchievements game id first (set_project).')
    if not info['dir']: raise ValueError('No RACache folders found. Run Scan on ROM Explorer\'s Setup page.')
    if not args.get('confirm'):
        rows = info['rows']; c = lambda k: sum(1 for r in rows if r['status'] == k)
        return (f'RACache folder: {info["dir"]} (others: {", ".join(x for x in info["dirs"] if x != info["dir"]) or "none"})\n'
                f'{c("new")} labels aren\'t on RA yet, {c("changed")} differ from RA, {c("same")} are the same.\n'
                + '\n'.join(f'- {r["status"]}: 0x{r["ra"]:06X} {r["note"].splitlines()[0][:90]}' for r in rows if r['status'] != 'same')
                + '\nCall again with confirm true to write them (ask the user first; the emulator should be closed).')
    b = {'id': pid, 'dir': info['dir'], 'include': ['new', 'changed', 'same'] if args.get('addresses') else (['new', 'changed'] if args.get('include_changed') else ['new'])}
    if args.get('addresses'): b['addresses'] = [num(a) for a in args['addresses']]
    r = SV.ranotes_write(b)
    return f'Added {r["written"]} unpublished code notes to {r["file"]} (backup next to it). They show in RAIntegration\'s Code Notes window next time the game is loaded, ready to publish.'

def t_list_states(args):
    pid, d, proj, P = ctx(args.get('project')); sts = SS.listing(proj)
    out = [f'- #{s["sid"]} {s["name"]}' + (f': {s["note"]}' if s.get('note') else '') + f'  [{s["how"]}]' for s in sts] or ['No save states attached yet.']
    sug = SS.suggestions(S.load(), proj.rom)
    have = {s.get('source') for s in sts}
    sug = [x for x in sug if x['path'] not in have]
    if sug: out += ['', 'Recent state files in the save state folders (add_save_state with the path):'] + [f'- {x["path"]}' for x in sug[:15]]
    return '\n'.join(out)

def state_ids(proj, refs):
    sts = SS.listing(proj); out = []
    for r in refs:
        s = next((x for x in sts if str(x['sid']) == str(r).lstrip('#') or x['name'].lower() == str(r).lower()), None)
        if not s: raise ValueError(f'No save state "{r}". Have: ' + ', '.join(f'#{x["sid"]} {x["name"]}' for x in sts))
        out.append(s['sid'])
    return out

def t_add_state(args):
    pid = proj_id(args.get('project'))
    r = SV.states_add({'id': pid, 'path': args['path'], 'name': args.get('name'), 'note': args.get('note', '')})
    s = r['state']; return f'Added save state #{s["sid"]} "{s["name"]}" ({s["how"]}).'

def t_edit_state(args):
    pid, d, proj, P = ctx(args.get('project')); sid = state_ids(proj, [args['state']])[0]
    act = args.get('action') or 'edit'
    SV.states_edit({'id': pid, 'sid': sid, 'action': act, 'name': args.get('name'), 'note': args.get('note')})
    return {'remove': 'Removed.', 'reread': 'Read the file again.'}.get(act, 'Updated.')

REL = {'any': 'any', 'same': 'eq', 'changed': 'ne', 'up': 'gt', 'down': 'lt', 'up_by': 'inc', 'down_by': 'dec'}
def t_compare(args):
    pid, d, proj, P = ctx(args.get('project')); sids = state_ids(proj, args['states'])
    size = {8: 1, 16: 2, 32: 4, 1: 1, 2: 2, 4: 4}[int(args.get('bits') or 8)]
    rules = args.get('rules') or []
    steps = []
    for i in range(len(sids)):
        ru = rules[i] if i < len(rules) else {}
        steps.append({'rel': REL.get(ru.get('compare', 'any'), 'any'), 'by': ru.get('by'), 'value': ru.get('value')})
    r = SV.states_compare({'id': pid, 'sids': sids, 'size': size, 'steps': steps, 'only_code': bool(args.get('only_code_addresses'))})
    F = func_index(d); byra = {a['ra']: a for a in d['addrs']}
    lim = int(args.get('limit') or 60)
    out = [f'{r["count"]} address(es) match.' + (f' Showing {lim}.' if r['count'] > lim else '')]
    for ra, vs in r['rows'][:lim]:
        x = [t for k in range(size) for t in (byra.get(ra + k) or {'x': []})['x']]
        fns = sorted({F[t[0]]['name'] for t in x if t[0] in F})
        out.append(f'- {ra_name(d, ra)}: ' + ' -> '.join(str(v) for v in vs) + (f'  (code: {", ".join(fns[:4])}{" +" + str(len(fns) - 4) if len(fns) > 4 else ""})' if fns else ''))
    return '\n'.join(out)

def t_read_memory(args):
    pid, d, proj, P = ctx(args.get('project')); sid = state_ids(proj, [args['state']])[0]
    m = SS.mem(proj, sid); a = num(args['address']); n = min(int(args.get('length') or 64), 1024)
    out = []
    for o in range(a, a + n, 16):
        row = m[o:min(o + 16, a + n)]
        out.append(f'{h(o)}  ' + ' '.join(f'{b:02X}' for b in row) + '  ' + ''.join(chr(b) if 32 <= b < 127 else '.' for b in row))
    return '\n'.join(out)

def t_run_ghidra(args):
    pid = proj_id(args.get('project'))
    st = SV.ghidra_status(pid) if args.get('status_only') else SV.ghidra_run({'id': pid})
    return f'Ghidra: {st.get("state")}. {st.get("msg", "")}' + (f' ({st["elapsed"]}s so far)' if st.get('elapsed') else '') + (f'\n{st["log"]}' if st.get('log') and st.get('state') == 'error' else '')

P_ = {'project': {'type': 'string', 'description': 'Project id or game name. Can be left out when there is only one project.'}}
def tool(name, desc, props=None, req=()):
    return {'name': name, 'description': desc, 'inputSchema': {'type': 'object', 'properties': dict(P_, **(props or {})), 'required': list(req)}}
S_ = lambda d: {'type': 'string', 'description': d}
# ---------------- live emulator ----------------
LIVE = {}   # the one live connection: {'pid', 'session'}
def live(args=None, need=True):
    s = LIVE.get('session')
    if need and not s: raise ValueError('Not connected to an emulator. Use live_connect first (say which emulator).')
    return s
def live_ctx():
    s = live(); pid = LIVE['pid']; d = SV.data(pid); proj = SV.get_project(pid); return s, pid, d, proj, s.P

def t_live_connect(args):
    from .live import Session, LiveError
    pid, d, proj, P = ctx(args.get('project')); a = SV.analysis(proj)
    old = LIVE.get('session')
    if old: old.close(); LIVE.clear()
    try:
        s = Session(args['emulator'], P, a['img'], args.get('host') or '127.0.0.1', args.get('port'), args.get('gdb_port'), '\n'.join(S.load().get('live_keys') or []) if isinstance(S.load().get('live_keys'), list) else S.load().get('live_keys', ''))
    except LiveError as e: raise ValueError(str(e))
    LIVE.update(pid=pid, session=s)
    return f'{s.describe()} Project: {d["rom"]}.'

def t_live_disconnect(args):
    s = live(need=False)
    if s: s.close(); LIVE.clear(); return 'Disconnected. The emulator keeps running.'
    return 'Wasn\'t connected.'

def _vals(d, data, bits, big):
    n = bits // 8; out = []
    for o in range(0, len(data) - n + 1, n): out.append(int.from_bytes(data[o:o + n], 'big' if big else 'little'))
    return out

def t_live_read(args):
    from .live import LiveError
    s, pid, d, proj, P = live_ctx(); r = num(args['address'])
    l = label_for(d, r); bits = int(args.get('bits') or (l['size'] * 8 if l and l['size'] in (1, 2, 4) and not args.get('length') else 8))
    n = int(args.get('length') or bits // 8); n = min(n, 4096)
    try: data = s.read(r, n)
    except LiveError as e: raise ValueError(str(e))
    if n <= 16 and n == bits // 8:
        v = _vals(d, data, bits, s.big)[0]; en = (d['enums'] or {}).get(l['name']) if l and l['ra'] == r else None
        name = en.get(str(v)) if en else None
        return f'{ra_name(d, r)} = {v} (0x{v:0{n * 2}X})' + (f' = {name}' if name else '')
    rows = [f'{h(o)}  ' + ' '.join(f'{b:02X}' for b in data[o - r:o - r + 16]) for o in range(r, r + n, 16)]
    return '\n'.join(rows)

def t_live_write(args):
    from .live import LiveError
    s, pid, d, proj, P = live_ctx(); r = num(args['address'])
    if args.get('hex'): data = bytes.fromhex(str(args['hex']).replace(' ', ''))
    else:
        bits = int(args.get('bits') or 8); data = int(args['value']).to_bytes(bits // 8, 'big' if s.big else 'little')
    try: s.write(r, data)
    except LiveError as e: raise ValueError(str(e))
    return f'Wrote {data.hex(" ").upper()} to {ra_name(d, r)}.'

def explain_pc(d, P, pc):
    """Which function a PC is in, and the plain-English line for the instruction there (or the store just before it)."""
    if pc is None: return 'no instruction address (this link can only see that the value changed)'
    f = container(d, pc)
    if not f: return f'PC {pc:08X}, outside the functions ROM Explorer found'
    near = [l for l in f['lines'] if l[3] != 'label' and pc - 8 <= l[0] <= pc]
    pick = next((l for l in reversed(near) if l[3] == 'write'), None) or (near[-1] if near else None)
    line = f'\n  {pick[0]:08X}  {pick[1]}    {pick[4]}' if pick else ''
    return f'in {f["name"]} ({fa(d, P, f["a"])}), PC {pc:08X}{line}'

def t_live_watch(args):
    from .live import LiveError
    s, pid, d, proj, P = live_ctx(); r = num(args['address'])
    l = label_for(d, r); size = int(args.get('bits') or (l['size'] * 8 if l and l['size'] in (1, 2, 4) else 8)) // 8
    mode = args.get('mode') or 'write'; secs = min(float(args.get('seconds') or 30), 45)   # tool calls time out after about a minute
    try: hit = s.watch(r, size, mode, secs)
    except LiveError as e: raise ValueError(str(e))
    if not hit: return f'Nothing {"wrote to" if mode in ("write", "change") else "touched"} {ra_name(d, r)} in {secs:g} seconds. (Do the thing in the game while this waits, or give more seconds.)'
    ov = int.from_bytes(hit['old'], 'big' if s.big else 'little'); nv = int.from_bytes(hit['new'], 'big' if s.big else 'little')
    out = (f'{ra_name(d, r)} is {ov}, stopped on the instruction about to change it, ' if ov == nv and hit.get('exact') else f'{ra_name(d, r)}: {ov} -> {nv}, ') + explain_pc(d, P, hit.get('pc'))
    if hit.get('exact'): out += '\nThe game is paused there. live_resume to carry on, or live_registers / live_step to look closer.'
    else:
        out += f' (after {hit.get("after")}s)'
        if s.emu == 'mgba': out += '\nTo find the exact instruction that writes it, start mGBA\'s GDB server (Tools > Start GDB server) and use live_connect with emulator mgba and gdb_port 2345 (the game runs slower while it\'s on).'
    return out

def t_live_break(args):
    from .live import LiveError
    s, pid, d, proj, P = live_ctx()
    q = str(args['function']); f = None
    try: f = find_func(d, P, q); a = f['a']
    except ValueError: a = num(q)
    if args.get('address'): a = num(args['address'])
    try: hit = s.run_to(a & 0xFFFFFFFF, min(float(args.get('seconds') or 30), 45))
    except LiveError as e: raise ValueError(str(e))
    if not hit: return f'{f["name"] if f else hex(a)} didn\'t run in {args.get("seconds") or 30} seconds.'
    regs = ''
    try:
        R = s.registers(); keys = {'mips': ['a0', 'a1', 'a2', 'a3', 'v0', 'ra', 'sp'], 'arm': ['r0', 'r1', 'r2', 'r3', 'lr', 'sp'], 'ppc': ['r3', 'r4', 'r5', 'r6', 'lr', 'r1']}
        from .live import ARCH
        regs = '\nRegisters: ' + ', '.join(f'{k}=0x{R[k]:X}' for k in keys.get(ARCH.get(P.KEY), []) if k in R)
    except Exception: pass
    return f'Stopped at {explain_pc(d, P, hit["pc"])}.{regs}\nThe game is paused. live_resume to carry on.'

def t_live_pause(args):
    from .live import LiveError
    s = live()
    try:
        if args.get('resume'): s.resume(); return 'Running.'
        s.pause()
    except LiveError as e: raise ValueError(str(e))
    try: pc = s.pc(); _, pid, d, proj, P = live_ctx(); return 'Paused ' + explain_pc(d, P, pc) + '.'
    except Exception: return 'Paused.'

def t_live_resume(args): return t_live_pause({'resume': True})

def t_live_step(args):
    from .live import LiveError
    s, pid, d, proj, P = live_ctx(); n = max(1, min(int(args.get('count') or 1), 2000))
    try: pc = s.step(n)
    except LiveError as e: raise ValueError(str(e))
    return f'Stepped {n} frame(s).' if pc is None else f'Stepped {n}. Now ' + explain_pc(d, P, pc) + '.'

def t_live_registers(args):
    from .live import LiveError
    s, pid, d, proj, P = live_ctx()
    try: R = s.registers()
    except LiveError as e: raise ValueError(str(e))
    out = []
    for k, v in R.items():
        r = P.ra(v) if isinstance(v, int) else None
        out.append(f'{k} = 0x{v:X}' + (f'  ({ra_name(d, r)})' if r is not None and label_for(d, r) else ''))
    return '\n'.join(out)

def t_live_state(args):
    from .live import LiveError
    s = live(); slot = int(args.get('slot') if args.get('slot') is not None else 1)
    try:
        if args.get('action') == 'load': s.load_state(slot); return f'Loaded state slot {slot}.'
        s.save_state(slot); return f'Saved state to slot {slot}' + (' (RetroArch saves to its currently selected slot).' if s.emu == 'retroarch' else '.')
    except LiveError as e: raise ValueError(str(e))

def t_live_snapshot(args):
    from .live import LiveError
    s, pid, d, proj, P = live_ctx()
    try: mem = s.snapshot()
    except LiveError as e: raise ValueError(str(e))
    st = SS.add_memory(proj, mem, args.get('name') or f'live {time.strftime("%H:%M:%S")}', args.get('note', ''), f'live from {s.emu}')
    return f'Saved the game\'s RAM as save state #{st["sid"]} "{st["name"]}". Use it in compare_save_states.'

def t_live_screenshot(args):
    import base64
    from .live import LiveError
    s = live()
    try: png = s.screenshot()
    except LiveError as e: raise ValueError(str(e))
    return {'content': [{'type': 'image', 'data': base64.b64encode(png).decode(), 'mimeType': 'image/png'}]}

def t_live_press(args):
    from .live import LiveError
    s = live(); b = args['buttons']; b = [x.strip() for x in (b.split('+') if isinstance(b, str) else b)]
    try: s.press(b, int(args.get('frames') or 6))
    except LiveError as e: raise ValueError(str(e))
    if args.get('wait_frames'): time.sleep(int(args['wait_frames']) / 60.0)
    return f'Pressed {"+".join(b)} for {int(args.get("frames") or 6)} frames.'

def t_live_sample(args):
    from .live import LiveError
    s, pid, d, proj, P = live_ctx(); addrs = [num(a) for a in args['addresses']][:16]
    secs = min(float(args.get('seconds') or 5), 45)
    floor = 0.25 if s.pauses_to_read else 0.016   # each read pauses the game on GDB links, so don't read too often
    every = max(floor, float(args.get('every_ms') or 250) / 1000)
    sizes = []
    for r in addrs:
        l = label_for(d, r); sizes.append(int(args.get('bits') or (l['size'] * 8 if l and l['size'] in (1, 2, 4) else 8)) // 8)
    last = [None] * len(addrs); out = []; t0 = time.time()
    while time.time() - t0 < secs and not cancelled():
        try: vals = s.read_many(list(zip(addrs, sizes)))
        except LiveError as e: raise ValueError(str(e))
        for i, r in enumerate(addrs):
            v = int.from_bytes(vals[i], 'big' if s.big else 'little')
            if v != last[i]: out.append(f'{time.time() - t0:6.2f}s  {ra_name(d, r)} = {v}'); last[i] = v
        time.sleep(every)
    note = f'\n(Read every {int(every * 1000)} ms' + (': each read briefly pauses this emulator, so faster would make it lag.)' if s.pauses_to_read else '.)')
    return '\n'.join(out[:400]) + (f'\n... {len(out) - 400} more changes' if len(out) > 400 else '') + ('\n(Stopped early.)' if cancelled() else '') + note

E_ = {'type': 'string', 'enum': ['retroarch', 'duckstation', 'pcsx2', 'ppsspp', 'mgba', 'melonds', 'dolphin', 'gdb']}
LIVE_TOOLS = [
    (tool('live_connect', 'Connect to the emulator running this game, to read and change RAM live, pause and step, set breakpoints and watchpoints, take screenshots and press buttons. '
          'retroarch: Network Commands on (port 55355). duckstation/mgba/melonds/dolphin: their GDB server on (DuckStation default 2345, mGBA 2345, melonDS 3333). '
          'pcsx2: PINE on (28011); add gdb_port if the build has a GDB server. ppsspp: Allow remote debugger on; give the port it shows. dolphin without a port reads its RAM directly (Windows).',
          {'emulator': E_, 'port': {'type': 'integer'}, 'host': S_('Default 127.0.0.1'), 'gdb_port': {'type': 'integer'}}, ['emulator']), t_live_connect),
    (tool('live_disconnect', 'Disconnect from the emulator.'), t_live_disconnect),
    (tool('live_read', 'Read RAM from the running game by RA address: one value (with its label and value name) or a hex dump with length.',
          {'address': S_('RA address'), 'bits': {'type': 'integer', 'enum': [8, 16, 32]}, 'length': {'type': 'integer'}}, ['address']), t_live_read),
    (tool('live_write', 'Change RAM in the running game (RA address): a value, or raw bytes as hex. Disables RetroAchievements hardcore in RetroArch.',
          {'address': S_('RA address'), 'value': {'type': 'integer'}, 'bits': {'type': 'integer', 'enum': [8, 16, 32]}, 'hex': S_('Bytes, e.g. "01 00"')}, ['address']), t_live_write),
    (tool('live_watch', 'Wait until the game writes (or reads) an RA address, while the user plays. With a debugger link (DuckStation, PPSSPP, mGBA, melonDS, GDB) it stops on the exact instruction and names the function; otherwise it reports when the value changed.',
          {'address': S_('RA address'), 'bits': {'type': 'integer', 'enum': [8, 16, 32]}, 'mode': {'type': 'string', 'enum': ['write', 'change', 'read', 'access']}, 'seconds': {'type': 'number'}}, ['address']), t_live_watch),
    (tool('live_break', 'Run until a function (name or address) is reached, then pause and show the arguments.', {'function': S_('Function name or console address'), 'seconds': {'type': 'number'}}, ['function']), t_live_break),
    (tool('live_pause', 'Pause the game.'), t_live_pause),
    (tool('live_resume', 'Resume the game.'), t_live_resume),
    (tool('live_step', 'Step instructions (debugger links) or frames (RetroArch).', {'count': {'type': 'integer'}}), t_live_step),
    (tool('live_registers', 'CPU registers of the paused game, with labels for ones pointing at labelled RAM.'), t_live_registers),
    (tool('live_state', 'Save or load an emulator save state slot.', {'action': {'type': 'string', 'enum': ['save', 'load']}, 'slot': {'type': 'integer'}}), t_live_state),
    (tool('live_snapshot', 'Copy the game\'s RAM right now into the project as a save state, ready for compare_save_states.', {'name': S_('Short name'), 'note': S_('What is going on, e.g. 2 lives')}), t_live_snapshot),
    (tool('live_screenshot', 'Screenshot of the game.'), t_live_screenshot),
    (tool('live_press', 'Press buttons in the game, e.g. "Start" or "Up+Cross", held for some frames. PPSSPP natively; others by typing the keys set in ROM Explorer Settings > Emulator keys (Windows).',
          {'buttons': S_('Button names joined with +'), 'frames': {'type': 'integer'}, 'wait_frames': {'type': 'integer', 'description': 'Frames to wait afterwards'}}, ['buttons']), t_live_press),
    (tool('live_sample', 'Record how RA addresses change over a few seconds while the user plays. On GDB links (mGBA, DuckStation, melonDS) each read briefly pauses the game, so it reads at most 4 times a second there; keep the address list short.', {'addresses': {'type': 'array', 'items': {'type': 'string'}}, 'seconds': {'type': 'number'}, 'every_ms': {'type': 'integer'}, 'bits': {'type': 'integer'}}, ['addresses']), t_live_sample),
]

TOOLS = [
    (tool('list_projects', 'List the games you have projects for in ROM Explorer.'), t_list_projects),
    (tool('list_games', 'List ROMs and disc images in the game folders from ROM Explorer\'s Settings.', {'filter': S_('Part of the file name')}), t_list_games),
    (tool('open_game', 'Open a ROM or disc image and create its project (GBA, GB/GBC, DS, PS1, PS2, PSP, GameCube/Wii).', {'path': S_('Full path to the game file')}, ['path']), t_open_game),
    (tool('project_summary', 'Overview of a game: platform, counts, every label and named function, save states. Start here.'), t_summary),
    (tool('search', 'Search functions, labels and text by name, note, string or address.', {'query': S_('Text or address'), 'kind': {'type': 'string', 'enum': ['all', 'functions', 'addresses', 'text']}, 'limit': {'type': 'integer'}}, ['query']), t_search),
    (tool('list_functions', 'List functions, optionally only named or unnamed ones, ones touching an RA address, sorted by address, number of callers or size.',
          {'which': {'type': 'string', 'enum': ['all', 'named', 'unnamed']}, 'touches': S_('RA address the function must read or write'), 'size': {'type': 'integer', 'description': 'Bytes from touches'},
           'sort': {'type': 'string', 'enum': ['address', 'callers', 'size']}, 'offset': {'type': 'integer'}, 'limit': {'type': 'integer'}}), t_list_functions),
    (tool('get_function', 'A function in plain English: callers, callees, RAM it uses, and its code as key steps, every instruction with an explanation, or Ghidra\'s decompiled C.',
          {'function': S_('Name, console address, RA address, or an address inside it'), 'view': {'type': 'string', 'enum': ['steps', 'instructions', 'c']}, 'max_lines': {'type': 'integer'}}, ['function']), t_get_function),
    (tool('get_address', 'Everything about a RAM address (RetroAchievements address): label, note, value names, every instruction that reads or writes it, and its value in each save state.',
          {'address': S_('RA address, e.g. 0x0274AA'), 'size': {'type': 'integer', 'description': '1, 2 or 4 bytes for save state values'}}, ['address']), t_get_address),
    (tool('get_text', 'Find text strings in the game and which text lists and functions use them.', {'text': S_('Part of the string'), 'limit': {'type': 'integer'}}, ['text']), t_get_text),
    (tool('rename_function', 'Name a function (and optionally add a note). Saved to the project; shows everywhere the function is called.',
          {'function': S_('Current name or address'), 'name': S_('New name, letters, numbers and underscores. Empty to remove.'), 'note': S_('What it does')}, ['function', 'name']), t_rename_function),
    (tool('set_label', 'Label a RAM address (RA address) with a name, size, note and value names. Saved to the project and used in all code explanations.',
          {'address': S_('RA address'), 'name': S_('Label name. Empty to remove.'), 'size': {'type': 'integer'}, 'note': S_('Code note text'),
           'values': {'type': 'object', 'description': 'Value names, e.g. {"0": "Bronze", "1": "Silver"}', 'additionalProperties': {'type': 'string'}}}, ['address', 'name']), t_set_label),
    (tool('set_project', 'Set the game name or RetroAchievements game id.', {'game_name': S_('Name'), 'ra_game_id': {'type': 'integer'}}), t_set_project),
    (tool('import_code_notes', 'Import RetroAchievements code notes: paste the text from the game\'s Code Notes page, or leave text out to read <id>-Notes.json from the emulator folders.',
          {'text': S_('Pasted code notes'), 'ra_game_id': {'type': 'integer'}, 'overwrite': {'type': 'boolean'}}), t_import_notes),
    (tool('export_code_notes', 'All labels as code-note text, by address.'), t_export_notes),
    (tool('send_notes_to_ra', 'Add the project\'s labels to RAIntegration as unpublished code notes (RACache\\Data\\<game id>-User.txt), so they can be published from the emulator\'s Code Notes window. Without confirm it only shows what would be written.',
          {'folder': S_('RACache\\Data folder (default: the emulator that has this game)'), 'include_changed': {'type': 'boolean', 'description': 'Also replace notes that differ from the published ones'},
           'addresses': {'type': 'array', 'items': {'type': 'string'}, 'description': 'Only these RA addresses (default: every label not on RA yet)'},
           'confirm': {'type': 'boolean', 'description': 'Actually write (ask the user first)'}}), t_send_notes),
    (tool('list_save_states', 'Save states attached to the project, and recent state files in the save state folders that could be added.'), t_list_states),
    (tool('add_save_state', 'Attach a save state file (or raw RAM dump) of this game to the project.', {'path': S_('Full path'), 'name': S_('Short name'), 'note': S_('What is going on in it, e.g. 3 lives')}, ['path']), t_add_state),
    (tool('edit_save_state', 'Rename or add a note to a save state, re-read it from its file after re-saving in the emulator, or remove it.',
          {'state': S_('State number or name'), 'action': {'type': 'string', 'enum': ['edit', 'reread', 'remove']}, 'name': S_('New name'), 'note': S_('Note')}, ['state']), t_edit_state),
    (tool('compare_save_states', 'Find RAM addresses by comparing save states, like the RetroAchievements memory inspector. Rules are per state, in order; each compares to the state before. Results show the code that uses each address.',
          {'states': {'type': 'array', 'items': {'type': 'string'}, 'description': 'State numbers or names, in order'}, 'bits': {'type': 'integer', 'enum': [8, 16, 32]},
           'rules': {'type': 'array', 'items': {'type': 'object', 'properties': {'compare': {'type': 'string', 'enum': list(REL)}, 'by': {'type': 'integer'}, 'value': {'type': 'integer'}}},
                     'description': 'One per state. compare: vs the state before (ignored for the first). value: the exact value in this state.'},
           'only_code_addresses': {'type': 'boolean', 'description': 'Only addresses the code reads or writes directly'}, 'limit': {'type': 'integer'}}, ['states']), t_compare),
    (tool('read_memory', 'Hex dump of RAM from a save state, by RA address.', {'state': S_('State number or name'), 'address': S_('RA address'), 'length': {'type': 'integer'}}, ['state', 'address']), t_read_memory),
    (tool('run_ghidra', 'Start Ghidra decompiling the game in the background (needs Ghidra set in Settings), or check on it. After it finishes, get_function with view c shows C.',
          {'status_only': {'type': 'boolean'}}), t_run_ghidra),
]
TOOLS += LIVE_TOOLS
HANDLERS = {t['name']: f for t, f in TOOLS}

INSTRUCTIONS = ('ROM Explorer analyses retro game ROMs and discs (GBA, Game Boy, DS, PS1, PS2, PSP, GameCube/Wii) for RetroAchievements work. '
                'Start with project_summary. RAM addresses are RetroAchievements addresses. When you work out what a function or address is, '
                'save it with rename_function or set_label so it shows in the code everywhere; tell the user what you named. '
                'To find an address, ask the user for save states that differ in that value and use compare_save_states with only_code_addresses, '
                'then get_address and get_function to confirm from the code. If the game is running in an emulator, live_connect gives live RAM, screenshots, '
                'buttons, and (with debugger links) watchpoints that stop on the instruction that writes an address.')

import threading, queue
CANCELLED = set(); CURRENT = {'id': None}
def cancelled(): return CURRENT['id'] is not None and CURRENT['id'] in CANCELLED

def send(msg): OUT.write(json.dumps(msg, ensure_ascii=False) + '\n'); OUT.flush()

def handle(req):
    m, rid = req.get('method'), req.get('id')
    if rid is None: return   # notification
    try:
        if m == 'initialize':
            pv = (req.get('params') or {}).get('protocolVersion') or '2025-06-18'
            res = {'protocolVersion': pv, 'capabilities': {'tools': {}}, 'serverInfo': {'name': 'rom-explorer', 'version': VERSION}, 'instructions': INSTRUCTIONS}
        elif m == 'ping': res = {}
        elif m == 'tools/list': res = {'tools': [t for t, _ in TOOLS]}
        elif m == 'tools/call':
            p = req.get('params') or {}; fn = HANDLERS.get(p.get('name'))
            if not fn: return send({'jsonrpc': '2.0', 'id': rid, 'error': {'code': -32602, 'message': f'Unknown tool {p.get("name")}'}})
            try:
                CURRENT['id'] = rid
                if LIVE.get('session'): LIVE['session'].should_stop = cancelled
                with SV.LOCK: text = fn(p.get('arguments') or {})
                res = text if isinstance(text, dict) else {'content': [{'type': 'text', 'text': text}]}
            except Exception as e:   # tool errors go back to Claude as text it can act on
                if not isinstance(e, (ValueError, KeyError, FileNotFoundError)): traceback.print_exc(file=sys.stderr)
                res = {'content': [{'type': 'text', 'text': str(e).strip("'") or type(e).__name__}], 'isError': True}
        elif m in ('resources/list',): res = {'resources': []}
        elif m in ('prompts/list',): res = {'prompts': []}
        else: return send({'jsonrpc': '2.0', 'id': rid, 'error': {'code': -32601, 'message': f'Method not found: {m}'}})
        send({'jsonrpc': '2.0', 'id': rid, 'result': res})
    except Exception as e:
        traceback.print_exc(file=sys.stderr)
        send({'jsonrpc': '2.0', 'id': rid, 'error': {'code': -32603, 'message': str(e)}})

def main():
    global OUT
    for st in (sys.stdin, sys.stdout):
        try: st.reconfigure(encoding='utf-8', newline='\n') if st is sys.stdout else st.reconfigure(encoding='utf-8')
        except (AttributeError, ValueError): pass
    OUT = sys.stdout; sys.stdout = sys.stderr   # anything else printed must not corrupt the protocol stream
    q = queue.Queue()
    def reader():
        for line in sys.stdin:
            line = line.strip()
            if not line: continue
            try: req = json.loads(line)
            except ValueError: continue
            for r in (req if isinstance(req, list) else [req]):
                if r.get('method') == 'notifications/cancelled':   # Claude stopped a tool call: let a long one finish early
                    CANCELLED.add((r.get('params') or {}).get('requestId'))
                else: q.put(r)
        q.put(None)
    threading.Thread(target=reader, daemon=True).start()
    while True:
        r = q.get()
        if r is None: break
        if r.get('id') in CANCELLED: continue
        handle(r)
        CURRENT['id'] = None

if __name__ == '__main__': main()

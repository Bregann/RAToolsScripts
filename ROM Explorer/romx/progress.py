"""Progress messages for long jobs (opening a game, analysing it), so the page can show what's happening.
Each request runs in its own thread; the page polls /api/progress?job=... from another one."""
import threading, time
JOBS = {}
_tl = threading.local()

def start(job):
    _tl.job = job
    if job:
        if job in JOBS and time.time() - JOBS[job]['t0'] < 3600: JOBS[job]['done'] = False   # a follow-on request of the same job
        else: JOBS[job] = {'lines': [], 'i': 0, 'n': 0, 'what': '', 't0': time.time(), 'done': False}
        for k in [k for k, v in JOBS.items() if v['done'] and time.time() - v['t0'] > 600]: JOBS.pop(k, None)

def _job():
    return JOBS.get(getattr(_tl, 'job', None))

def say(msg):
    j = _job()
    if j: j['lines'].append([round(time.time() - j['t0'], 1), msg]); j['i'] = j['n'] = 0; j['what'] = ''

def count(i, n, what=''):
    j = _job()
    if j and (i == n or i % 64 == 0): j['i'] = i; j['n'] = n; j['what'] = what

def end():
    j = _job()
    if j: j['done'] = True
    _tl.job = None

def get(job, since=0):
    j = JOBS.get(job)
    if not j: return {'lines': [], 'i': 0, 'n': 0, 'done': False, 'known': False}
    return {'lines': j['lines'][since:], 'i': j['i'], 'n': j['n'], 'what': j['what'], 'done': j['done'], 'known': True}

"""Supported consoles. Each module provides: NAME, KEY, BUS, CPU, detect(path, head), load(path),
analyze(img), translate(...), ra(bus_addr), bus(ra_addr), mem_region(ra_addr), and optionally pool(f), seed_key(img)."""
from . import gba, gb, nds, gcwii, psp, ps2, ps1
PLATFORMS = [gba, gb, nds, gcwii, psp, ps2, ps1]   # PSP first (its discs have PSP_GAME, its ELFs are Allegrex); PS2 before PS1 (BOOT2)
BY_KEY = {p.KEY: p for p in PLATFORMS}

def detect(path):
    try:
        with open(path, 'rb') as fh: head = fh.read(0x9400)
    except OSError:
        return None
    for p in PLATFORMS:
        if p.detect(str(path), head): return p
    return None

EXTS = tuple(e for p in PLATFORMS for e in p.EXTS)

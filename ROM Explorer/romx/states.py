"""Save states: pull the game's RAM out of an emulator save state (or a raw RAM dump) and lay it out by
RetroAchievements address, so states can be compared like RA's memory inspector.

How RAM is found:
  1. Unwrap the file: RetroArch's RASTATE container, gzip, zlib, zstd, zip (PCSX2 .p2s), PNG (mGBA), snappy.
  2. Find RAM inside it:
     - PS1, PS2, PSP, GameCube/Wii, DS: the game's own code sits in RAM, so the tool searches the state for
       pieces of the code it already knows and works out where RAM starts. This works whatever the emulator is.
     - GBA: mGBA's layout (RetroArch's mGBA core and mGBA itself).
     - Game Boy / Color: Gambatte's labelled layout (RetroArch's Gambatte core).
     - A raw RAM dump of exactly the console's RAM size is used as it is.
"""
import gzip, io, struct, zipfile, zlib
from collections import Counter

# RA memory size the tool keeps per console (main RAM plus anything RA puts right after it)
RA_SIZE = {'gba': 0x48000, 'gb': 0x18000, 'ps1': 0x200400, 'ps2': 0x2004000, 'psp': 0x2000000, 'gc': 0x1800000, 'nds': 0x400000}
BIG_ENDIAN = {'gc'}

# ---------------- unwrapping ----------------
def _zstd(b):
    try:
        import zstandard
        return zstandard.ZstdDecompressor().stream_reader(io.BytesIO(b)).read(0x8000000)
    except ImportError:
        from .platforms.nintendo_disc import zdec
        return zdec(b, 0x8000000)

def snappy_decompress(b, limit=0x8000000):
    """Raw snappy (as used by older PPSSPP states)."""
    n = s = 0
    for i in range(10):
        c = b[i]; n |= (c & 0x7F) << (7 * i)
        if not c & 0x80: s = i + 1; break
    if not 0 < n <= limit: raise ValueError('not snappy')
    out = bytearray(); p = s; L = len(b)
    while p < L and len(out) < n:
        t = b[p]; k = t & 3
        if k == 0:
            ln = t >> 2
            if ln >= 60:
                nb = ln - 59; ln = int.from_bytes(b[p + 1:p + 1 + nb], 'little'); p += nb
            ln += 1; out += b[p + 1:p + 1 + ln]; p += 1 + ln; continue
        if k == 1: ln = ((t >> 2) & 7) + 4; off = ((t >> 5) << 8) | b[p + 1]; p += 2
        elif k == 2: ln = (t >> 2) + 1; off = int.from_bytes(b[p + 1:p + 3], 'little'); p += 3
        else: ln = (t >> 2) + 1; off = int.from_bytes(b[p + 1:p + 5], 'little'); p += 5
        if off == 0 or off > len(out): raise ValueError('bad snappy data')
        st = len(out) - off
        if off >= ln: out += out[st:st + ln]
        else:
            while ln > 0: chunk = out[st:st + min(off, ln)]; out += chunk; ln -= len(chunk)
    if len(out) != n: raise ValueError('bad snappy data')
    return bytes(out)

def unwrap(b, depth=0):
    """All the byte blobs worth searching for RAM, outermost first. Each is (description, bytes)."""
    out = [('file', b)]
    if depth > 3: return out
    try:
        if b[:7] == b'RASTATE':
            o = 8
            while o + 8 <= len(b):
                cid, n = b[o:o + 4], struct.unpack_from('<I', b, o + 4)[0]
                if cid == b'MEM ': return [(f'RetroArch state > {d}', x) for d, x in unwrap(b[o + 8:o + 8 + n], depth + 1)]
                if cid == b'END ': break
                o += 8 + ((n + 7) & ~7)
        if b[:2] == b'\x1f\x8b': return [(f'gzip > {d}', x) for d, x in unwrap(gzip.decompress(b), depth + 1)]
        if b[:4] == b'\x28\xb5\x2f\xfd': return [(f'zstd > {d}', x) for d, x in unwrap(_zstd(b), depth + 1)]
        if b[:4] == b'PK\x03\x04':
            z = zipfile.ZipFile(io.BytesIO(b)); res = []
            names = sorted(z.namelist(), key=lambda n: (('memory' not in n.lower() and 'ram' not in n.lower()), -z.getinfo(n).file_size))
            for n in names[:6]:
                res += [(f'zip {n} > {d}', x) for d, x in unwrap(z.read(n), depth + 1)]
            return res
        if b[:8] == b'\x89PNG\r\n\x1a\n':   # mGBA keeps the state in a 'gbAs' chunk
            o = 8
            while o + 8 <= len(b):
                n = struct.unpack_from('>I', b, o)[0]; cid = b[o + 4:o + 8]
                if cid == b'gbAs': return [(f'mGBA PNG > {d}', x) for d, x in unwrap(zlib.decompress(b[o + 8:o + 8 + n]), depth + 1)]
                o += 12 + n
        if len(b) > 2 and b[0] == 0x78 and (b[0] * 256 + b[1]) % 31 == 0:
            return [(f'zlib > {d}', x) for d, x in unwrap(zlib.decompress(b), depth + 1)]
    except (zlib.error, OSError, ValueError, zipfile.BadZipFile, struct.error, EOFError):
        pass
    # a header followed by compressed data (DuckStation, PPSSPP and others): look for the start of it
    for i in range(1, min(len(b) - 2, 0x1000)):
        try:
            if b[i:i + 4] == b'\x28\xb5\x2f\xfd':
                out += [(f'zstd at 0x{i:X} > {d}', x) for d, x in unwrap(_zstd(b[i:]), depth + 1)]; break
            if b[i] == 0x78 and b[i + 1] in (0x01, 0x5E, 0x9C, 0xDA):
                d = zlib.decompressobj(); x = d.decompress(b[i:], 0x8000000)
                if len(x) > 0x10000: out += [(f'zlib at 0x{i:X}', x)]; break
        except (zlib.error, OSError, ValueError):
            continue
    return out

# ---------------- finding RAM ----------------
def code_pieces(img, P):
    """Pieces of the game's code that live in RAM: (bus address, bytes)."""
    regs = []
    if P.KEY == 'nds':
        for idx, ram, o, n in img.reg[:2]: regs.append((ram, img.data[o:o + n]))
    elif hasattr(img, 'code_ranges'):
        for lo, hi in img.code_ranges:
            o = img.off(lo)
            if o is not None: regs.append((lo, img.data[o:o + hi - lo]))
    else:
        regs.append((img.base, img.data))
    out = []
    for base, data in regs:
        if P.ra(base) is None: continue
        step = max(32, len(data) // 60)
        for o in range(0, max(0, len(data) - 32), step):
            w = data[o:o + 32]
            if len(set(w)) >= 10: out.append((base + o, w))
    return out

def find_by_code(blob, img, P):
    votes = Counter(); where = {}
    pieces = code_pieces(img, P)
    for a, w in pieces:
        i = blob.find(w)
        if i < 0: continue
        r = P.ra(a)
        for k in (i, blob.find(w, i + 1)):   # a second copy (some emulators keep two) still votes
            if k >= 0: votes[k - r] += 1; where.setdefault(k - r, []).append(r)
    if not votes: return None
    start, n = votes.most_common(1)[0]
    # the matches must be spread over the code, not all inside one stretch of uncompressed bytes in a compressed file
    span = max(r for a, _ in pieces for r in [P.ra(a)]) - min(P.ra(a) for a, _ in pieces) if pieces else 0
    got = max(where[start]) - min(where[start])
    if n < 3 or got < min(span // 2, 0x40000): return None
    return start, n

def ra_memory(blob, P, start):
    size = RA_SIZE[P.KEY]
    mem = bytearray(size)
    lo = max(0, start); hi = min(len(blob), start + size)
    if hi > lo: mem[lo - start:hi - start] = blob[lo:hi]
    return bytes(mem), (hi - lo)

def from_mgba(blob):
    if len(blob) < 0x61000 or (struct.unpack_from('<I', blob, 0)[0] & 0xFFFFFF00) != 0x01000000: return None
    return blob[0x19000:0x21000] + blob[0x21000:0x61000]   # IWRAM then EWRAM, as RA lays them out

def from_gambatte(blob):
    """Gambatte states are a list of labelled entries: name, NUL, 3-byte big-endian size, data."""
    def entry(name):
        i = blob.find(b'\x00' + name + b'\x00') + 1 if blob.find(b'\x00' + name + b'\x00') >= 0 else (0 if blob.startswith(name + b'\x00') else -1)
        if i < 0: return None
        o = i + len(name) + 1; n = int.from_bytes(blob[o:o + 3], 'big')
        return blob[o + 3:o + 3 + n]
    wram, io_ = entry(b'wram'), entry(b'ioamhram')
    if not wram or not io_: return None
    sram = entry(b'sram') or b''
    mem = bytearray(0x18000)
    svbk = (io_[0x170] & 7) or 1 if len(io_) > 0x170 else 1
    mem[0xC000:0xD000] = wram[:0x1000]
    mem[0xD000:0xE000] = wram[svbk * 0x1000:(svbk + 1) * 0x1000] if len(wram) >= (svbk + 1) * 0x1000 else wram[0x1000:0x2000]
    mem[0xE000:0xFE00] = mem[0xC000:0xDE00]          # echo RAM
    mem[0xFE00:0x10000] = io_[:0x200]                 # OAM, I/O, HRAM
    if sram: mem[0xA000:0xC000] = sram[:0x2000].ljust(0x2000, b'\x00')
    for k in range(2, 8):                             # GBC WRAM banks 2-7 at RA 0x10000
        if len(wram) >= (k + 1) * 0x1000: mem[0x10000 + (k - 2) * 0x1000:0x10000 + (k - 1) * 0x1000] = wram[k * 0x1000:(k + 1) * 0x1000]
    if sram: mem[0x16000:0x18000] = sram[:0x2000].ljust(0x2000, b'\x00')
    return bytes(mem)

def extract(raw, img, P):
    """-> (RA memory bytes, how it was found). Raises ValueError with advice when RAM can't be found."""
    size = RA_SIZE.get(P.KEY)
    if size is None: raise ValueError(f'Save states are not set up for {P.NAME} yet.')
    blobs = unwrap(raw)
    for desc, b in blobs:
        if P.KEY == 'gba':
            m = from_mgba(b)
            if m: return m, f'{desc}: mGBA state'
        if P.KEY == 'gb':
            m = from_gambatte(b)
            if m: return m, f'{desc}: Gambatte state'
    if P.KEY not in ('gba', 'gb'):
        best = None
        for desc, b in blobs:
            r = find_by_code(b, img, P)
            if r and (best is None or r[1] > best[0][1]): best = (r, desc, b)
        if best:
            (start, n), desc, b = best
            mem, got = ra_memory(b, P, start)
            return mem, f'{desc}: RAM found at offset 0x{start:X} by matching {n} pieces of the game\'s code' + ('' if got == size else f' (only 0x{got:X} of 0x{size:X} bytes are in the state)')
    if P.KEY not in ('gba', 'gb'):   # last try: snappy-compressed data after a header (older PPSSPP states)
        for i in range(0, min(len(raw), 0x200)):
            n = 0
            for j in range(5):
                c = raw[i + j] if i + j < len(raw) else 0; n |= (c & 0x7F) << (7 * j)
                if not c & 0x80: break
            if not (0x100000 <= n <= 0x8000000 and raw[i + j + 1:i + j + 2] and raw[i + j + 1] & 3 == 0): continue
            try: b = snappy_decompress(raw[i:])
            except (ValueError, IndexError): continue
            r = find_by_code(b, img, P)
            if r:
                mem, got = ra_memory(b, P, r[0])
                return mem, f'snappy at 0x{i:X}: RAM found at offset 0x{r[0]:X} by matching {r[1]} pieces of the game\'s code'
            blobs.append((f'snappy at 0x{i:X}', b))
    for desc, b in blobs:
        if len(b) == size or (P.KEY == 'gba' and len(b) == 0x40000) or (P.KEY == 'ps2' and len(b) == 0x2000000) or (P.KEY == 'ps1' and len(b) == 0x200000):
            if P.KEY == 'gba' and len(b) == 0x40000: b = bytes(0x8000) + b   # an EWRAM-only dump
            return bytes(b).ljust(size, b'\x00'), f'{desc}: raw RAM dump'
    hint = {'gc': ' For Dolphin, save states are compressed in a way the tool can\'t read yet: use Dolphin\'s Memory view to dump MEM1 (mem1.raw) and add that instead.',
            'gba': ' The tool reads mGBA states (RetroArch\'s mGBA core, or mGBA itself).',
            'gb': ' The tool reads Gambatte states (RetroArch\'s Gambatte core).'}.get(P.KEY, '')
    raise ValueError('Couldn\'t find the game\'s RAM in that file. Is it a state for this game?' + hint)

# ---------------- comparing ----------------
OPS = {'any', 'eq', 'ne', 'gt', 'lt', 'inc', 'dec'}
def compare(mems, size, steps, big=False, only=None, limit=1500):
    """mems: RA memory per state, in order. steps[i] = {'value': int|None, 'rel': op vs the previous state, 'by': int|None}.
    Returns (count, [(ra, [values...])...])."""
    import numpy as np
    dt = {1: np.uint8, 2: np.dtype('>u2' if big else '<u2'), 4: np.dtype('>u4' if big else '<u4')}[size]
    n = min(len(m) for m in mems) // size * size
    arr = [np.frombuffer(m[:n], dtype=dt) for m in mems]
    keep = np.ones(len(arr[0]), dtype=bool)
    for i, st in enumerate(steps):
        v = st.get('value')
        if v is not None and v != '': keep &= arr[i] == int(v)
        if i == 0: continue
        rel = st.get('rel') or 'any'; a, b = arr[i - 1].astype(np.int64), arr[i].astype(np.int64)
        by = st.get('by')
        if rel == 'eq': keep &= b == a
        elif rel == 'ne': keep &= b != a
        elif rel == 'gt': keep &= b > a
        elif rel == 'lt': keep &= b < a
        elif rel == 'inc': keep &= b - a == int(by or 1)
        elif rel == 'dec': keep &= a - b == int(by or 1)
    if only is not None:
        mask = np.zeros(len(keep), dtype=bool)
        for r in only:
            if r // size < len(mask) and r % size == 0: mask[r // size] = True
        keep &= mask
    idx = np.nonzero(keep)[0]
    rows = [(int(k) * size, [int(x[k]) for x in arr]) for k in idx[:limit]]
    return int(len(idx)), rows

def values_at(mems, ra, size, big=False):
    out = []
    for m in mems:
        if ra + size > len(m): out.append(None); continue
        out.append(int.from_bytes(m[ra:ra + size], 'big' if big else 'little'))
    return out

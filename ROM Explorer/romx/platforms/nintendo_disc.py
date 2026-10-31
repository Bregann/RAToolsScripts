"""Reading GameCube and Wii discs: plain GameCube .iso/.gcm, and Dolphin's .rvz/.wia (which store Wii game
data already decrypted). Encrypted Wii .iso files are not read: convert them to RVZ in Dolphin first.
RVZ/WIA follows Dolphin's docs/WiaAndRvz.md. Only zstd (Dolphin's default for RVZ), bzip2 and uncompressed are supported."""
import struct, bz2
from .. import progress as PG

try:
    import zstandard as _zstd
    _ZD = _zstd.ZstdDecompressor()
    def zdec(src, cap):
        return _ZD.decompress(src, max_output_size=cap)
except ImportError:   # fall back to the system library (Linux/macOS)
    import ctypes, ctypes.util
    _z = None
    def zdec(src, cap):
        global _z
        if _z is None:
            name = ctypes.util.find_library('zstd') or 'libzstd.so.1'
            try: _z = ctypes.CDLL(name)
            except OSError: raise IOError('Reading RVZ needs the zstandard package: pip install zstandard')
            _z.ZSTD_decompress.restype = ctypes.c_size_t
            _z.ZSTD_decompress.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.c_void_p, ctypes.c_size_t]
            _z.ZSTD_isError.argtypes = [ctypes.c_size_t]; _z.ZSTD_isError.restype = ctypes.c_uint
        dst = ctypes.create_string_buffer(cap); n = _z.ZSTD_decompress(dst, cap, src, len(src))
        if _z.ZSTD_isError(n): raise IOError('zstd error while reading the RVZ file')
        return dst.raw[:n]

GC_MAGIC, WII_MAGIC = 0xC2339F3D, 0x5D1C9EA3
BLK_T, BLK_D, GRP_T = 0x8000, 0x7C00, 0x200000

class Plain:
    """A plain (uncompressed, unencrypted) GameCube disc image."""
    def __init__(self, path): self.f = open(path, 'rb')
    def read(self, off, size): self.f.seek(off); return self.f.read(size)

class RVZ:
    def __init__(self, path):
        self.f = open(path, 'rb'); h = self.f.read(0x48)
        if h[:4] not in (b'RVZ\x01', b'WIA\x01'): raise ValueError('Not an RVZ/WIA file.')
        self.rvz = h[:4] == b'RVZ\x01'
        dsz = struct.unpack('>I', h[0x0C:0x10])[0]; d = self.f.read(dsz)
        self.disc_type, self.comp, self.clevel, self.chunk = struct.unpack('>IIiI', d[:16])
        self.dhead = d[16:0x90]; o = 0x90
        self.n_part, self.part_t_size, self.part_off = struct.unpack('>IIQ', d[o:o + 16]); o += 16 + 20
        self.n_raw, self.raw_off, self.raw_size = struct.unpack('>IQI', d[o:o + 16]); o += 16
        self.n_groups, self.group_off, self.group_size = struct.unpack('>IQI', d[o:o + 16])
        if self.comp not in (0, 2, 5):
            raise ValueError('This RVZ uses LZMA compression, which the tool can\'t read yet. In Dolphin, convert it again with zstd (the default).')
        self.f.seek(self.part_off); pt = self.f.read(self.n_part * self.part_t_size)
        self.parts = []
        for i in range(self.n_part):
            e = pt[i * self.part_t_size:(i + 1) * self.part_t_size]
            self.parts.append([struct.unpack('>IIII', e[16 + j * 16:32 + j * 16]) for j in range(2)])
        self.raws = [struct.unpack('>QQII', x) for x in self._table(self.raw_off, self.raw_size, self.n_raw, 0x18)]
        esz = 0xC if self.rvz else 8
        self.groups = [struct.unpack('>III' if self.rvz else '>II', x) for x in self._table(self.group_off, self.group_size, self.n_groups, esz)]
        self.cache = {}
    def _dec(self, raw, cap):
        if self.comp == 5: return zdec(raw, cap)
        if self.comp == 2: return bz2.decompress(raw)
        return raw
    def _table(self, off, size, n, esz):
        self.f.seek(off); raw = self.f.read(size)
        data = self._dec(raw, n * esz + 64) if self.comp else raw
        return [data[i * esz:(i + 1) * esz] for i in range(n)]
    def _group(self, gi, out_size, exc_lists):
        key = (gi, out_size, exc_lists)
        if key in self.cache: return self.cache[key]
        g = self.groups[gi]; off = g[0] << 2; size = g[1] & 0x7FFFFFFF
        comp = bool(g[1] >> 31) if self.rvz else self.comp != 0
        packed = g[2] if self.rvz else 0
        if size == 0: data = bytes(out_size)
        else:
            self.f.seek(off); raw = self.f.read(size)
            if comp: raw = self._dec(raw, out_size + exc_lists * (2 + 0xFFFF * 22) // 8 + 0x100000)
            p = 0
            for _ in range(exc_lists):
                n = struct.unpack('>H', raw[p:p + 2])[0]; p += 2 + 22 * n
            if not comp and exc_lists: p = (p + 3) & ~3
            raw = raw[p:]
            if packed:
                out = bytearray(); q = 0
                while len(out) < out_size and q < len(raw):
                    n = struct.unpack('>I', raw[q:q + 4])[0]; q += 4
                    if n >> 31: n &= 0x7FFFFFFF; q += 68; out += bytes(n)   # junk padding: not needed, zeros
                    else: out += raw[q:q + n]; q += n
                data = bytes(out)
            else: data = raw
        if len(self.cache) > 64: self.cache.clear()
        self.cache[key] = data; return data
    def _read_groups(self, offset, size, chunk, d_off, d_size, gidx, exc):
        if d_off >= offset + size or d_off + d_size <= offset: return None
        out = bytearray(); o = max(offset, d_off); end = min(offset + size, d_off + d_size)
        while o < end:
            i = (o - d_off) // chunk; gstart = d_off + i * chunk; glen = min(chunk, d_off + d_size - gstart)
            g = self._group(gidx + i, glen, exc)
            a = o - gstart; b = min(end - gstart, glen); out += g[a:b]; o = gstart + b
        return (max(offset, d_off), bytes(out))
    def read_part(self, pidx, offset, size):
        """Decrypted data of Wii partition pidx (offset 0 = start of the partition's data)."""
        pds = self.parts[pidx]; base = pds[0][0] * BLK_T
        chunk = self.chunk * BLK_D // BLK_T; exc = max(1, self.chunk // GRP_T)
        buf = bytearray(size)
        for first, nsec, gidx, ng in pds:
            if not nsec: continue
            d_off = (first * BLK_T - base) // BLK_T * BLK_D
            r = self._read_groups(offset, size, chunk, d_off, nsec * BLK_D, gidx, exc)
            if r: buf[r[0] - offset:r[0] - offset + len(r[1])] = r[1]
        return bytes(buf)
    def read_raw(self, offset, size):
        buf = bytearray(size)
        if offset < 0x80: n = min(0x80 - offset, size); buf[:n] = self.dhead[offset:offset + n]
        for d_off, d_size, gidx, ng in self.raws:
            skip = d_off % BLK_T; d_off -= skip; d_size += skip
            r = self._read_groups(offset, size, self.chunk, d_off, d_size, gidx, 0)
            if r:
                a = r[0] - offset; data = r[1]
                if r[0] < 0x80: cut = 0x80 - r[0]; data = data[cut:]; a += cut
                buf[a:a + len(data)] = data
        return bytes(buf)

class GameData:
    """Uniform access to the game's data: read(offset, size) where offset 0 is the disc (GC) or game partition (Wii) header."""
    def __init__(self, path):
        with open(path, 'rb') as fh: head = fh.read(0x40)
        if head[:4] in (b'RVZ\x01', b'WIA\x01'):
            PG.say('Opening the compressed disc (RVZ/WIA)…')
            r = RVZ(path)
            if r.disc_type == 2:   # Wii: find the game partition (the one whose header has a main.dol offset and the Wii magic)
                best = None
                for i in range(len(r.parts)):
                    h = r.read_part(i, 0, 0x440)
                    if struct.unpack('>I', h[0x18:0x1C])[0] == WII_MAGIC and struct.unpack('>I', h[0x420:0x424])[0]:
                        size = sum(p[1] for p in r.parts[i])
                        if best is None or size > best[1]: best = (i, size)
                if best is None: raise ValueError('No game partition found in this Wii RVZ.')
                pi = best[0]; self.read = lambda o, n: r.read_part(pi, o, n); self.wii = True; self.shift = 2
            else:
                self.read = r.read_raw; self.wii = False; self.shift = 0
        else:
            magic_wii = struct.unpack('>I', head[0x18:0x1C])[0] == WII_MAGIC
            magic_gc = struct.unpack('>I', head[0x1C:0x20])[0] == GC_MAGIC
            if magic_wii:
                raise ValueError('This is an encrypted Wii disc image. In Dolphin, right-click the game > Convert File… > RVZ, '
                                 'then open the .rvz here. Or extract the disc in Dolphin and open its main.dol.')
            if not magic_gc: raise ValueError('Not a GameCube or Wii disc image.')
            p = Plain(path); self.read = p.read; self.wii = False; self.shift = 0
        h = self.read(0, 0x440)
        self.game_id = h[:6].decode('latin1', 'replace')
        self.title = h[0x20:0x60].split(b'\x00')[0].decode('latin1', 'replace').strip()
        self.dol_off = struct.unpack('>I', h[0x420:0x424])[0] << self.shift
    def dol(self):
        PG.say('Reading main.dol (the game\'s main program) from the disc…')
        hdr = self.read(self.dol_off, 0x100)
        offs = struct.unpack('>18I', hdr[:0x48]); sizes = struct.unpack('>18I', hdr[0x90:0xD8])
        end = max(o + s for o, s in zip(offs, sizes) if s)
        return self.read(self.dol_off, end)

def is_disc(path, head):
    if head[:4] in (b'RVZ\x01', b'WIA\x01'): return True
    if len(head) >= 0x20:
        return struct.unpack('>I', head[0x1C:0x20])[0] == GC_MAGIC or struct.unpack('>I', head[0x18:0x1C])[0] == WII_MAGIC
    return False

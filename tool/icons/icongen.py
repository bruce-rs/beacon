"""Renders the Beacon mark (concentric arcs + dot) to PNGs.

No image library is available here, so this rasterises by hand: a master is
drawn at high resolution with 3x3 supersampling, then box-filtered down to each
target size, which keeps the arcs clean at launcher sizes.
"""

import math
import struct
import zlib

MASTER = 1024
SS = 3  # supersamples per axis


def _coverage(px, py, size, mark_scale):
    """Alpha of the mark at a sub-sample point, 0..1 (already supersampled by caller)."""
    m = size * mark_scale
    cx = cy = size / 2
    dx, dy = px - cx, py - cy
    r = math.hypot(dx, dy)

    # Centre dot.
    if r <= 0.085 * m:
        return 1.0

    stroke = 0.075 * m
    half = stroke / 2
    angle = math.degrees(math.atan2(dy, dx))  # -180..180

    # Arcs open left and right, like the in-app beacon mark.
    for radius_factor in (0.23, 0.38):
        radius = radius_factor * m
        if abs(r - radius) <= half:
            for centre in (0.0, 180.0):
                delta = abs(((angle - centre + 180) % 360) - 180)
                if delta <= 48:
                    return 1.0
        # Round caps at both ends of each arc segment.
        for centre in (0.0, 180.0):
            for end in (centre - 48, centre + 48):
                ex = cx + radius * math.cos(math.radians(end))
                ey = cy + radius * math.sin(math.radians(end))
                if math.hypot(px - ex, py - ey) <= half:
                    return 1.0
    return 0.0


def render_master(mark_scale):
    """Alpha map of the mark at MASTER resolution, as a list of rows of floats."""
    rows = []
    step = 1.0 / SS
    offsets = [(i + 0.5) * step for i in range(SS)]
    for y in range(MASTER):
        row = []
        for x in range(MASTER):
            hits = 0
            for oy in offsets:
                for ox in offsets:
                    if _coverage(x + ox, y + oy, MASTER, mark_scale):
                        hits += 1
            row.append(hits / (SS * SS))
        rows.append(row)
    return rows


def downscale(alpha, target):
    """Box-filter the master alpha map down to `target` square."""
    factor = MASTER / target
    out = []
    for y in range(target):
        y0, y1 = int(y * factor), int((y + 1) * factor)
        row = []
        for x in range(target):
            x0, x1 = int(x * factor), int((x + 1) * factor)
            total = count = 0
            for sy in range(y0, y1):
                src = alpha[sy]
                for sx in range(x0, x1):
                    total += src[sx]
                    count += 1
            row.append(total / count if count else 0.0)
        out.append(row)
    return out


def write_png(path, size, alpha, mark_rgb, bg_rgb=None, corner_radius=0.0):
    """Composites the mark over an optional background and writes a PNG."""
    raw = bytearray()
    radius_px = corner_radius * size
    for y in range(size):
        raw.append(0)  # filter type: none
        for x in range(size):
            a = alpha[y][x]

            if bg_rgb is None:
                br, bg_, bb, ba = 0, 0, 0, 0.0
            else:
                br, bg_, bb = bg_rgb
                ba = 1.0
                if radius_px > 0:  # rounded square mask for legacy launchers
                    cx = min(max(x + 0.5, radius_px), size - radius_px)
                    cy = min(max(y + 0.5, radius_px), size - radius_px)
                    d = math.hypot(x + 0.5 - cx, y + 0.5 - cy)
                    ba = min(max(radius_px + 0.5 - d, 0.0), 1.0) if d > 0 else 1.0

            mr, mg, mb = mark_rgb
            out_a = a + ba * (1 - a)
            if out_a <= 0:
                raw.extend((0, 0, 0, 0))
                continue
            r = (mr * a + br * ba * (1 - a)) / out_a
            g = (mg * a + bg_ * ba * (1 - a)) / out_a
            b = (mb * a + bb * ba * (1 - a)) / out_a
            raw.extend((int(r + 0.5), int(g + 0.5), int(b + 0.5), int(out_a * 255 + 0.5)))

    def chunk(tag, data):
        return struct.pack('>I', len(data)) + tag + data + struct.pack('>I', zlib.crc32(tag + data) & 0xFFFFFFFF)

    png = b'\x89PNG\r\n\x1a\n'
    png += chunk(b'IHDR', struct.pack('>IIBBBBB', size, size, 8, 6, 0, 0, 0))
    png += chunk(b'IDAT', zlib.compress(bytes(raw), 9))
    png += chunk(b'IEND', b'')
    open(path, 'wb').write(png)

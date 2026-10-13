"""Writes the macOS app icons for both flavours.

macOS icons are not full-bleed like iOS: the artwork sits on a rounded tile
inset in a transparent canvas, following Apple's 824/1024 proportions.
"""

import math
import os
import pathlib
import struct
import sys
import zlib

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import icongen

ROOT = str(pathlib.Path(__file__).resolve().parents[2])

BLUE = (0x3F, 0x7E, 0xE6)
TEAL = (0x2B, 0xB3, 0xA3)
WHITE = (255, 255, 255)

# Apple's macOS icon grid, as fractions of the canvas.
TILE = 824 / 1024
RADIUS = 185 / 824  # of the tile
SIZES = (16, 32, 64, 128, 256, 512, 1024)

# AppIcon mirrors prod: it is what builds without a flavour prefix use.
SETS = {'prodAppIcon': BLUE, 'AppIcon': BLUE, 'devAppIcon': TEAL}


def rounded_rect_alpha(size):
    """Anti-aliased coverage of the inset rounded tile."""
    inset = size * (1 - TILE) / 2
    left, top = inset, inset
    right, bottom = size - inset, size - inset
    radius = (right - left) * RADIUS

    rows = []
    for y in range(size):
        row = []
        py = y + 0.5
        for x in range(size):
            px = x + 0.5
            # Distance outside the rounded rectangle, negative when inside.
            dx = max(left + radius - px, 0, px - (right - radius))
            dy = max(top + radius - py, 0, py - (bottom - radius))
            if px < left or px > right or py < top or py > bottom:
                d = math.hypot(max(left - px, 0, px - right), max(top - py, 0, py - bottom))
                row.append(0.0 if d > 0.5 else 0.5 - d)
                continue
            d = math.hypot(dx, dy) - radius
            row.append(min(max(0.5 - d, 0.0), 1.0))
        rows.append(row)
    return rows


def write(path, size, tile_alpha, mark_alpha, tile_rgb):
    raw = bytearray()
    for y in range(size):
        raw.append(0)
        for x in range(size):
            ta = tile_alpha[y][x]
            ma = mark_alpha[y][x] * ta  # the mark never spills past the tile
            out_a = ta
            if out_a <= 0:
                raw.extend((0, 0, 0, 0))
                continue
            r = (WHITE[0] * ma + tile_rgb[0] * (ta - ma)) / out_a
            g = (WHITE[1] * ma + tile_rgb[1] * (ta - ma)) / out_a
            b = (WHITE[2] * ma + tile_rgb[2] * (ta - ma)) / out_a
            raw.extend((round(r), round(g), round(b), round(out_a * 255)))

    def chunk(tag, data):
        return struct.pack('>I', len(data)) + tag + data + struct.pack('>I', zlib.crc32(tag + data) & 0xFFFFFFFF)

    png = b'\x89PNG\r\n\x1a\n'
    png += chunk(b'IHDR', struct.pack('>IIBBBBB', size, size, 8, 6, 0, 0, 0))
    png += chunk(b'IDAT', zlib.compress(bytes(raw), 9))
    png += chunk(b'IEND', b'')
    open(path, 'wb').write(png)


def main():
    print('rendering master…')
    # 0.62 of the tile, expressed against the full canvas.
    master = icongen.render_master(0.62 * TILE)
    marks, tiles = {}, {}

    for name, colour in SETS.items():
        folder = f'{ROOT}/macos/Runner/Assets.xcassets/{name}.appiconset'
        for size in SIZES:
            if size not in marks:
                marks[size] = icongen.downscale(master, size)
                tiles[size] = rounded_rect_alpha(size)
            write(f'{folder}/{size}.png', size, tiles[size], marks[size], colour)
        print('macos', name)


if __name__ == '__main__':
    main()

"""Writes every launcher icon asset for both flavours and platforms."""

import json
import os
import pathlib
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import icongen

ROOT = str(pathlib.Path(__file__).resolve().parents[2])

WHITE = (255, 255, 255)
BLUE = (0x3F, 0x7E, 0xE6)
TEAL = (0x2B, 0xB3, 0xA3)
DARK_GROUND = (0x15, 0x18, 0x1D)

FLAVOURS = {
    'prod': {'bg': BLUE, 'bg_hex': '#3F7EE6', 'night_hex': '#1E2A3C', 'dark_mark': BLUE},
    'dev': {'bg': TEAL, 'bg_hex': '#2BB3A3', 'night_hex': '#14312E', 'dark_mark': TEAL},
}

# Android density buckets: legacy launcher px, adaptive layer px (108dp canvas).
DENSITIES = {
    'mdpi': (48, 108),
    'hdpi': (72, 162),
    'xhdpi': (96, 216),
    'xxhdpi': (144, 324),
    'xxxhdpi': (192, 432),
}

ADAPTIVE_XML = '''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
    <monochrome android:drawable="@mipmap/ic_launcher_monochrome"/>
</adaptive-icon>
'''

COLOR_XML = '''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">{hex}</color>
</resources>
'''


def main():
    print('rendering master…')
    master = icongen.render_master(0.62)
    cache = {}

    def alpha_for(size):
        if size not in cache:
            cache[size] = icongen.downscale(master, size)
        return cache[size]

    for flavour, cfg in FLAVOURS.items():
        res = f'{ROOT}/android/app/src/{flavour}/res'

        for bucket, (legacy_px, adaptive_px) in DENSITIES.items():
            folder = f'{res}/mipmap-{bucket}'
            os.makedirs(folder, exist_ok=True)

            # Legacy launchers (pre-API 26) get a full-bleed rounded square.
            icongen.write_png(
                f'{folder}/ic_launcher.png', legacy_px, alpha_for(legacy_px), WHITE, cfg['bg'], corner_radius=0.22
            )
            # Adaptive layers are transparent: the system masks and themes them.
            icongen.write_png(f'{folder}/ic_launcher_foreground.png', adaptive_px, alpha_for(adaptive_px), WHITE)
            icongen.write_png(f'{folder}/ic_launcher_monochrome.png', adaptive_px, alpha_for(adaptive_px), WHITE)
            print('android', flavour, bucket)

        os.makedirs(f'{res}/mipmap-anydpi-v26', exist_ok=True)
        open(f'{res}/mipmap-anydpi-v26/ic_launcher.xml', 'w').write(ADAPTIVE_XML)

        # The background colour has a -night variant, so the icon follows the
        # system theme on launchers that re-render per configuration.
        for values, key in (('values', 'bg_hex'), ('values-night', 'night_hex')):
            os.makedirs(f'{res}/{values}', exist_ok=True)
            open(f'{res}/{values}/ic_launcher_background.xml', 'w').write(COLOR_XML.format(hex=cfg[key]))

        # ── iOS: one 1024 per appearance ────────────────────────────────────
        for name in (f'{flavour}AppIcon', 'AppIcon' if flavour == 'prod' else None):
            if name is None:
                continue
            folder = f'{ROOT}/ios/Runner/Assets.xcassets/{name}.appiconset'
            for old in os.listdir(folder):
                os.remove(f'{folder}/{old}')

            icongen.write_png(f'{folder}/icon-light.png', 1024, alpha_for(1024), WHITE, cfg['bg'])
            icongen.write_png(f'{folder}/icon-dark.png', 1024, alpha_for(1024), cfg['dark_mark'], DARK_GROUND)
            # Tinted: grayscale art on transparent, the system supplies the tint.
            icongen.write_png(f'{folder}/icon-tinted.png', 1024, alpha_for(1024), WHITE)

            contents = {
                'images': [
                    {'filename': 'icon-light.png', 'idiom': 'universal', 'platform': 'ios', 'size': '1024x1024'},
                    {
                        'appearances': [{'appearance': 'luminosity', 'value': 'dark'}],
                        'filename': 'icon-dark.png',
                        'idiom': 'universal',
                        'platform': 'ios',
                        'size': '1024x1024',
                    },
                    {
                        'appearances': [{'appearance': 'luminosity', 'value': 'tinted'}],
                        'filename': 'icon-tinted.png',
                        'idiom': 'universal',
                        'platform': 'ios',
                        'size': '1024x1024',
                    },
                ],
                'info': {'author': 'xcode', 'version': 1},
            }
            with open(f'{folder}/Contents.json', 'w') as f:
                json.dump(contents, f, indent=2)
                f.write('\n')
            print('ios', name)


if __name__ == '__main__':
    main()

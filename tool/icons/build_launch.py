"""Writes launch-screen artwork for both flavours and platforms."""

import json
import os
import pathlib
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import icongen

ROOT = str(pathlib.Path(__file__).resolve().parents[2])

BLUE = (0x3F, 0x7E, 0xE6)
BLUE_DIM = (0x9C, 0xC3, 0xF7)
TEAL = (0x2B, 0xB3, 0xA3)
TEAL_DIM = (0x45, 0xC9, 0xB9)

# imageset name -> (light mark, dark mark)
IOS_SETS = {
    'LaunchImage': (BLUE, BLUE_DIM),
    'prodLaunchImage': (BLUE, BLUE_DIM),
    'devLaunchImage': (TEAL, TEAL_DIM),
}

# Android densities for the splash mark.
# Android 12+ draws the splash icon on a 288dp canvas; smaller sources are
# upscaled and go soft.
ANDROID = {'mdpi': 288, 'hdpi': 432, 'xhdpi': 576, 'xxhdpi': 864, 'xxxhdpi': 1152}
ANDROID_MARKS = {'prod': BLUE, 'dev': TEAL}


def main():
    print('rendering master…')
    master = icongen.render_master(0.62)
    cache = {}

    def alpha_for(size):
        if size not in cache:
            cache[size] = icongen.downscale(master, size)
        return cache[size]

    # ── iOS: transparent mark, light/dark variants, over a themed background ──
    for name, (light, dark) in IOS_SETS.items():
        folder = f'{ROOT}/ios/Runner/Assets.xcassets/{name}.imageset'
        for old in os.listdir(folder):
            if old.endswith('.png') or old == 'Contents.json':
                os.remove(f'{folder}/{old}')

        images = []
        for scale, size in (('1x', 120), ('2x', 240), ('3x', 360)):
            suffix = '' if scale == '1x' else f'@{scale}'
            icongen.write_png(f'{folder}/LaunchImage{suffix}.png', size, alpha_for(size), light)
            icongen.write_png(f'{folder}/LaunchImage{suffix}-dark.png', size, alpha_for(size), dark)
            images.append({'idiom': 'universal', 'filename': f'LaunchImage{suffix}.png', 'scale': scale})
            images.append(
                {
                    'appearances': [{'appearance': 'luminosity', 'value': 'dark'}],
                    'idiom': 'universal',
                    'filename': f'LaunchImage{suffix}-dark.png',
                    'scale': scale,
                }
            )

        with open(f'{folder}/Contents.json', 'w') as f:
            json.dump({'images': images, 'info': {'version': 1, 'author': 'xcode'}}, f, indent=2)
            f.write('\n')
        print('ios', name)

    # ── Android: one accent mark; the background colour carries the theme ────
    for flavour, mark in ANDROID_MARKS.items():
        for bucket, size in ANDROID.items():
            folder = f'{ROOT}/android/app/src/{flavour}/res/drawable-{bucket}'
            os.makedirs(folder, exist_ok=True)
            icongen.write_png(f'{folder}/splash_mark.png', size, alpha_for(size), mark)
        print('android', flavour)


if __name__ == '__main__':
    main()

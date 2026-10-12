# Icon and launch artwork

The app icons and launch screens are generated from one mark — the concentric
arcs used in the app header, scanning state and About dialog — so they stay in
step with the UI.

```bash
python3 tool/icons/build_icons.py    # app icons, both flavors, Android + iOS
python3 tool/icons/build_launch.py   # launch screen artwork
```

`icongen.py` is a small rasteriser (no image library required): it draws the mark
at 1024 with 3x3 supersampling and box-filters down to each target size.

Colors live at the top of each script: prod blue `#3F7EE6`, dev teal `#2BB3A3`.
Both scripts overwrite the checked-in assets in place, so review `git diff`
afterwards.

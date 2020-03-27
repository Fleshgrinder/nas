#!/usr/bin/env python3

from pathlib import Path

from PIL import Image

for path in Path('/out').rglob('folder.jpg'):

    Image.open(path).resize((100, 100), resample=Image.LANCZOS, reducing_gap=3.0) \
        .save(path.parent / 'thumb.jpg', 'JPEG', optimize=True, quality=85)

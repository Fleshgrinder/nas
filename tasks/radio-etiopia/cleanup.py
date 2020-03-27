#!/usr/bin/env python3

from pathlib import Path

from mutagen.easyid3 import EasyID3

root = Path('/out')
for episode_path in root.iterdir():
    media_paths = []
    for file in episode_path.iterdir():
        if file.name.endswith('.mp3'):
            media_paths.append(file)

    if len(media_paths) == 1:
        media_path = media_paths[0]

        media = EasyID3(media_path)
        title = media['title'][0]
        date = media.get('date', [''])[0]

        filename = title \
            .replace('"', '') \
            .replace('<', '') \
            .replace('>', '') \
            .replace(':', '') \
            .replace('/', '-') \
            .replace('\\', '-') \
            .replace('|', '-') \
            .replace('?', '') \
            .replace('*', '') \
            .rstrip('.')

        media_path.rename(media_path.parent / f'01 - {filename}.mp3')
        media_path.parent.rename(root / f'{date} - {filename}')

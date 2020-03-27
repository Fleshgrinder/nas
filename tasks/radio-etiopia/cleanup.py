#!/usr/bin/env python3

import re
import sys
from pathlib import Path
from sys import exit
from unicodedata import category, normalize

import mutagen
from mutagen.easyid3 import EasyID3
from mutagen.id3 import ID3

date_pattern = re.compile(r'^([12]\d{3}-(?:0[1-9]|1[0-2])-[0123][0-9]) - ')
nr_series_pattern = re.compile(r'^.*#\s*(\d+).*$')
ws_replace_pattern = re.compile(r' +')


def titlecase(t: str) -> str:
    t = t.strip()
    if t == 'AM/FM' or t == 'Lisbon 4 AM' or t == 'KM 83' or t == 'RGB Manipulation':
        return t

    t = normalize('NFC', t)
    t = t.casefold()

    match = nr_series_pattern.match(t)
    if match is not None:
        return f'# {match.group(1)}'

    t = ws_replace_pattern.sub(' ', t)

    # https://en.wikipedia.org/wiki/Apostrophe#Unicode
    t = t.replace(' ii', ' II') \
        .replace('....', '…') \
        .replace('...', '…') \
        .replace(' !', '!') \
        .replace(' ?', '?') \
        .replace(' ,', ',') \
        .replace('( ', '(') \
        .replace(' )', ')') \
        .replace("'", '\u02BC') \
        .replace('\u2019', '\u02BC')

    r = ''
    pc = 'Z'
    for c in t:
        # https://www.unicode.org/reports/tr44/#General_Category_Values
        if pc[0] in ['C', 'M', 'P', 'Z']:
            r += c.upper()
        else:
            r += c
        pc = category(c)[0]

    return r


root = Path(sys.argv[1])
for year_path in root.iterdir():
    for episode_path in year_path.iterdir():
        media_path = next(it for it in episode_path.iterdir() if it.name.endswith('.mp3'))
        media = EasyID3(media_path)

        date = media.get('date', [''])[0]
        matches = date_pattern.match(media_path.parent.stem)
        if matches is None:
            print(f'[ERR] NO DATE {media_path.parent}')
            exit(1)

        dir_date = matches.group(1)
        if dir_date != date:
            if len(date) != 10:
                date = dir_date
            else:
                print(f'[ERR] DATE MISMATCH {date} != {dir_date}')
                exit(1)

        title = titlecase(media['title'][0])

        # filename = title \
        #     .replace('"', '') \
        #     .replace('<', '') \
        #     .replace('>', '') \
        #     .replace(':', '') \
        #     .replace('/', '-') \
        #     .replace('\\', '-') \
        #     .replace('|', '-') \
        #     .replace('?', '') \
        #     .replace('*', '') \
        #     .rstrip('.')

        media = ID3(media_path)
        media.delete()
        media.add(mutagen.id3.TPE1(encoding=3, text='Rádio Etiópia'))  # artist
        media.add(mutagen.id3.TALB(encoding=3, text=title))  # album
        media.add(mutagen.id3.TIT2(encoding=3, text=title))  # title
        media.add(mutagen.id3.TDRC(encoding=3, text=date))  # date
        media.add(mutagen.id3.TCON(encoding=3, text='Podcast'))  # genre
        media.add(mutagen.id3.TRCK(encoding=3, text='1/1'))  # track
        media.save()

        print(media_path.relative_to(root))

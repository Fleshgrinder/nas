import atexit
import re
import shutil
import sys
from datetime import datetime
from pathlib import Path
from typing import Union
from unicodedata import category, normalize

import mutagen
import requests
from PIL import Image
from mutagen.id3 import ID3

out = Path('/out')
tmp = Path('/tmp')
guid_path = out / '.guid'
guid = guid_path.read_text(encoding='utf-8') if guid_path.exists() else ''
latest_guid = ''
page = 0
page_count = sys.maxsize
headers = {'User-Agent': 'Fleshgrinder-NAS/1.0 (+https://github.com/Fleshgrinder/nas)'}

nr_series_pattern = re.compile(r'^.*#\s*(\d+).*$')
ws_replace_pattern = re.compile(r' +')


def titlecase(t: str) -> str:
    t = t.strip()
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


class Tmp:
    def __init__(self, path: Path):
        self.path = tmp / path.name

    def __enter__(self) -> Path:
        return self.path

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.path.unlink(missing_ok=True)


class Episode:
    _ff_pattern = re.compile(r'(https?://[a-z0-9.]*filefactory\\.com[^ ]*[_.]mp3)')
    cover_filename = 'folder.jpg'
    cover_thumb_filename = 'thumb.jpg'
    readme_filename = 'README.txt'
    url_filename = 'Podomatic.url'

    def __init__(self, data):
        self.title: str = titlecase(data['title'])

        dt = datetime.strptime(data['published_datetime'], '%Y-%m-%dT%H:%M:%SZ')
        self.date: str = f'{dt:%Y-%m-%d}'
        self.year: str = f'{dt:%Y}'

        filename = self.title \
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
        self.dirname: str = f'{self.date} - {filename}'
        self.path: Path = out / self.year / self.dirname
        self.media_filename: str = f'01 - {filename}.mp3'
        self.media_path: Path = self.path / self.media_filename
        self.cover_path: Path = self.path / self.cover_filename
        self.cover_thumb_path: Path = self.path / self.cover_thumb_filename
        self.readme_path: Path = self.path / self.readme_filename
        self.url_path: Path = self.path / self.url_filename

        self.permalink_url: str = data['permalink_url']
        self.description: str = data['description'].strip().replace('\r\n', '\n') + '\n'
        self.image_url: str = data['xl_image_url']
        self.guid: str = data['episode_guid']

        self.media_url: Union[str, None] = data.get('media_url', None)
        if self.media_url is None:
            match = self._ff_pattern.match(self.description)
            if match is not None:
                self.media_url = match.group(1)

    def __str__(self):
        return f'{self.date} - {self.title}'


@atexit.register
def write_guid():
    guid_path.touch(exist_ok=True)
    guid_path.write_text(latest_guid, encoding='utf-8')


with requests.Session() as session:
    while page < page_count:
        with session.get(
            'https://www.podomatic.com/v2/podcasts/75882/episodes',
            headers=headers,
            params={'page': page, 'per_page': 25}
        ) as r:
            r.raise_for_status()
            json = r.json()

        page += 1
        page_count = json['pagination']['page_count']
        for episode_data in json['episodes']:
            episode = Episode(episode_data)

            if latest_guid == '':
                latest_guid = episode.guid
            if latest_guid == guid:
                sys.exit(0)

            if episode.media_path.exists():
                continue

            if episode.media_url is None:
                print(f'[ERR] "{episode}" has no media url: {episode.permalink_url}')
                continue

            episode.path.mkdir(parents=True, exist_ok=True)

            episode.url_path.write_text(f'[InternetShortcut]\nURL={episode.permalink_url}\n')
            episode.readme_path.write_text(episode.description, encoding='utf-8')

            with Tmp(episode.cover_path) as cover_tmp_path:
                with session.get(episode.image_url, headers=headers, stream=True) as r:
                    r.raise_for_status()
                    with cover_tmp_path.open('wb') as f:
                        shutil.copyfileobj(r.raw, f)

                cover = Image.open(cover_tmp_path)
                cover.save(episode.cover_path, 'JPEG', optimize=True, quality=85)
                cover.resize((100, 100), resample=Image.LANCZOS, reducing_gap=3.0) \
                    .save(episode.cover_thumb_path, 'JPEG', optimize=True, quality=85)

            with Tmp(episode.media_path) as media_tmp_path:
                with session.get(episode.media_url, headers=headers, stream=True) as r:
                    r.raise_for_status()
                    with media_tmp_path.open('wb') as f:
                        shutil.copyfileobj(r.raw, f)

                media = ID3(media_tmp_path)
                media.delete()
                media.add(mutagen.id3.TPE1(encoding=3, text='Rádio Etiópia'))  # artist
                media.add(mutagen.id3.TALB(encoding=3, text=episode.title))  # album
                media.add(mutagen.id3.TIT2(encoding=3, text=episode.title))  # title
                media.add(mutagen.id3.TDRC(encoding=3, text=episode.date))  # date
                media.add(mutagen.id3.TCON(encoding=3, text='Podcast'))  # genre
                media.add(mutagen.id3.TRCK(encoding=3, text='1/1'))  # track
                media.save()

                # noinspection PyTypeChecker
                shutil.move(media_tmp_path, episode.media_path)

            print(f'Downloaded: {episode}')

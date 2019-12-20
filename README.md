# NAS

This repository contains configuration files for [my Synology NAS] as well as
tutorials of how to set up the software I run there. This is for myself but
others might find it useful, so here it is…

## Media Server

Right now I am using [Plex] but would like to switch to [Jellyfin] because it is
open source and has a [LG WebOS client] that I can customize to my needs (and
contribute back, obviously).

## Torrent

I am currently using [linuxserver/rutorrent] because it comes along with
everything I needed to get started. However, it is running multiple things in
the same Docker container and violates the Docker philosophy. It is also rather
resource hungry with nginx and PHP and what not running all the time.

I should create my own [rTorrent] image that exposes its XMLRPC endpoint and
another container that runs a lightweight UI. Maybe [flood]?

[flood]: https://github.com/Flood-UI/flood
[Jellyfin]: https://jellyfin.org/
[linuxserver/rutorrent]: https://github.com/linuxserver/docker-rutorrent
[LG WebOS client]: https://github.com/jellyfin/jellyfin-webos
[my Synology NAS]: https://www.synology.com/en-global/products/DS918+
[Plex]: https://www.plex.tv/
[rTorrent]: https://github.com/rakshasa/rtorrent

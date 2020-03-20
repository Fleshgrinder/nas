#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${PHP_OPCACHE:-}" != false ]]; then
    # I seriously don't know why opcache is not part of the linuxserver/rutorrent
    # image as it speeds things up and reduces CPU usage dramatically.
    apk add --no-cache --upgrade php7-opcache
fi

# Some predefined labels are plural and others singular. This makes little
# sense, hence, we have to clean things up a little. I decided to stick with
# plural words.
(
    cd /app/rutorrent/plugins
    cp tracklabels/labels/movie.png tracklabels/labels/movies.png
    # It is possible to mount a live version of the plugin, in that case we do not

    # want to override it.
    if [[ ! -d rename ]]; then
        src=/usr/local/src/github.com/Fleshgrinder/rutorrent-rename
        git clone https://github.com/Fleshgrinder/rutorrent-rename.git "$src"
        ln -s "$src" rename
    fi
)

cat <<BASHRC >/root/.bashrc
alias l='ls --almost-all --color=auto --classify --group-directories-first --human-readable -l'
BASHRC

exec /init

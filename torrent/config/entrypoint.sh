#!/usr/bin/env bash
set -Eeuo pipefail

packages=(jq)
if [[ "${PHP_OPCACHE:-}" != false ]]; then
    # I seriously don't know why opcache is not part of the linuxserver/rutorrent
    # image as it speeds things up and reduces CPU usage dramatically.
    packages+=(php7-opcache)
fi
apk add --no-cache --upgrade "${packages[@]}"

# Some predefined labels are plural and others singular. This makes little
# sense, hence, we have to clean things up a little. I decided to stick with
# singular words for multiple reasons:
#
# - a label describes a single torrent (we could see it as a category as it is
#   called in many other clients, in that case this argument would be nil)
# - English is a wildly inconsistent language and mass nouns like music and
#   series make the list of labels look weird if the others are plural (consider
#   German where we would have Musik and Musiken as well as Serie and Serien;
#   obviously this argument would be nil if English would be consistent)
(
    cd /app/rutorrent/plugins/tracklabels/labels
    cp apps.png app.png
    cp books.png book.png
)

# It is possible to mount a live version of the plugin, in that case we do not
# want to override it.
if [[ ! -d /app/rutorrent/plugins/rename ]]; then
    curl -sL "$(curl -s 'https://api.github.com/repos/Fleshgrinder/rutorrent-rename/releases/latest' | jq -r '.tarball_url')" |
        tar --exclude '*/.*' --exclude '*/*.md' --strip-components=1 -xvzC /app/rutorrent/plugins
fi

cat <<BASHRC >/root/.bashrc
alias l='ls --almost-all --color=auto --classify --group-directories-first --human-readable -l'
BASHRC

exec /init

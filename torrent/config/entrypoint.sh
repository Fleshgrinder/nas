#!/usr/bin/env bash
set -Eeuo pipefail

# I seriously don't know why opcache is not part of the linuxserver/rutorrent
# image as it speeds things up and reduces CPU usage dramatically.
apk add --no-cache --upgrade php7-opcache

# Some predefined labels are plural and others singular. This makes little
# sense, hence, we have to clean things up a little. I decided to stick with
# singular words for multiple reasons:
#
# - a label describes a single torrent (we could see it as a category as it is
#   called in many other clients, in that case this argument would be nil)
# - English is a widly inconsistent language and mass nouncs like music and
#   series make the list of lables look weird if the others are plural (consider
#   German where we would have Musik and Musiken as well as Serie and Serien;
#   obviously this argument would be nil if English would be consistent)
(
    cd /app/rutorrent/plugins/tracklabels/labels
    cp apps.png app.png
    cp books.png book.png
)

exec /init

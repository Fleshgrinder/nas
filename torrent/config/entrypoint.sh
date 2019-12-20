#!/usr/bin/env bash
set -Eeuo pipefail

# I seriously don't know why opcache is not part of the linuxserver/rutorrent
# image as it speeds things up and reduces CPU usage dramatically.
apk add --no-cache --upgrade php7-opcache

exec /init

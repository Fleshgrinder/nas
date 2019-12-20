#!/usr/bin/env bash
set -Eeuxo pipefail

# I could not make this work as part of the super weird rtorrent.rc scripting
# syntax. Luckily Bash is always here to help.

if [[ "$1" == music ]]; then
    cp -ruv "$2/$3" /music/.unsorted &
fi

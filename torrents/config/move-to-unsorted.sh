#!/usr/bin/env bash
set -Eeuxo pipefail

if [[ "$1" == music ]]; then
    mkdir -p /music/.unsorted
    cp -ruv "$2/$3" /music/.unsorted
fi

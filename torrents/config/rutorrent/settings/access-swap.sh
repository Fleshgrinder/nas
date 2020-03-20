#!/usr/bin/env bash
set -Eeuo pipefail

# This script will quickly and easily swap between two different configurations
# so that access to configuration options can be easily turned on or off, this
# can help to protect against unauthorised setting changes.

if (($(head -n1 access.ini | cut -c4) == 0)); then
    echo -e "\e[31m Access Opened \e[0m"
    cp -f access_yes access.ini
else
    echo -e "\e[32m Access Closed \e[0m"
    cp -f access_no access.ini
fi

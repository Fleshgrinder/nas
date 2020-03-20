MAKEFLAGS += --always-make
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKEFLAGS += --no-print-directory
.DELETE_ON_ERROR :=
SHELL := bash
.SHELLFLAGS := -euo pipefail -c
.ONESHELL:
.SUFFIXES:
ifndef DEBUG
.SILENT:
endif
export

rutorrent: ## Start rutorrent container locally
	exec bin/$@

rutorrent-no-opcache: PHP_OPCACHE := false
rutorrent-no-opcache: rutorrent ## Start rutorrent container locally without PHP OPCache

rutorrent-bash: ## Log in to a running ruTorrent container
	docker exec -it rutorrent bash

clean: ## Remove volatile files
	rm -fr \
	    torrent/config/keys \
	    torrent/config/log \
	    torrent/config/nginx/site-confs \
	    torrent/config/rtorrent/rtorrent_sess \
	    torrent/config/rutorrent/profiles/settings/*.dat \
	    torrent/config/rutorrent/profiles/settings/*/ \
	    torrent/config/rutorrent/profiles/tmp \
	    torrent/config/rutorrent/profiles/torrents \
	    torrent/config/rutorrent/profiles/users \
	    torrent/config/rutorrent/settings/users \
	    torrent/config/www \
	    torrent/data

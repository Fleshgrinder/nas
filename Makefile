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
	    torrents/config/keys \
	    torrents/config/log \
	    torrents/config/nginx/site-confs \
	    torrents/config/rtorrent/rtorrent_sess \
	    torrents/config/rutorrent/profiles/settings/*.dat \
	    torrents/config/rutorrent/profiles/settings/*/ \
	    torrents/config/rutorrent/profiles/tmp \
	    torrents/config/rutorrent/profiles/torrents \
	    torrents/config/rutorrent/profiles/users \
	    torrents/config/rutorrent/settings/users \
	    torrents/config/www \
	    torrents/data

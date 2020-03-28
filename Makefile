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

rutorrent: RUTORRENT_UID := $(shell id -u)
rutorrent: RUTORRENT_GID := $(shell id -g)
rutorrent: RUTORRENT_PORT ?= 80
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
	    torrents/config/rutorrent/profiles/settings/*.dat \
	    torrents/config/rutorrent/profiles/settings/*/ \
	    torrents/config/rutorrent/profiles/tmp \
	    torrents/config/rutorrent/profiles/torrents \
	    torrents/config/rutorrent/profiles/users \
	    torrents/config/rutorrent/settings/users \
	    torrents/config/www

cleaner: clean ## Remove all files
	rm -fr \
	    torrents/config/rtorrent/log \
	    torrents/config/rtorrent/session \
	    torrents/data

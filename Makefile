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

rutorrent: ## Start rutorrent container locally
	docker run \
	    --entrypoint /config/entrypoint.sh \
	    --env PGID=`id -g` \
	    --env PUID=`id -u` \
	    --interactive \
	    --name=rutorrent \
	    --publish 51413:51413 \
	    --publish 80:80 \
	    --rm \
	    --tty \
	    --volume "$(CURDIR)/music/.unsorted:/music/.unsorted" \
	    --volume "$(CURDIR)/torrent/config:/config" \
	    --volume "$(CURDIR)/torrent/data:/downloads" \
	    linuxserver/rutorrent

rutorrent-bash: ## Log in to a running ruTorrent container
	docker exec -it rutorrent bash

clean: ## Remove volatile files
	rm -fr \
	    music \
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

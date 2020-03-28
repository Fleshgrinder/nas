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
	exec docker exec -it rutorrent bash

clean: ## Remove volatile files
	exec bin/$@

cleaner: clean ## Remove all files
	exec bin/$@

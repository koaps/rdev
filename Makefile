.POSIX:
.PHONY: *
.EXPORT_ALL_VARIABLES:

name := rdev

vol := $(shell docker volume ls -qf name=${name}_home)

RUSER := koaps

.DEFAULT_GOAL := all

all: build up

NOPULL?=false

build:
	@if [ ${NOPULL} ]; then docker compose build; else docker compose pull && docker compose build --pull; fi

clean:
	sudo rm -rf /home/rdev || true

full_clean:
	docker rmi rdev:latest || true
	docker rmi rdev:base || true
	sudo rm -rf /home/rdev || true

down:
	docker compose down -v

push:
	docker compose push

rebuild: down build up

rebuild_clean: down clean build up

restart:
	docker restart ${name}

shell:
	docker exec -it ${name} /bin/bash

up:
	docker network inspect local >/dev/null 2>&1 && true || docker network create --subnet=172.16.16.0/24 local
	@if [ -z "${vol}" ]; then echo -n "creating home volume: "; docker volume create ${name}_home; fi
	docker compose up -d ${name}

name := rdev

vol := $(shell docker volume ls -qf name=${name}_node_modules)

.DEFAULT_GOAL := build

.PHONY: build
build:
	docker-compose pull
	docker-compose build --pull

.PHONY: down
down:
	docker-compose down -v

.PHONY: push
push:
	docker-compose push

.PHONY: up
up:
	docker network inspect local >/dev/null 2>&1 && true || docker network create --subnet=172.16.16.0/24 local
	@if [ -z "${vol}" ]; then echo -n "creating docker volume: "; docker volume create ${name}_node_modules; fi
	docker-compose up --force-recreate --remove-orphans -d ${name}

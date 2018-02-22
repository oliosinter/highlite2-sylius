PROJECT_NAME := highlite2

DEV_PROJECT := highlite2-dev
DEV_COMPOSE_FILE := docker-dev/docker-compose.yml

.PHONY: dev-build
dev-build: dev-remove
	docker volume create --name composer-cache
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) build mysql-agent
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) build --pull sylius-php-fpm
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) build frontend
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) build sylius-nginx
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) build sftp

	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) run --rm mysql-agent
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) run --rm -u www-data sylius-php-fpm composer install
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) run --rm -u www-data sylius-php-fpm php bin/console doctrine:migrations:migrate -n
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) run --rm -u www-data sylius-php-fpm php bin/console sylius:install:setup -n
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) run --rm --entrypoint build.sh -u www-data frontend

	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up -d sylius-nginx
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up -d sftp

.PHONY: dev-startdev
dev-start:
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up -d sylius-nginx
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up -d sftp

.PHONY: dev-stop
dev-stop:
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) stop

.PHONY: dev-remove
dev-remove:
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) down -v

.PHONY: dev-bash-frontend
dev-bash-frontend:
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) run --rm -u www-data frontend bash

.PHONY: dev-bash-php
dev-bash-php:
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) run --rm -u www-data sylius-php-fpm bash

# =================================================================================================

BUILD_PROJECT := $(PROJECT_NAME)-build
BUILD_COMPOSE_FILE := ci/build/docker-compose.yml

build-release:
	rm -f ci/build/artefacts/*.tar.gz
	docker volume create --name highlite2-sylius-composer-cache
	docker volume create --name highlite2-sylius-node-modules
	docker-compose -p $(BUILD_PROJECT) -f $(BUILD_COMPOSE_FILE) build builder
	docker-compose -p $(BUILD_PROJECT) -f $(BUILD_COMPOSE_FILE) up builder
	docker cp $$(docker-compose -p $(BUILD_PROJECT) -f $(BUILD_COMPOSE_FILE) ps -q builder):/var/www/vendor.tar.gz ci/build/artefacts/
	docker cp $$(docker-compose -p $(BUILD_PROJECT) -f $(BUILD_COMPOSE_FILE) ps -q builder):/var/www/assets.tar.gz ci/build/artefacts/
	docker cp $$(docker-compose -p $(BUILD_PROJECT) -f $(BUILD_COMPOSE_FILE) ps -q builder):/var/www/bundles.tar.gz ci/build/artefacts/
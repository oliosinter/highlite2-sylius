PROD_PROJECT := $(PROJECT_NAME)-ci-prod
PROD_COMPOSE_FILE := ci/prod/docker-compose.yml

PROD_SCALE_UP := 2
PROD_SCALE_DOWN := 2

ifeq (ci-prod-run,$(firstword $(MAKECMDGOALS)))
  PROD_MYSQL_CONTAINER_ID = $(shell docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) ps -q mysql)
endif

.PHONY: ci-prod-deploy
ci-prod-deploy:
	docker volume create --name highlite2-sylius-media
	docker volume create --name highlite2-sylius-mysql
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) run --rm mysql-agent
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) run --rm sylius-backend php bin/console doctrine:migrations:migrate -n
# Initial project setup. Need to run this script only once.
ifeq ($(PROD_MYSQL_CONTAINER_ID), )
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) run --rm sylius-backend php bin/console sylius:install:setup -n
endif
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) up --build -d --scale sylius-backend=$(PROD_SCALE_UP) sylius-backend
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) up --build -d --scale sylius-static=$(PROD_SCALE_UP) sylius-static
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) up -d proxy
	./ci/prod/deploy-switcher.sh
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) up -d --scale sylius-backend=$(PROD_SCALE_DOWN) sylius-backend
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) up -d --scale sylius-static=$(PROD_SCALE_DOWN) sylius-static

.PHONY: ci-prod-clean
ci-prod-clean:
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) down
	docker images -q -f dangling=true -f label=application=$(PROJECT_NAME) | xargs -I ARGS docker rmi -f ARGS
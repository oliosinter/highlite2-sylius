PROD_PROJECT := $(PROJECT_NAME)-ci-prod
PROD_COMPOSE_FILE := ci/prod/docker-compose.yml

PROD_MYSQL_CONTAINER_ID = $(shell docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) ps -q mysql)

.PHONY: ci-prod-run
ci-prod-run:
	docker volume create --name highlite2-sylius-media
	docker volume create --name highlite2-sylius-mysql
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) run --rm mysql-agent
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) run --rm sylius-backend php bin/console doctrine:migrations:migrate -n
# Initial project setup. Need to run this script only once.
ifeq ($(PROD_MYSQL_CONTAINER_ID), )
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) run --rm sylius-backend php bin/console sylius:install:setup -n
endif
#	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) run --rm sylius-backend php bin/console cache:warmup
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) up --build -d sylius-backend
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) up --build -d sylius-static
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) build  proxy
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) up -d proxy

.PHONY: ci-prod-clean
ci-prod-clean:
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) down
	docker images -q -f dangling=true -f label=application=$(PROJECT_NAME) | xargs -I ARGS docker rmi -f ARGS
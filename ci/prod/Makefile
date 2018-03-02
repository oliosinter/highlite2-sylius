PROD_PROJECT := $(PROJECT_NAME)-ci-prod
PROD_COMPOSE_FILE := ci/prod/docker-compose.yml

#PROD_PROXY_CONTAINER_ID = $(shell docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) ps -q proxy)

.PHONY: test
test:
	echo $(PROD_PROXY_CONTAINER_ID)

stop-proxy:
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) stop proxy
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) rm -f proxy

ci-prod-run:
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) run --rm mysql-agent
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) run --rm sylius-backend php bin/console doctrine:migrations:migrate -n
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) up --build -d sylius-backend
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) up --build -d sylius-static
#ifeq ($(PROD_PROXY_CONTAINER_ID), )
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) build  proxy
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) up -d proxy
#endif

ci-prod-clean:
	docker-compose -p $(PROD_PROJECT) -f $(PROD_COMPOSE_FILE) down
	docker images -q -f dangling=true -f label=application=$(PROJECT_NAME) | xargs -I ARGS docker rmi -f ARGS
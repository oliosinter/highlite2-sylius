BUILD_PROJECT := $(PROJECT_NAME)-build
BUILD_COMPOSE_FILE := ci/release/docker-compose.yml

.PHONY: ci-release-build
ci-release-build:
	docker volume create --name highlite2-sylius-composer-cache
	docker volume create --name highlite2-sylius-node-modules
	docker-compose -p $(BUILD_PROJECT) -f $(BUILD_COMPOSE_FILE) up --build builder
	${CHECK} $(BUILD_PROJECT) $(BUILD_COMPOSE_FILE) builder
	mkdir -p ci/release/artefacts
	docker cp $$(docker-compose -p $(BUILD_PROJECT) -f $(BUILD_COMPOSE_FILE) ps -q builder):/var/www/vendor.tar ci/release/artefacts
	docker cp $$(docker-compose -p $(BUILD_PROJECT) -f $(BUILD_COMPOSE_FILE) ps -q builder):/var/www/assets.tar ci/release/artefacts
	docker cp $$(docker-compose -p $(BUILD_PROJECT) -f $(BUILD_COMPOSE_FILE) ps -q builder):/var/www/bundles.tar ci/release/artefacts
	docker-compose -p $(BUILD_PROJECT) -f $(BUILD_COMPOSE_FILE) build backend
	docker-compose -p $(BUILD_PROJECT) -f $(BUILD_COMPOSE_FILE) build static

.PHONY: ci-release-build
ci-release-clean:
	rm -rf ci/release/artefacts
	docker-compose -p $(BUILD_PROJECT) -f $(BUILD_COMPOSE_FILE) down -v
	docker images -q -f dangling=true -f label=application=$(PROJECT_NAME) | xargs -I ARGS docker rmi -f ARGS
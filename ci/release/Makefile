ORG_NAME ?= highlite2

# Use these settings to specify a custom Docker registry
DOCKER_REGISTRY ?= docker.io
# WARNING: Set DOCKER_REGISTRY_AUTH to empty for Docker Hub
# Set DOCKER_REGISTRY_AUTH to auth endpoint for private Docker registry
DOCKER_REGISTRY_AUTH ?=

RELEASE_PROJECT := $(PROJECT_NAME)-ci-release
RELEASE_COMPOSE_FILE := ci/release/docker-compose.yml

# Backend service properties
RELEASE_BACKEND_REPO_NAME := sylius-backend
RELEASE_BACKEND_CONTAINER_ID := $$(docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) ps -q $(RELEASE_BACKEND_REPO_NAME))
RELEASE_BACKEND_IMAGE_ID := $$(docker inspect -f '{{ .Image }}' $(RELEASE_BACKEND_CONTAINER_ID))
# Change to  $(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME)[^[:space:]|\$$]* for provite docker registry
RELEASE_BACKEND_REPO_FILTER := $(ORG_NAME)/$(RELEASE_BACKEND_REPO_NAME)[^[:space:]|\$$]*
RELEASE_BACKEND_REPO_EXPR := $$(docker inspect -f '{{range .RepoTags}}{{.}} {{end}}' $(RELEASE_BACKEND_IMAGE_ID) | grep -oh "$(RELEASE_BACKEND_REPO_FILTER)" | xargs)

# Static service properties
RELEASE_STATIC_REPO_NAME := sylius-static
RELEASE_STATIC_CONTAINER_ID := $$(docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) ps -q $(RELEASE_STATIC_REPO_NAME))
RELEASE_STATIC_IMAGE_ID := $$(docker inspect -f '{{ .Image }}' $(RELEASE_STATIC_CONTAINER_ID))
# Change to  $(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME)[^[:space:]|\$$]* for provite docker registry
RELEASE_STATIC_REPO_FILTER := $(ORG_NAME)/$(RELEASE_STATIC_REPO_NAME)[^[:space:]|\$$]*
RELEASE_STATIC_REPO_EXPR := $$(docker inspect -f '{{range .RepoTags}}{{.}} {{end}}' $(RELEASE_STATIC_IMAGE_ID) | grep -oh "$(RELEASE_STATIC_REPO_FILTER)" | xargs)

.PHONY: ci-release-build
ci-release-build:
	docker volume create --name highlite2-sylius-composer-cache
	docker volume create --name highlite2-sylius-node-modules
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) up --build builder
	${CHECK} $(RELEASE_PROJECT) $(RELEASE_COMPOSE_FILE) builder
	mkdir -p ci/release/artefacts
	docker cp $$(docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) ps -q builder):/var/www/vendor.tar ci/release/artefacts
	docker cp $$(docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) ps -q builder):/var/www/assets.tar ci/release/artefacts
	docker cp $$(docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) ps -q builder):/var/www/bundles.tar ci/release/artefacts
	docker cp $$(docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) ps -q builder):/var/www/html/app/rev-manifest.json ci/release/artefacts
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) up --build -d $(RELEASE_BACKEND_REPO_NAME)
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) up --build -d $(RELEASE_STATIC_REPO_NAME)

.PHONY: ci-release-clean
ci-release-clean:
	rm -rf ci/release/artefacts
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) down -v
	docker images -q -f dangling=true -f label=application=$(PROJECT_NAME) | xargs -I ARGS docker rmi -f ARGS

.PHONY: ci-release-tag
ci-release-tag:
	$(foreach tag,$(TAG_ARGS), docker tag $(RELEASE_BACKEND_IMAGE_ID) $(DOCKER_REGISTRY)/$(ORG_NAME)/$(RELEASE_BACKEND_REPO_NAME):$(tag);)
	$(foreach tag,$(TAG_ARGS), docker tag $(RELEASE_STATIC_IMAGE_ID) $(DOCKER_REGISTRY)/$(ORG_NAME)/$(RELEASE_STATIC_REPO_NAME):$(tag);)

.PHONY: ci-release-login
ci-release-login:
	docker login -u $$DOCKER_USER -p $$DOCKER_PASSWORD $$DOCKER_REGISTRY_AUTH

.PHONY: ci-release-logout
ci-release-logout:
	docker logout

.PHONY: ci-release-publish
ci-release-publish:
	$(foreach tag,$(shell echo $(RELEASE_BACKEND_REPO_EXPR)), docker push $(tag);)
	$(foreach tag,$(shell echo $(RELEASE_STATIC_REPO_EXPR)), docker push $(tag);)

# Extract tag arguments
ifeq (ci-release-tag,$(firstword $(MAKECMDGOALS)))
  TAG_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  ifeq ($(TAG_ARGS),)
    $(error You must specify a tag)
  endif
  $(eval $(TAG_ARGS):;@:)
endif
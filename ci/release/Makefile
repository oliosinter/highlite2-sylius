ORG_NAME ?= highlite2

# Use these settings to specify a custom Docker registry
DOCKER_REGISTRY ?= docker.io

RELEASE_PROJECT := $(PROJECT_NAME)-release
RELEASE_COMPOSE_FILE := ci/release/docker-compose.yml

# SERVICES PROPERTIES
# -----------------------------------------------------------------------------
RELEASE_BACKEND_CONTAINER_ID := $$(docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) ps -q backend)
RELEASE_BACKEND_IMAGE_ID := $$(docker inspect -f '{{ .Image }}' $(RELEASE_BACKEND_CONTAINER_ID))
RELEASE_BACKEND_REPO_NAME := sylius-backend

RELEASE_STATIC_CONTAINER_ID := $$(docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) ps -q static)
RELEASE_STATIC_IMAGE_ID := $$(docker inspect -f '{{ .Image }}' $(RELEASE_STATIC_CONTAINER_ID))
RELEASE_STATIC_REPO_NAME := sylius-static

# BUILD TAGS PROPERTIES
# -----------------------------------------------------------------------------
# Build tag expression - can be used to evaulate a shell expression at runtime
BUILD_TAG_EXPRESSION ?= date -u +%Y%m%d%H%M%S
# Execute shell expression
BUILD_EXPRESSION := $(shell $(BUILD_TAG_EXPRESSION))
# Build tag - defaults to BUILD_EXPRESSION if not defined
BUILD_TAG ?= $(BUILD_EXPRESSION)

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
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) up --build -d backend
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) up --build -d static

.PHONY: ci-release-clean
ci-release-clean:
	rm -rf ci/release/artefacts
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) down -v
	docker images -q -f dangling=true -f label=application=$(PROJECT_NAME) | xargs -I ARGS docker rmi -f ARGS

.PHONY: ci-release-tag
ci-release-tag:
	$(foreach tag,$(TAG_ARGS), docker tag $(RELEASE_BACKEND_IMAGE_ID) $(DOCKER_REGISTRY)/$(ORG_NAME)/$(RELEASE_BACKEND_REPO_NAME):$(tag);)
	$(foreach tag,$(TAG_ARGS), docker tag $(RELEASE_STATIC_IMAGE_ID) $(DOCKER_REGISTRY)/$(ORG_NAME)/$(RELEASE_STATIC_REPO_NAME):$(tag);)

.PHONY: ci-release-buildtag
ci-release-buildtag:
	$(foreach tag,$(BUILDTAG_ARGS), docker tag $(RELEASE_BACKEND_IMAGE_ID) $(DOCKER_REGISTRY)/$(ORG_NAME)/$(RELEASE_BACKEND_REPO_NAME):$(tag).$(BUILD_TAG);)
	$(foreach tag,$(BUILDTAG_ARGS), docker tag $(RELEASE_STATIC_IMAGE_ID) $(DOCKER_REGISTRY)/$(ORG_NAME)/$(RELEASE_STATIC_REPO_NAME):$(tag).$(BUILD_TAG);)

# Extract build tag arguments
ifeq (ci-release-buildtag,$(firstword $(MAKECMDGOALS)))
  BUILDTAG_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  ifeq ($(BUILDTAG_ARGS),)
    $(error You must specify a tag)
  endif
  $(eval $(BUILDTAG_ARGS):;@:)
endif

# Extract tag arguments
ifeq (ci-release-tag,$(firstword $(MAKECMDGOALS)))
  TAG_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  ifeq ($(TAG_ARGS),)
    $(error You must specify a tag)
  endif
  $(eval $(TAG_ARGS):;@:)
endif
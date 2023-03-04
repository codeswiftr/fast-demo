ifneq (,$(wildcard ./.env))
	include .env
	export
endif

IMAGE_NAME = $(shell basename "`pwd`")
IMAGE_TAG = $(shell poetry version -s)
REGISTRY = $(shell echo $(REGISTRY_HOST))
IMAGE = $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: help

help: ## Show this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ \
	{ printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ \
	{ printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

install: ## Install the dependencies
	docker-compose build

run: ## Run the application
	docker-compose up

test: ## Run the tests
	docker-compose run --rm app pytest

lint: ## Lint the code
	docker-compose run --rm app pylint main.py

clean: ## Clean up the containers and files
	docker-compose down --volumes
	rm -rf __pycache__
	rm -f *.log

build: ## Build the Docker image
	docker buildx build --platform linux/amd64 -t $(IMAGE) --load .

push: ## Push the image to a registry
	docker login $(REGISTRY_HOST) -u $(REGISTRY_USERNAME) -p $(REGISTRY_PASSWORD)
	docker push $(IMAGE)

bump_version: ## Bump the version in pyproject.toml
	@poetry version $(version)

bump_minor:
	make bump_version version=minor

bump_patch:
	make bump_version version=patch

bump_major:
	make bump_version version=major


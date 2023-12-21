# Makefile for node container app using docker
#

# Variables
DOCKER_IMAGE_NAME = loom-downloader
DOCKER_CONTAINER_NAME = loom-downloader

# Help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  build       to build docker image"
	@echo "  run         to run docker container"
	@echo "  stop        to stop docker container"
	@echo "  rm          to remove docker container"
	@echo "  rmi         to remove docker image"
	@echo "  run-bash    to run docker container with bash"
	@echo "  logs        to show docker container logs"
	@echo "  stats       to show docker container stats"

# Build docker image
build:
	@docker build -t $(DOCKER_IMAGE_NAME) .

# Run docker container with the same user and group as the host
run:
	@docker run \
		--rm \
		--name $(DOCKER_CONTAINER_NAME) \
		-v $(PWD)/output:/usr/src/app/output \
		-u $(shell id -u):$(shell id -g) \
		-d \
		$(DOCKER_IMAGE_NAME)
r: 
	@docker run \
		--rm \
		--name $(DOCKER_CONTAINER_NAME) \
		-v $(PWD)/output:/usr/src/app/output \
		-v $(PWD)/urls.txt:/usr/src/app/urls.txt \
		-u $(shell id -u):$(shell id -g) \
		$(DOCKER_IMAGE_NAME) \
		--list urls.txt \
		--prefix download \
		--out output
rl:
	node loom-dl.js --list urls.txt --prefix download --out output

# Stop docker container
stop:
	@docker stop $(DOCKER_CONTAINER_NAME)

# Remove docker container
rm:
	@docker rm $(DOCKER_CONTAINER_NAME)

# Remove docker image
rmi:
	@docker rmi $(DOCKER_IMAGE_NAME)

# Run docker container with bash
run-bash:
	@docker run --name $(DOCKER_CONTAINER_NAME) -it $(DOCKER_IMAGE_NAME) /bin/bash

# Show docker container logs
logs:
	@docker logs $(DOCKER_CONTAINER_NAME)

# Show docker container stats
stats:
	@docker stats $(DOCKER_CONTAINER_NAME)
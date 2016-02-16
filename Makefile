# GENERIC VARIABLES
PWD=$(shell pwd)

# DOCKER VARIABLES
DOCKER_NAME=jupyter-playground

all: help

.PHONY: help

help:
	@echo "USAGE: make [COMMAND]"
	@echo ""
	@echo "Commands: (default: help)"
	@echo "    help                                  Displays this help"
	@echo "    tests                                 Runs tests"
	@echo "    start (theme=[THEME])                 Starts the docker runtime environment up"
	@echo "    seed                                  Does nothing for now..."
	@echo "    stop                                  Shuts the docker runtime environment down"
	@echo "    teardown                              Stops the environment, then removes the containers"

tests:
	nosetests

run: validateargs
	docker build --build-arg THEME=$(theme) -t $(DOCKER_NAME) .
	docker run -d \
			-p 8888:8888 \
			-v $(PWD)/notebooks:/src/ \
			--name $(DOCKER_NAME) \
			$(DOCKER_NAME)

start: validateargs

seed:

stop:
	docker stop $(DOCKER_NAME)

teardown:
	docker kill $(DOCKER_NAME)
	docker rm -f $(DOCKER_NAME)

validateargs:
	@if [ "${theme}" = "" ]; then \
		theme="midnight"; \
	fi
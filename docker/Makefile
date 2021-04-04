#!make
MAKEFLAGS  	+= --silent
SHELL      	 = /bin/bash

cnfp ?= ../.env.private
ifneq ($(wildcard $(cnfp)),)
	include $(cnfp)
	export $(shell sed 's/=.*//' $(cnfp))
endif

cnf ?= ../.env.project
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

export env
export PROJECT_NAME

PROJECT_NAME  := $(shell basename $(shell git rev-parse --show-toplevel))
BRANCH_NAME   := $(shell git rev-parse --abbrev-ref HEAD)
COMMIT_SHA    := $(shell git rev-parse --short HEAD)

env := ${BRANCH_NAME}

.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

docker-login: ## Login in registry
	echo ${IMAGE_REGISTRY_TOKEN} | docker login -u ${IMAGE_REGISTRY_USERNAME} --password-stdin ${IMAGE_REGISTRY}

docker-build: ## build images in spark-applications
	bash ./build.sh ${IMAGE_REGISTRY_USERNAME}

docker-publish: docker-login ## push images in registry
	bash ./publish.sh ${IMAGE_REGISTRY_USERNAME}
	docker logout
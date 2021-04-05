#!make
MAKEFLAGS  	+= --silent
SHELL      	 = /bin/bash

cnfp ?= .env.private
ifneq ($(wildcard $(cnfp)),)
	include $(cnfp)
	export $(shell sed 's/=.*//' $(cnfp))
endif

cnf ?= .env.project
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

export env
export PROJECT_NAME

PROJECT_NAME  := $(shell basename $(CURDIR))


# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup-local-install-binaries: ## Execute install kind k8s and binaries utilitys
	echo "STEP: setup-local-install-binaries - Install kind k8s and binaries utilitys"
	sudo bash ./kubernetes/local-setup/scripts/00-local-setup.sh

setup-local-init-kind: ## Initiate cluster k8s with kind
	echo "STEP: setup-local-init-kind - Initiate cluster kind"
	sed 's/CLUSTER_NAME/${PROJECT_NAME}/g' ${KIND_CONFIG_FILE}.tmpl > ${KIND_CONFIG_FILE}
	kind create cluster --config=${KIND_CONFIG_FILE}
	rm -rf ${KIND_CONFIG_FILE}

setup-local-cleanup: ## Cleanup environment
	echo "STEP: setup-local-cleanup - Destroy cluster kind"
	kind delete cluster --name=${PROJECT_NAME}

setup-k8s-spark-operator: ## Install spark-operator
	echo "STEP: setup-k8s-spark-operator - Install spark-operator"
	bash spark-operator/install-spark-operator.sh

setup-auxiliaries-minio-operator: ## Install minio-operator
	echo "STEP: setup-auxiliaries-minio-operator - Install minio-operator"
	bash ./kubernetes/auxiliaries-setup/01-minio.sh "${MINIO_ACCESS_KEY}" "${MINIO_SECRET_KEY}"

setup-k8s-dashboard: ## Setup dashboard for k8s investigate
	echo "STEP: setup-k8s-dashboard - Setup dashboard"
	bash ./kubernetes/local-setup/scripts/101-setup-dashboard.sh

setup-k8s-airflow-operator: ## Install airflow-operator
	echo "STEP: setup-k8s-airflow-operator - Install minio-operator"
	bash ./airflow-operator/01-airflow.sh ${AIRFLOW_USERNAME} ${AIRFLOW_PASSWORD} ${AIRFLOW_DAGS_URL_REPOSITORY} ${AIRFLOW_DAGS_BRANCH} ${AIRFLOW_DAGS_NAME}

k8s-port-foward-minio: ## Port Foward to access minio console
	echo "STEP: k8s-port-foward-minio - Port Foward to access minio console"
	echo "MinIO(R) web URL: http://127.0.0.1:9000/minio"
	while true; do kubectl port-forward --namespace minio-operator svc/minio 9000:9000; done

k8s-port-foward-airflow: ## Port Foward to access airflow console
	echo "STEP: k8s-port-foward-airflow - Port Foward to access airflow console"
	echo "Airflow web URL: http://127.0.0.1:8080"
	while true; do kubectl port-forward --namespace airflow-operator svc/airflow 8080:8080; done

k8s-proxy-dashboard: ## Kubeclt proxy for access dashboard
	echo "STEP: k8s-proxy-dashboard - Kubeclt proxy for access dashboard"
	echo "dashboard web URL: http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login"
	kubectl proxy

dashboard: setup-k8s-dashboard k8s-proxy-dashboard ## setup-k8s-dashboard + k8s-proxy-dashboard
setup-local: setup-local-install-binaries setup-local-init-kind ## Setup environment to running k8s locally - Install binaries and initi k8s kind
setup-k8s: setup-k8s-spark-operator ## Setup k8s - spark-operator
setup-auxiliaries: setup-auxiliaries-minio-operator ## Setup auxiliaries - Minio Operator
setup: setup-local setup-k8s setup-auxiliaries setup-k8s-airflow-operator ## Setup environment - setup-local -> setup-k8s -> setup-auxiliaries -> setup-k8s-airflow-operator
clean: setup-local-cleanup ## alias for setup-local-cleanup

build:
	$(MAKE) -C docker/ docker-build
publish:
	$(MAKE) -C docker/ docker-publish

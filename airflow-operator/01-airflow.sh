#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
RELEASE_NAME=airflow
NAMESPACE=airflow-operator
CHART_VERSION=8.2.1

AIRFLOW_USERNAME=${1}
AIRFLOW_PASSWORD=${2}

AIRFLOW_DAGS_URL_REPOSITORY=${3}
AIRFLOW_DAGS_BRANCH=${4}
AIRFLOW_DAGS_NAME=${5}

echo "kubectl create namespaces for airflow"
kubectl apply -f ./$BASEDIR/airflow-namespace.yml

echo "Helm add repository airflow-operator"
helm repo add bitnami https://charts.bitnami.com/bitnami

echo "Helm install airflow-operator"
helm install \
  $RELEASE_NAME \
  bitnami/airflow \
  --namespace $NAMESPACE \
  --version $CHART_VERSION \
  --set auth.username=${AIRFLOW_USERNAME} \
  --set auth.password=${AIRFLOW_PASSWORD} \
  --set git.dags.enabled=true \
  --set git.dags.repositories[0].repository=${AIRFLOW_DAGS_URL_REPOSITORY}  \
  --set git.dags.repositories[0].branch=${AIRFLOW_DAGS_BRANCH} \
  --set git.dags.repositories[0].name=${AIRFLOW_DAGS_NAME} \
  --set git.dags.repositories[0].path="airflow-operator/dags" \
  --set git.sync.interval=60 \
  --set rbac.create=true

echo "kubectl create rolebinding for use spark"
kubectl apply -f ./$BASEDIR/airflow-rbac.yml

echo "Setup finish"

# kubectl get all --namespace=airflow-operator
# kubectl exec --stdin --tty airflow-worker-0 --namespace=airflow-operator -- /bin/bash
# make setup-k8s-airflow-operator
# make k8s-port-foward-airflow
# helm uninstall airflow --namespace=airflow-operator
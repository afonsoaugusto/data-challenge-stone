#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
RELEASE_NAME=spark
NAMESPACE=spark-operator

echo "kubectl create namespaces for spark"
kubectl apply -f ./$BASEDIR/spark-namespaces.yml

echo "Helm add repository spark-operator"
helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator

echo "Helm install spark-operator"
helm install \
     $RELEASE_NAME \
     spark-operator/spark-operator \
     --namespace $NAMESPACE \
     --set sparkJobNamespace=spark-job

echo "Setup finish"

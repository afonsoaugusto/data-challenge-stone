#!/usr/bin/env bash

BASEDIR=$(dirname "$0")

echo "kubectl create namespaces for spark"
kubectl apply -f ./$BASEDIR/spark-namespaces.yml

echo "Helm add repository spark-operator"
helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator

echo "Helm install spark-operator"
helm install \
     spark \
     spark-operator/spark-operator \
     --namespace spark-operator \
     --set sparkJobNamespace=spark-job

echo "Setup finish"

#!/usr/bin/env bash

BASEDIR=$(dirname "$0")

MINIO_ACCESS_KEY=$1
MINIO_SECRET_KEY=$2

echo "kubectl create namespaces for minio"
kubectl apply -f ./$BASEDIR/minio-namespace.yml

echo "Helm add repository minio-operator"
helm repo add bitnami https://charts.bitnami.com/bitnami

echo "Helm install minio-operator"
helm install \
     minio \
     bitnami/minio \
     --namespace minio-operator \
     --set accessKey.password="${MINIO_ACCESS_KEY}" \
     --set secretKey.password="${MINIO_SECRET_KEY}" \
     --set mode=standalone \
     --set statefulset.replicaCount=4

# echo "Set alias for mc-client"
mc alias set minio-local http://localhost:9000 "${MINIO_ACCESS_KEY}" "${MINIO_SECRET_KEY}" --api s3v4

# bash kubernetes/auxiliaries-setup/01-minio.sh "${MINIO_ACCESS_KEY}" "${MINIO_SECRET_KEY}"
#minio.minio-operator.svc.cluster.local
echo "Setup finish"

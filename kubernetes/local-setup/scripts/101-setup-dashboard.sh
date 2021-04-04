#!/usr/bin/env bash

echo "Setup Dashboard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml
kubectl create serviceaccount -n kube-system cluster-admin-dashboard-sa

# Bind ClusterAdmin role to the service account
kubectl create clusterrolebinding -n kube-system cluster-admin-dashboard-sa \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:cluster-admin-dashboard-sa

# Parse the token
TOKEN=$(kubectl describe secret -n kube-system $(kubectl get secret -n kube-system | awk '/^cluster-admin-dashboard-sa-token-/{print $1}') | awk '$1=="token:"{print $2}')
echo $TOKEN

echo "Setup finish"

#!/bin/sh

KIND_VERSION=v0.10.0

echo "Install kind in version ${KIND_VERSION}"
curl -s -Lo ./kind https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64 &&\
chmod +x ./kind &&\
mv ./kind /usr/local/bin/kind
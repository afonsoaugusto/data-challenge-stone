#!/bin/sh

KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

echo "Install Kubectl in version ${KUBECTL_VERSION}"
curl -s -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"  &&\
chmod +x ./kubectl &&\
mv ./kubectl /usr/local/bin/kubectl
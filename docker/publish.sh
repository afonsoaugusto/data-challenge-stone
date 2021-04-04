#!/usr/bin/env bash

BASEDIR=$(dirname "$0")

IMAGE_REGISTRY_USERNAME=${1}

for application in $(ls ../spark-applications); do
    echo "push $application"
    docker push ${IMAGE_REGISTRY_USERNAME}/${application}:latest
done

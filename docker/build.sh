#!/usr/bin/env bash

BASEDIR=$(dirname "$0")

IMAGE_REGISTRY_USERNAME=${1}

for application in $(ls ../spark-applications); do
    echo "build $application"
    docker build -t ${IMAGE_REGISTRY_USERNAME}/${application}:latest \
                 -f ../spark-applications/${application}/Dockerfile \
                 ../spark-applications/${application}/
done

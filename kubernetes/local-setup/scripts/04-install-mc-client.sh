#!/usr/bin/env bash

BASEDIR=$(dirname "$0")

echo "Install mc-client"
curl -s -Lo ./mc https://dl.min.io/client/mc/release/linux-amd64/mc &&\
chmod +x mc &&\
mv ./mc /usr/local/bin/mc

# echo "Set alias for mc-client"
# mc alias set minio-local http://localhost:9000 "${MINIO_ACCESS_KEY}" "${MINIO_SECRET_KEY}" --api s3v4

echo "Setup finish"

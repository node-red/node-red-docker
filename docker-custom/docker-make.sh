#!/bin/bash
export NODE_RED_VERSION=$(grep -Eo "\"node-red\": \"(\w*.\w*.\w*)" package.json | cut -d\" -f4)
sed "s/\(version\": \"\).*\(\"\)/\1$NODE_RED_VERSION\"/g" package.json > tmpfile && mv tmpfile package.json

echo "### Update version ######################################################"
echo "node-red version: ${NODE_RED_VERSION}"
echo "#########################################################################"

docker build --no-cache \
    --build-arg ARCH=amd64 \
    --build-arg NODE_VERSION=12 \
    --build-arg NODE_RED_VERSION=${NODE_RED_VERSION} \
    --build-arg OS=alpine \
    --build-arg BUILD_DATE="$(date +"%Y-%m-%dT%H:%M:%SZ")" \
    --build-arg PYTHON_VERSION=0 \
    --build-arg DEVTOOLS=0 \
    --file Dockerfile-alpine.custom \
    --tag testing:node-red-build .

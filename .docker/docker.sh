#!/bin/bash

set -o errexit

main() {
    case $1 in
        "prepare")
            docker_prepare
            ;;
        "build")
            docker_build
            ;;
        "tag")
            docker_tag
            ;;
        "push")
            docker_push
            ;;
        "manifest-list")
            docker_manifest-list
            ;;
        *)
            echo "none of above!"
    esac
}

docker_prepare() {
    # Prepare the machine before any code installation scripts
    ./.travis/main.sh

    # Prepare qemu
    docker run --rm --privileged multiarch/qemu-user-static:register --reset
    mkdir tmp
    pushd tmp &&
    curl -L -o qemu-x86_64-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/$QEMU_VERSION/qemu-x86_64-static.tar.gz && tar xzf qemu-x86_64-static.tar.gz &&
    curl -L -o qemu-arm-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/$QEMU_VERSION/qemu-arm-static.tar.gz && tar xzf qemu-arm-static.tar.gz &&
    curl -L -o qemu-aarch64-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/$QEMU_VERSION/qemu-aarch64-static.tar.gz && tar xzf qemu-aarch64-static.tar.gz &&
    popd
}

docker_build() {
    echo "DOCKER BUILD: Build all docker images."
    # node v6 images
    docker build --no-cache --build-arg ARCH=amd64   --build-arg NODE_VERSION=6-slim   --build-arg QEMU_ARCH=x86_64  --file ./.docker/Dockerfile.template-debian --tag $IMAGE:latest-v6-linux-amd64 .
    # docker build --no-cache --build-arg ARCH=arm32v6 --build-arg NODE_VERSION=6-alpine --build-arg QEMU_ARCH=arm     --file ./.docker/Dockerfile.template-alpine --tag $IMAGE:latest-v6-linux-arm32v6 .
    docker build --no-cache --build-arg ARCH=arm32v7 --build-arg NODE_VERSION=6-slim   --build-arg QEMU_ARCH=arm     --file ./.docker/Dockerfile.template-debian --tag $IMAGE:latest-v6-linux-arm32v7 .
    docker build --no-cache  --build-arg ARCH=arm64v8 --build-arg NODE_VERSION=6-slim   --build-arg QEMU_ARCH=aarch64 --file ./.docker/Dockerfile.template-debian --tag $IMAGE:latest-v6-linux-arm64v8 .

    # node v8 images
    docker build --no-cache --build-arg ARCH=amd64   --build-arg NODE_VERSION=8-slim   --build-arg QEMU_ARCH=x86_64 --file ./.docker/Dockerfile.template-debian --tag $IMAGE:latest-v8-linux-amd64 .
    docker build --no-cache --build-arg ARCH=arm32v6 --build-arg NODE_VERSION=8-alpine --build-arg QEMU_ARCH=arm    --file ./.docker/Dockerfile.template-alpine --tag $IMAGE:latest-v8-linux-arm32v6 .
    docker build --no-cache --build-arg ARCH=arm32v7 --build-arg NODE_VERSION=8-slim   --build-arg QEMU_ARCH=arm    --file ./.docker/Dockerfile.template-debian --tag $IMAGE:latest-v8-linux-arm32v7 .
    docker build --no-cache --build-arg ARCH=arm64v8 --build-arg NODE_VERSION=8-slim   --build-arg QEMU_ARCH=aarch64 --file ./.docker/Dockerfile.template-debian --tag $IMAGE:latest-v8-linux-arm64v8 .
}

docker_tag() {
    echo "DOCKER TAG: Tag all docker images."
    # Tag node v6 images
    docker tag $IMAGE:latest-v6-linux-amd64 $IMAGE:$NODE_RED_VERSION-v6-linux-amd64
    #docker tag $IMAGE:latest-v6-linux-arm32v6 $IMAGE:$NODE_RED_VERSION-v6-linux-arm32v6
    docker tag $IMAGE:latest-v6-linux-arm32v7 $IMAGE:$NODE_RED_VERSION-v6-linux-arm32v7
    docker tag $IMAGE:latest-v6-linux-arm64v8 $IMAGE:$NODE_RED_VERSION-v6-linux-arm64v8

    # Tag node v8 images
    docker tag $IMAGE:latest-v8-linux-amd64 $IMAGE:$NODE_RED_VERSION-v8-linux-amd64
    docker tag $IMAGE:latest-v8-linux-arm32v6 $IMAGE:$NODE_RED_VERSION-v8-linux-arm32v6
    docker tag $IMAGE:latest-v8-linux-arm32v7 $IMAGE:$NODE_RED_VERSION-v8-linux-arm32v7
    docker tag $IMAGE:latest-v8-linux-arm64v8 $IMAGE:$NODE_RED_VERSION-v8-linux-arm64v8
    echo "DOCKER TAG: Done! All docker images are tagged."
}

docker_push() {
    echo "DOCKER PUSH: Push all docker images."
    # Push node v6 images
    docker push $IMAGE:latest-v6-linux-amd64
    docker push $IMAGE:$NODE_RED_VERSION-v6-linux-amd64

    #docker push $IMAGE:latest-v6-linux-arm32v6
    #docker push $IMAGE:$NODE_RED_VERSION-v6-linux-arm32v6

    docker push $IMAGE:latest-v6-linux-arm32v7
    docker push $IMAGE:$NODE_RED_VERSION-v6-linux-arm32v7

    docker push $IMAGE:latest-v6-linux-arm64v8
    docker push $IMAGE:$NODE_RED_VERSION-v6-linux-arm64v8

    # Push node v8 images
    docker push $IMAGE:latest-v8-linux-amd64
    docker push $IMAGE:$NODE_RED_VERSION-v8-linux-amd64

    docker push $IMAGE:latest-v8-linux-arm32v6
    docker push $IMAGE:$NODE_RED_VERSION-v8-linux-arm32v6

    docker push $IMAGE:latest-v8-linux-arm32v7
    docker push $IMAGE:$NODE_RED_VERSION-v8-linux-arm32v7

    docker push $IMAGE:latest-v8-linux-arm64v8
    docker push $IMAGE:$NODE_RED_VERSION-v8-linux-arm64v8
    echo "DOCKER PUSH: Done! All docker images are pushed."
}

docker_manifest-list() {
    echo "DOCKER MANIFEST: Create and Push docker manifest list."

    # Manifest Create v6
    docker manifest create $IMAGE:$NODE_RED_VERSION-v6 \
      $IMAGE:$NODE_RED_VERSION-v6-linux-amd64 \
      $IMAGE:$NODE_RED_VERSION-v6-linux-arm32v7 \
      $IMAGE:$NODE_RED_VERSION-v6-linux-arm64v8

    # Manifest Annotate v6
    #docker manifest annotate $IMAGE:$NODE_RED_VERSION-v6 $IMAGE:$NODE_RED_VERSION-v6-linux-arm32v6 --os=linux --arch=arm --variant=v6
    docker manifest annotate $IMAGE:$NODE_RED_VERSION-v6 $IMAGE:$NODE_RED_VERSION-v6-linux-arm32v7 --os=linux --arch=arm --variant=v7
    docker manifest annotate $IMAGE:$NODE_RED_VERSION-v6 $IMAGE:$NODE_RED_VERSION-v6-linux-arm64v8 --os=linux --arch=arm64 --variant=v8

    # Manifest Push v6
    docker manifest push $IMAGE:$NODE_RED_VERSION-v6

    # Manifest Create v8
    docker manifest create $IMAGE:$NODE_RED_VERSION-v8 \
      $IMAGE:$NODE_RED_VERSION-v8-linux-amd64 \
      $IMAGE:$NODE_RED_VERSION-v8-linux-arm32v6 \
      $IMAGE:$NODE_RED_VERSION-v8-linux-arm32v7 \
      $IMAGE:$NODE_RED_VERSION-v8-linux-arm64v8

    # Manifest Annotate v8
    docker manifest annotate $IMAGE:$NODE_RED_VERSION-v8 $IMAGE:$NODE_RED_VERSION-v8-linux-arm32v6 --os=linux --arch=arm --variant=v6
    docker manifest annotate $IMAGE:$NODE_RED_VERSION-v8 $IMAGE:$NODE_RED_VERSION-v8-linux-arm32v7 --os=linux --arch=arm --variant=v7
    docker manifest annotate $IMAGE:$NODE_RED_VERSION-v8 $IMAGE:$NODE_RED_VERSION-v8-linux-arm64v8 --os=linux --arch=arm64 --variant=v8

    # Manifest Push v8
    docker manifest push $IMAGE:$NODE_RED_VERSION-v8

    # Manifest Create NODE_RED_VERSION
    docker manifest create $IMAGE:$NODE_RED_VERSION \
      $IMAGE:$NODE_RED_VERSION-v8-linux-amd64 \
      $IMAGE:$NODE_RED_VERSION-v8-linux-arm32v6 \
      $IMAGE:$NODE_RED_VERSION-v8-linux-arm32v7 \
      $IMAGE:$NODE_RED_VERSION-v8-linux-arm64v8

    # Manifest Annotate NODE_RED_VERSION
    docker manifest annotate $IMAGE:$NODE_RED_VERSION $IMAGE:$NODE_RED_VERSION-v8-linux-arm32v6 --os=linux --arch=arm --variant=v6
    docker manifest annotate $IMAGE:$NODE_RED_VERSION $IMAGE:$NODE_RED_VERSION-v8-linux-arm32v7 --os=linux --arch=arm --variant=v7
    docker manifest annotate $IMAGE:$NODE_RED_VERSION $IMAGE:$NODE_RED_VERSION-v8-linux-arm64v8 --os=linux --arch=arm64 --variant=v8

    # Manifest Push NODE_RED_VERSION
    docker manifest push $IMAGE:$NODE_RED_VERSION

    # Manifest Create LATEST
    docker manifest create $IMAGE:latest \
      $IMAGE:latest-v8-linux-amd64 \
      $IMAGE:latest-v8-linux-arm32v6 \
      $IMAGE:latest-v8-linux-arm32v7 \
      $IMAGE:latest-v8-linux-arm64v8

    # Manifest Annotate LATEST
    docker manifest annotate $IMAGE:latest $IMAGE:latest-v8-linux-arm32v6 --os=linux --arch=arm --variant=v6
    docker manifest annotate $IMAGE:latest $IMAGE:latest-v8-linux-arm32v7 --os=linux --arch=arm --variant=v7
    docker manifest annotate $IMAGE:latest $IMAGE:latest-v8-linux-arm64v8 --os=linux --arch=arm64 --variant=v8

    # Manifest Push LATEST
    docker manifest push $IMAGE:latest
    echo "DOCKER MANIFEST: Create and Push docker manifest list."
}

main $1

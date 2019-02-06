if [ $# -ne 1 ]; then
    echo $0: usage: build-rpi.sh NODE_RED_VERSION
    exit 1
fi

NODE_RED_VERSION=$1
IMAGE_ORG=${IMAGE_ORG:-nodered}

# install qemu to build native arm packages
if [ $(uname) != Darwin ]; then
    docker run --rm --privileged multiarch/qemu-user-static:register --reset
fi
curl -sSL https://github.com/multiarch/qemu-user-static/releases/download/v2.5.0/x86_64_qemu-arm-static.tar.xz | tar -xJ

docker build -f rpi/Dockerfile -t ${IMAGE_ORG}/node-red-docker:rpi .

if [ $? -ne 0 ]; then
    echo "ERROR: Docker build failed for rpi image"
    exit 1
fi

docker tag ${IMAGE_ORG}/node-red-docker:rpi ${IMAGE_ORG}/node-red-docker:$NODE_RED_VERSION-rpi

if [ $? -ne 0 ]; then
    echo "ERROR: Docker tag failed for rpi image"
    exit 1
fi

docker run -d ${IMAGE_ORG}/node-red-docker:rpi

if [ $? -ne 0 ]; then
    echo "ERROR: Docker container failed to start for rpi build."
    exit 1
fi

docker push ${IMAGE_ORG}/node-red-docker:rpi

if [ $? -ne 0 ]; then
    echo "ERROR: Docker push failed for rpi image."
    exit 1
fi

docker push ${IMAGE_ORG}/node-red-docker:$NODE_RED_VERSION-rpi

if [ $? -ne 0 ]; then
    echo "ERROR: Docker push failed for rpi image."
    exit 1
fi

# Build your own Docker image

The docker-custom directory contains files you need to build your own images.

The follow steps describe in short which steps to take to build your own images.

## 1. git clone

Clone the Node-RED Docker project from github
```shell script
git clone https://github.com/node-red/node-red-docker.git
```

Change dir to docker-custom
```shell script
cd node-red-docker/docker-custom
```

## 1. **package.json**

   - Change the node-red version in package.json (from the docker-custom directory) to the version you require
   - Add optionally packages you require

## 2. **flows.json**

   - The `flows.json` file is the default flow that will be used if no external volume is mounted to `/data`. You can replace this by a preconfigured flow and launch it by not mounting a /data volume, but most users will mount and save data and flows externally.

## 3. **docker-alpine.sh, docker-debian.sh**

The `docker-alpine.sh` and `docker-debian.sh` are helper scripts to build a custom Node-RED docker image. The docker-alpine script is based on Alpine as per the default docker package. The docker-debian is based on debian that may be more familiar to users and may support extra customisation more easily.

Change the build arguments as needed:

   - `--build-arg ARCH=amd64` : architecture your are building for (arm32v6, arm32v7, arm64v8, amd64)
   - `--build-arg NODE_VERSION=14` : NodeJS version you like to use
   - `--build-arg NODE_RED_VERSION=${NODE_RED_VERSION}` : don't change this, ${NODE_RED_VERSION} gets populated from package.json
   - `--build-arg OS=alpine` : the linux distro to use (alpine)
   - `--build-arg BUILD_DATE="$(date +"%Y-%m-%dT%H:%M:%SZ")"` : don't change this
   - `--build-arg TAG_SUFFIX=default` : to build the default or minimal image (only applies to the alpine build)
   - `--file Dockerfile.custom` : Dockerfile to use to build your image.
   - `--tag testing:node-red-build` : set the image name and tag

## 4. **Run docker-alpine.sh** or **docker-debian.sh**

Run `docker-alpine.sh` or `docker-debian.sh`

```shell script
$ ./docker-alpine.sh
```

This starts building your custom image and might take a while depending on the system you are running on.

When building is done you can run the custom image by the following command:

```shell script
$ docker run -it -p1880:1880 -v node_red_data:/data --name myNRtest testing:node-red-build
```

With the following command you can verify your docker image:

```shell script
$ docker inspect testing:node-red-build
```

## 5. **Advanced Configuration**

The relevant `Dockerfile` can be modified as required. Examples of how to extend `Dockerfiles` to add prerequisite libraries can be found [here](https://nodered.org/docs/getting-started/docker-custom).


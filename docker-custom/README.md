# Build your own Docker image

The docker-custom directory contains files you need to build your own images.

The steps to take to build your own images are:

1) **package.json**

   - Change the node-red version in package.json (from the docker-custom directory) to the version you require
   - Add optionally packages you require
 
2) **docker-make.sh**

   Change the build arguments as needed:

   - `--build-arg ARCH=amd64` : architecture your are building for (arm32v6, arm32v7, arm64v8, amd64)
   - `--build-arg NODE_VERSION=10` : NodeJS version you like to use
   - `--build-arg NODE_RED_VERSION=${NODE_RED_VERSION}` : don't change this, ${NODE_RED_VERSION} gets populated from package.json
   - `--build-arg OS=alpine` : the linux distro you like to use (alpine or buster-slim)
   - `--build-arg BUILD_DATE="$(date +"%Y-%m-%dT%H:%M:%SZ")"` : don't change this
   - `--build-arg PYTHON_VERSION=0` : add Python to your image (0=no Python, 2=Python 2.x, 3=Python 3.x) 
   - `--file Dockerfile-alpine.custom` : Dockerfile to use to build your image (Dockerfile-alpine.custom or Dockerfile-slim.custom)
   - `--tag mynodered:node-red-custom-build` : set the image name and tag
   
3) **Run docker-make.sh**

```
$ ./docker-make.sh
```

This starts building your custom image and might take a while depending on the system you are running on.

When building is done you can run it by the following command:

```
$ docker run -it -p1880:1880 mynodered:node-red-custom-build
```


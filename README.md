# Node-RED-Docker

[![Greenkeeper badge](https://badges.greenkeeper.io/RaymondMouthaan/node-red.svg)](https://greenkeeper.io/)
[![Build Status](https://travis-ci.org/RaymondMouthaan/node-red.svg?branch=master)](https://travis-ci.org/RaymondMouthaan/node-red)
[![DockerHub Pull](https://img.shields.io/docker/pulls/raymondmm/node-red.svg)](https://hub.docker.com/r/raymondmm/node-red/)

This project describes some of the many ways Node-RED can be run under Docker and has support for multiple architectures (amd64, arm32v6, arm32v7 and arm64v8).
Some basic familiarity with Docker and the [Docker Command Line](https://docs.docker.com/engine/reference/commandline/cli/) is assumed.

This project also provides the build for the `raymondmm/node-red` container on [DockerHub](https://hub.docker.com/r/raymondmm/node-red/).

## Quick Start
To run this directly in Docker at it's simplest just run:

        docker run -it -p 1880:1880 --name mynodered raymondmm/node-red

Let's dissect that command:

        docker run              - run this container... and build locally if necessary first.
        -it                     - attach a terminal session so we can see what is going on
        -p 1880:1880            - connect local port 1880 to the exposed internal port 1880
        --name mynodered        - give this machine a friendly local name
        raymondmm/node-red      - the image to base it on - currently Node-RED v0.20.7


Running that command should give a terminal window with a running instance of Node-RED.

        Welcome to Node-RED
        ===================
        
        10 Aug 12:57:10 - [info] Node-RED version: v0.20.7
        10 Aug 12:57:10 - [info] Node.js  version: v10.16.2
        10 Aug 12:57:10 - [info] Linux 4.19.58-v7+ arm LE
        10 Aug 12:57:11 - [info] Loading palette nodes
        10 Aug 12:57:16 - [info] Settings file  : /data/settings.js
        10 Aug 12:57:16 - [info] Context store  : 'default' [module=memory]
        10 Aug 12:57:16 - [info] User directory : /data
        10 Aug 12:57:16 - [warn] Projects disabled : editorTheme.projects.enabled=false
        10 Aug 12:57:16 - [info] Flows file     : /data/flows.json
        10 Aug 12:57:16 - [info] Creating new flow file
        10 Aug 12:57:17 - [warn] 
        
        ---------------------------------------------------------------------
        Your flow credentials file is encrypted using a system-generated key.
        
        If the system-generated key is lost for any reason, your credentials
        file will not be recoverable, you will have to delete it and re-enter
        your credentials.
        
        You should set your own key using the 'credentialSecret' option in
        your settings file. Node-RED will then re-encrypt your credentials
        file using your chosen key the next time you deploy a change.
        ---------------------------------------------------------------------
        
        10 Aug 12:57:17 - [info] Server now running at http://127.0.0.1:1880/

        [...]

You can then browse to `http://{host-ip}:1880` to get the familiar Node-RED desktop.

The advantage of doing this is that by giving it a name we can manipulate it
more easily, and by fixing the host port we know we are on familiar ground.
(Of course this does mean we can only run one instance at a time... but one step at a time folks...)

If we are happy with what we see we can detach the terminal with `Ctrl-p``Ctrl-q` - the container will keep running in the background.

To reattach to the terminal (to see logging) run:

        $ docker attach mynodered

If you need to restart the container (e.g. after a reboot or restart of the Docker daemon):

        $ docker start mynodered

and stop it again when required:

        $ docker stop mynodered

_**Note**: this Dockerfile is configured to store the flows.json file and any
extra nodes you install "outside" of the container. We do this so that you may rebuild the underlying
container without permanently losing all of your customisations._

## Image Variations
The Node-RED images have different variations and are supported by manifest lists (auto-detect architecture). 
This makes it more easy to deploy in a multi architecture Docker environment. E.g. a Docker Swarm with mix of Raspberry Pi's and amd64 nodes. 

The tag naming convention is `<node-red-version>-<os>-<architecture>`, where:
- `<node-red-version>` is the Node-RED version.
- `<os>` is either Alpine or Debian slim based.
- `<architecture>` is the architecture of the Docker host system, either amd64, arm32v6, arm32v7, arm64.

The Node-RED images are based on the [official Node JS v10](https://hub.docker.com/_/node/), which are based on Alpine Linux or Debian Linux (slim) 
and are kept as small as possible (no build tools pre-installed).
Using Alpine Linux or Debian Linux (slim) reduces the built image size (~100MB vs ~700MB), but removes
standard dependencies that are required for native module compilation. If you want to add dependencies with native dependencies, extend the Node-RED image with the missing packages on running containers or build new images.

The following table shows the variation of provided images.

|**Tag**                             |**Base Image**               |**Arch**    |**OS**     |**Python**|**GPIO**|
|------------------------------------|-----------------------------|------------|-----------|----------|--------|
| 0.20.7-alpine-amd64                | amd64/node:10-alpine        | amd64      | alpine    |    no    |   no   |
| 0.20.7-alpine-arm32v6              | arm32v6/node:10-alpine      | arm32v6    | alpine    |    no    |   no   |
| ~~0.20.7-alpine-arm32v7~~          | ~~arm32v7/node:10-alpine~~  | ~~arm32v7~~| ~~alpine~~|    no    |   no   |
| 0.20.7-buster-slim-arm32v7         | arm32v7/node:10-buster-slim | arm32v7    | debian    |    no    |   no   |
| 0.20.7-alpine-arm64v8              | arm64v8/node:10-alpine      | arm64v8    | alpine    |    no    |   no   |
||
| 0.20.7-alpine-amd64-python3        | amd64/node:10-alpine        | amd64      | alpine    |    3.x   |   no   |
| 0.20.7-alpine-arm32v6-python3      | arm32v6/node:10-alpine      | arm32v6    | alpine    |    3.x   |   yes  |
| ~~0.20.7-alpine-arm32v7-python3~~  | ~~arm32v7/node:10-alpine~~  | ~~arm32v7~~| ~~alpine~~|    3.x   |   yes  |
| 0.20.7-buster-slim-arm32v7-python3 | arm32v7/node:10-slim        | arm32v7    | debian    |    3.x   |   yes  |
| 0.20.7-alpine-arm64v8-python3      | arm64v8/node:10-alpine      | arm64v8    | alpine    |    3.x   |   no   |
||
| 0.20.7-alpine-amd64-python2        | amd64/node:10-alpine        | amd64      | alpine    |    2.x   |   no   |
| 0.20.7-alpine-arm32v6-python2      | arm32v6/node:10-alpine      | arm32v6    | alpine    |    2.x   |   yes  |
| ~~0.20.7-alpine-arm32v7-python2~~  | ~~arm32v7/node:10-alpine~~  | ~~arm32v7~~| ~~alpine~~|    2.x   |   yes  |
| 0.20.7-buster-slim-arm32v7-python2 | arm32v7/node:10-slim        | arm32v7    | debian    |    2.x   |   yes  |
| 0.20.7-alpine-arm64v8-python2      | arm64v8/node:10-alpine      | arm64v8    | alpine    |    2.x   |   no   |

The Node-RED images have either no Python, Python 3.x or Python 2.x pre-installed and for arm32v6 and arm32v7 Node-RED build-in GPIO enabled.

All images have bash, nano, curl git, openssl tools pre-installed to support Node-red's Projects feature.

_**Note**: Python 2.7 will reach the end of its life on January 1st, 2020! Therefore it's highly recommended to use Python 3 based images, if you need Python pre-installed._

_**Note**: Base image arm32v7/node:10-alpine is not available [#1081](https://github.com/nodejs/docker-node/issues/1081). As soon as it is available buster-slim images might be replaced by it._

## Manifest Lists

The following table shows the provided Manifest Lists.

| **Tag**                                | **Node-RED Base Image**                      |
|----------------------------------------|--------------------------------------------- |
| latest, 0.20.7                         | raymondmm/0.20.7-alpine-amd64                |
|                                        | raymondmm/0.20.7-alpine-arm32v6              |
|                                        | raymondmm/~~0.20.7-alpine-arm32v7~~          |
|                                        | raymondmm/0.20.7-buster-slim-arm32v7         |
|                                        | raymondmm/0.20.7-alpine-arm64v8              |
||    
| latest-python3, 0.20.7-python3         | raymondmm/0.20.7-alpine-amd64-python3        |
|                                        | raymondmm/0.20.7-alpine-arm32v6-python3      |
|                                        | raymondmm/~~0.20.7-alpine-arm32v7-python3~~  |
|                                        | raymondmm/0.20.7-buster-slim-arm32v7-python3 |
|                                        | raymondmm/0.20.7-alpine-arm64v8-python3      |
||    
| latest-python2, 0.20.7-python2         | raymondmm/0.20.7-alpine-amd64-python2        |
|                                        | raymondmm/0.20.7-alpine-arm32v6-python2      |
|                                        | raymondmm/~~0.20.7-alpine-arm32v7-python2~~  |
|                                        | raymondmm/0.20.7-buster-slim-arm32v7-python2 |
|                                        | raymondmm/0.20.7-alpine-arm64v8-python2      |

## Raspberry PI Tags
| **Tag**                                | **Node-RED Base Image Tag**        | **Description**      |
|----------------------------------------|------------------------------------|----------------------|
| latest-rpi, 0.20.7-rpi                 | 0.20.7-alpine-arm32v6              | rpi 1, 2, 3, 4, zero |
|                                        | 0.20.7-buster-slim-arm32v7         |                      |
||
| latest-rpi-python3, 0.20.7-rpi-python3 | 0.20.7-alpine-arm32v6-python3      | rpi 1, 2, 3, 4, zero |
|                                        | 0.20.7-buster-slim-arm32v7-python3 |                      |
||
| latest-rpi-python2, 0.20.7-rpi-python2 | 0.20.7-alpine-arm32v6-python2      | rpi 1, 2, 3, 4, zero |
|                                        | 0.20.7-buster-slim-arm32v7-python2 |                      |


With the support of Docker manifest list, there is no need to explicit add the tag for the architecture to use. When a docker run command or docker service command or docker stack command is executed, docker checks which architecture is required and verifies if it is available in the docker repository. When it does, docker pulls the matching image for it.

As an example: suppose you are running on a Pine64, which has arm64 as architecture. Then just simple run the following command, to pull the image with the correct tag (0.20.7-alpine-arm64v8) and run the container.
```
docker run -it -p 1880:1880 --name mynodered raymondmm/node-red:latest
```

The same command can be used for running on an amd64 system, since docker discovers its running on a amd64 host and pulls the image with matching tag (0.20.7-alpine-amd64).

This gives the advantaged that you don't need to know/specifiy which architecture you are running on and makes docker run commands and docker compose files exchangeable.

## Raspberry PI
Due to an open [issue](https://github.com/moby/moby/issues/34875) the above command pulls `0.20.7-alpine-arm32v6` for Raspberry PI 2, 3 and 4. Since arm32v6 is compatible with arm32v7, this is not a problem.
However if you to make use of arm32v7 then specify it's corresponding tag explicit like this:

```
docker run -it -p 1880:1880 --name mynodered raymondmm/node-red:0.20.7-buster-slim-arm32v7
```
Or:
```
docker run -it -p 1880:1880 --name mynodered raymondmm/node-red:0.20.7-buster-slim-arm32v7-python3
```

You can see a full list of the tagged releases [here](https://hub.docker.com/r/raymondmm/node-red/tags/).

## Raspberry PI - build-in GPIO support
Node-RED Raspberry PI images provide build-in GPIO support, however it is highly recommended to use [node-red-node-pi-gpiod](https://github.com/node-red/node-red-nodes/tree/master/hardware/pigpiod) instead.

Disadvantages of the build-in GPIO support are:
- Your Docker container needs to be deployed on the same Docker node/host on which you want to control the gpio's.
- Gain access to /dev/mem of your Docker node/host
- privileged=true is not supported for `docker stack` command

[node-red-node-pi-gpiod](https://github.com/node-red/node-red-nodes/tree/master/hardware/pigpiod) solves all these disadvantages. With [node-red-node-pi-gpiod](https://github.com/node-red/node-red-nodes/tree/master/hardware/pigpiod) it is even possible to interact with gpio's of multiple Raspberry Pi's from a single Node-RED container. 

If you still do want to make use of the Node-RED build-in GPIO support, run your container like this:

```
docker run -it --rm -p1880:1880 --user=root --privileged=true -v /dev/mem:/dev/mem raymondmm/node-red:latest-rpi-python3
```  

### Host Directory As Volume (Persistent)
To save your Node-RED user directory inside the container to a host directory outside the container, you can use the command below. But to allow access to this host directory, the node-red user (default uid=1001) inside the container must have the same uid as the owner of the host directory. To override the default uid and gid of the node-red user inside the the container you can use the option --user="<my_host_uid>:<my_host_gid>":

```
$ docker run -it --user="<my_host_uid>:<my_host_gid>" -p 1880:1880 -v <host_directory>:/data --name mynodered raymondmm/node-red
```

Use case ...
- Suppose you are running on a Raspberry PI with a user named 'pi' and group 'pi'.
```
$ whoami
```
- With this user create a directory '~/.node-red'.
```
$ mkdir ~/.node-red
```
- Verify newly created directory with:
```
$ ls -al ~/.node-red
```
This shows that user pi is owner of this directory:
```
ls -al ~/.node-red
total 8
drwxr-xr-x 2 pi pi 4096 May  7 20:55 .
drwxr-xr-x 8 pi pi 4096 May  7 20:42 ..
```

- Now we want to have access to this '~/.node-red' directory with the container so that Node-RED can save user data to it.
As we know we need to override the default uid (1001) of the node-red user inside the container with the uid of the pi user.
For that we need to know the uid of user pi:
```
$ id pi
```
- The uid and gid of user pi are:
```
uid=1000(pi) gid=1000(pi) [...]
```

- So the final command becomes:
```
$ docker run -it --user="1000:1000" -p 1880:1880 -v ~/.node-red:/data --name mynodered raymondmm/node-red
```

Running a Node-RED container with a host directory mounted as the data volume,
you can manually run `npm install` within your host directory. Files created in
the host directory will automatically appear in the container's file system.

Adding extra nodes to the container can be accomplished by
running npm install locally.

        $ cd ~/.node-red
        $ npm install node-red-node-smooth
        node-red-node-smooth@0.0.3 node_modules/node-red-node-smooth
        $ docker stop mynodered
        $ docker start mynodered

_**Note** : Modules with a native dependencies will be compiled on the host
machine's architecture. These modules will not work inside the Node-RED
container unless the architecture matches the container's base image. For native
modules, it is recommended to install using a local shell or update the
project's package.json and re-build._

## Docker Stack / Docker Compose

Below an example of a Docker Compose file which can be run by `docker stack` or `docker-compose`.
Please refer to the official Docker pages for more info about [docker stack](https://docs.docker.com/engine/reference/commandline/stack/) and [docker compose](https://docs.docker.com/compose/).

```
################################################################################
# Node-Red Stack
################################################################################
#$ docker stack deploy node-red --compose-file docker-compose-node-red.yml
################################################################################
version: 3.7

services:
  node-red:
    image: raymondmm/node-red:latest
    environment:
      - TZ="Europe/Amsterdam"
    ports:
      - "1880:1880"
    networks:
      - node-red-net
    volumes:
      - /mnt/docker-cluster/node-red/data:/data

networks:
  node-red-net:

```

The above compose file:
- creates a node-red service
- pulls the latest node-red image
- sets the timezone to Europe/Amsterdam
- Maps the container port 1880 to the the host port 1880 
- creates a node-red-net network and attaches the container to this network
- persists the `/data` dir inside the container to the `/mnt/docker-cluster/node-red/data` dir outside the container

## Project Layout
This repository contains Dockerfiles to build the Node-RED Docker images listed above.

### package.json

The package.json is a metafile that downloads and installs the required version
of Node-RED and any other npms you wish to install at build time. During the
Docker build process, the dependencies are installed under `/usr/src/node-red`.

The main sections to modify are

    "dependencies": {
        "node-red": "0.20.x",           <-- set the version of Node-RED here
        "node-red-node-rbe": "*"        <-- add any extra npm packages here
    },

This is where you can pre-define any extra nodes you want installed every time
by default, and then

    "scripts"      : {
        "start": "node-red -v $FLOWS"
    },

This is the command that starts Node-RED when the container is run.

### startup

Node-RED is started using NPM start from this `/usr/src/node-red`, with the `--userDir`
parameter pointing to the `/data` directory on the container.

The flows configuration file is set using an environment parameter (**FLOWS**),
which defaults to *'flows.json'*. This can be changed at runtime using the
following command-line flag.

        $ docker run -it -p 1880:1880 -e FLOWS=my_flows.json raymondmm/node-red

Node.js runtime arguments can be passed to the container using an environment
parameter (**NODE_OPTIONS**). For example, to fix the heap size used by
the Node.js garbage collector you would use the following command.

        $ docker run -it -p 1880:1880 -e NODE_OPTIONS="--max_old_space_size=128" raymondmm/node-red

## Adding Nodes

Installing extra Node-RED nodes into an instance running with Docker can be
achieved by manually installing those nodes into the container, using the cli or
running npm commands within a container shell, or mounting a host directory with
those nodes as a data volume.

### Node-RED Admin Tool

Using the administration tool, with port forwarding on the container to the host
system, extra nodes can be installed without leaving the host system.

        $ npm install -g node-red-admin
        $ node-red-admin install node-red-node-openwhisk

This tool assumes Node-RED is available at the following address
`http://localhost:1880`.

Refreshing the browser page should now reveal the newly added node in the palette.

### Container Shell

        $ docker exec -it mynodered /bin/bash

Will give a command line inside the container - where you can then run the npm install
command you wish - e.g.

        $ cd /data
        $ npm install node-red-node-smooth
        node-red-node-smooth@0.0.3 node_modules/node-red-node-smooth
        $ exit
        $ docker stop mynodered
        $ docker start mynodered

Refreshing the browser page should now reveal the newly added node in the palette.


### Building Custom Image

Creating a new Docker image, using the public Node-RED images as the base image,
allows you to install extra nodes during the build process.

This Dockerfile builds a custom Node-RED image with the flightaware module
installed from NPM.

```
FROM raymondmm/node-red
RUN npm install node-red-contrib-flightaware
```

Alternatively, you can modify the package.json in this repository and re-build
the images from scratch. This will also allow you to modify the version of
Node-RED that is installed. See [README](docker-custom/README.md) under docker-custom directory.

## Managing User Data

Once you have customised the Node-RED instance running with Docker, we need to
ensure these modifications are not lost if the container is destroyed. Managing
this user data can be handed by persisting container state into a new image or
using named data volumes to handle move this data outside the container.

### Saving Changes As Custom Image

Modifications to files within the live container, e.g. manually adding nodes or
creating flows, do not exist outside the lifetime of the container. If that
container instance is destroyed, these changes will be lost.

Docker allows you to the current state of a container to a new image. This
means you can persist your changes as a new image that can be shared on other
systems.

        $ docker commit mynodered custom-node-red

If we destroy the ```mynodered``` container, the instance can be recovered by
spawning a new container using the ```custom-node-red``` image.

### Using Named Data Volumes

Docker supports using [data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/) to store
persistent or shared data outside the container. Files and directories within data
volumes exist outside of the lifecycle of containers, i.e. the files still exist
after removing the container.

Node-RED uses the `/data` directory to store user configuration data.

Mounting a data volume inside the container at this directory path means user
configuration data can be saved outside of the container and even shared between
container instances.

Let's create a new named data volume to persist our user data and run a new
container using this volume.

        $ docker volume create --name node_red_user_data
        $ docker volume ls
        DRIVER              VOLUME NAME
        local               node_red_user_data
        $ docker run -it -p 1880:1880 -v node_red_user_data:/data --name mynodered raymondmm/node-red

Using Node-RED to create and deploy some sample flows, we can now destroy the
container and start a new instance without losing our user data.

        $ docker rm mynodered
        $ docker run -it -p 1880:1880 -v node_red_user_data:/data --name mynodered raymondmm/node-red

## Updating

Updating the base container image is as simple as

        $ docker pull raymondmm/node-red
        $ docker stop mynodered
        $ docker start mynodered

## Running headless

The barest minimum we need to just run Node-RED is

    $ docker run -d -p 1880 raymondmm/node-red

This will create a local running instance of a machine - that will have some
docker id number and be running on a random port... to find out run

    $ docker ps -a
    CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS                     PORTS                     NAMES
    4bbeb39dc8dc        raymondmm/node-red:latest   "npm start"         4 seconds ago       Up 4 seconds               0.0.0.0:49154->1880/tcp   furious_yalow
    $

You can now point a browser to the host machine on the tcp port reported back, so in the example
above browse to  `http://{host ip}:49154`

## Linking Containers

You can link containers "internally" within the docker runtime by using the --link option.

For example I have a simple MQTT broker container available as

        docker run -it --name mybroker raymondmm/node-red

(no need to expose the port 1883 globally unless you want to... as we do magic below)

Then run nodered docker - but this time with a link parameter (name:alias)

        docker run -it -p 1880:1880 --name mynodered --link mybroker:broker raymondmm/node-red

the magic here being the `--link` that inserts a entry into the node-red instance
hosts file called *broker* that links to the mybroker instance....  but we do
expose the 1880 port so we can use an external browser to do the node-red editing.

Then a simple flow like below should work - using the alias *broker* we just set up a second ago.

        [{"id":"190c0df7.e6f3f2","type":"mqtt-broker","broker":"broker","port":"1883","clientid":""},{"id":"37963300.c869cc","type":"mqtt in","name":"","topic":"test","broker":"190c0df7.e6f3f2","x":226,"y":244,"z":"f34f9922.0cb068","wires":[["802d92f9.7fd27"]]},{"id":"edad4162.1252c","type":"mqtt out","name":"","topic":"test","qos":"","retain":"","broker":"190c0df7.e6f3f2","x":453,"y":135,"z":"f34f9922.0cb068","wires":[]},{"id":"13d1cf31.ec2e31","type":"inject","name":"","topic":"","payload":"","payloadType":"date","repeat":"","crontab":"","once":false,"x":226,"y":157,"z":"f34f9922.0cb068","wires":[["edad4162.1252c"]]},{"id":"802d92f9.7fd27","type":"debug","name":"","active":true,"console":"false","complete":"false","x":441,"y":261,"z":"f34f9922.0cb068","wires":[]}]

This way the internal broker is not exposed outside of the docker host - of course
you may add `-p 1883:1883`  etc to the broker run command if you want to see it...


## Issues

Here is a list of common issues users have reported with possible solutions.

### User Permission Errors

If you are seeing *permission denied* errors opening files or accessing host devices, try running the container as the root user.

```
docker run -it -p 1880:1880 --name mynodered --user=root raymondmm/node-red
```

References:

https://github.com/node-red/node-red/issues/15

https://github.com/node-red/node-red/issues/8

### Accessing Host Devices

If you want to access a device from the host inside the container, e.g. serial port, use the following command-line flag to pass access through.

```
docker run -it -p 1880:1880 --name mynodered --device=/dev/ttyACM0 raymondmm/node-red
```
References:
https://github.com/node-red/node-red/issues/15

### Setting Timezone

If you want to modify the default timezone, use the TZ environment variable with the [relevant timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

```
docker run -it -p 1880:1880 --name mynodered -e TZ="Europe/London" raymondmm/node-red
```

References:
https://groups.google.com/forum/#!topic/node-red/ieo5IVFAo2o

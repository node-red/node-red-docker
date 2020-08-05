# Node-RED Docker

[![Greenkeeper badge](https://badges.greenkeeper.io/node-red/node-red-docker.svg)](https://greenkeeper.io/)
[![Build Status](https://travis-ci.org/node-red/node-red-docker.svg?branch=master)](https://travis-ci.org/node-red/node-red-docker)
[![DockerHub Pull](https://img.shields.io/docker/pulls/nodered/node-red.svg)](https://hub.docker.com/r/nodered/node-red/)
[![DockerHub Stars](https://img.shields.io/docker/stars/nodered/node-red.svg?maxAge=2592000)](https://hub.docker.com/r/nodered/node-red/)

This project describes some of the many ways Node-RED can be run under Docker and has support for multiple architectures (amd64, arm32v6, arm32v7, arm64v8, i386 and s390x).
Some basic familiarity with Docker and the [Docker Command Line](https://docs.docker.com/engine/reference/commandline/cli/) is assumed.

As of Node-RED 1.0 this project provides the build for the `nodered/node-red` container on [Docker Hub](https://hub.docker.com/r/nodered/node-red/).

Previous 0.20.x versions are still available at https://hub.docker.com/r/nodered/node-red-docker.

## Quick Start
To run in Docker in its simplest form just run:

        docker run -it -p 1880:1880 --name mynodered nodered/node-red

Let's dissect that command:

        docker run              - run this container, initially building locally if necessary
        -it                     - attach a terminal session so we can see what is going on
        -p 1880:1880            - connect local port 1880 to the exposed internal port 1880
        --name mynodered        - give this machine a friendly local name
        nodered/node-red        - the image to base it on - currently Node-RED v1.1.3


Running that command should give a terminal window with a running instance of Node-RED.

        Welcome to Node-RED
        ===================

        10 Jul 12:57:10 - [info] Node-RED version: v1.1.3
        10 Jul 12:57:10 - [info] Node.js  version: v10.21.0
        10 Jul 12:57:10 - [info] Linux 4.9.184-linuxkit x64 LE
        10 Jul 12:57:11 - [info] Loading palette nodes
        10 Jul 12:57:16 - [info] Settings file  : /data/settings.js
        10 Jul 12:57:16 - [info] Context store  : 'default' [module=memory]
        10 Jul 12:57:16 - [info] User directory : /data
        10 Jul 12:57:16 - [warn] Projects disabled : editorTheme.projects.enabled=false
        10 Jul 12:57:16 - [info] Flows file     : /data/flows.json
        10 Jul 12:57:16 - [info] Creating new flow file
        10 Jul 12:57:17 - [warn]

        ---------------------------------------------------------------------
        Your flow credentials file is encrypted using a system-generated key.

        If the system-generated key is lost for any reason, your credentials
        file will not be recoverable, you will have to delete it and re-enter
        your credentials.

        You should set your own key using the 'credentialSecret' option in
        your settings file. Node-RED will then re-encrypt your credentials
        file using your chosen key the next time you deploy a change.
        ---------------------------------------------------------------------

        10 Jul 12:57:17 - [info] Starting flows
        10 Jul 12:57:17 - [info] Started flows
        10 Jul 12:57:17 - [info] Server now running at http://127.0.0.1:1880/

        [...]

You can then browse to `http://{host-ip}:1880` to get the familiar Node-RED desktop.


The advantage of doing this is that by giving it a name (mynodered) we can manipulate it
more easily, and by fixing the host port we know we are on familiar ground.
Of course this does mean we can only run one instance at a time... but one step at a time folks...

If we are happy with what we see, we can detach the terminal with `Ctrl-p` `Ctrl-q` - the
container will keep running in the background.

To reattach to the terminal (to see logging) run:

        $ docker attach mynodered

If you need to restart the container (e.g. after a reboot or restart of the Docker daemon):

        $ docker start mynodered

and stop it again when required:

        $ docker stop mynodered

**Healthcheck**: to turn off the Healthcheck add `--no-healthcheck` to the run command.

## Image Variations
The Node-RED images come in different variations and are supported by manifest lists (auto-detect architecture).
This makes it more easy to deploy in a multi architecture Docker environment. E.g. a Docker Swarm with mix of Raspberry Pi's and amd64 nodes.

The tag naming convention is `<node-red-version>-<node-version>-<image-type>-<architecture>`, where:
- `<node-red-version>` is the Node-RED version.
- `<node-version>` is the Node JS version.
- `<image-type>` is type of image and is optional, can be either _none_ or minimal.
    - _none_ : is the default and has Python 2 & Python 3 + devtools installed
    - minimal : has no Python installed and no devtools installed
- `<architecture>` is the architecture of the Docker host system, can be either amd64, arm32v6, arm32v7, arm64, s390x or i386.

The minimal versions (without python and build tools) are not able to install nodes that require any locally compiled native code.

For example - to run the latest minimal version, you would run
```
docker run -it -p 1880:1880 --name mynodered nodered/node-red:latest-minimal
```

The Node-RED images are based on [official Node JS Alpine Linux](https://hub.docker.com/_/node/) images to keep them as small as possible.
Using Alpine Linux reduces the built image size, but removes standard dependencies that are required for native module compilation. If you want to add dependencies with native dependencies, extend the Node-RED image with the missing packages on running containers or build new images see [docker-custom](docker-custom/README.md).

The following table shows the variety of provided Node-RED images.

| **Tag**                    |**Node**| **Arch** | **Python** |**Dev**| **Base Image**         |
|----------------------------|--------|----------|------------|-------|------------------------|
| 1.1.3-10-amd64             |   10   | amd64    |   2.x 3.x  |  yes  | amd64/node:10-alpine   |
| 1.1.3-10-arm32v6           |   10   | arm32v6  |   2.x 3.x  |  yes  | arm32v6/node:10-alpine |
| 1.1.3-10-arm32v7           |   10   | arm32v7  |   2.x 3.x  |  yes  | arm32v7/node:10-alpine |
| 1.1.3-10-arm64v8           |   10   | arm64v8  |   2.x 3.x  |  yes  | arm64v8/node:10-alpine |
| 1.1.3-10-s390x             |   10   | s390x    |   2.x 3.x  |  yes  | s390x/node:10-alpine   |
| 1.1.3-10-i386              |   10   | i386     |   2.x 3.x  |  yes  | i386/node:10-alpine    |
|                            |        |          |            |       |                        |
| 1.1.3-10-minimal-amd64     |   10   | amd64    |     no     |  no   | amd64/node:10-alpine   |
| 1.1.3-10-minimal-arm32v6   |   10   | arm32v6  |     no     |  no   | arm32v6/node:10-alpine |
| 1.1.3-10-minimal-arm32v7   |   10   | arm32v7  |     no     |  no   | arm32v7/node:10-alpine |
| 1.1.3-10-minimal-arm64v8   |   10   | arm64v8  |     no     |  no   | arm64v8/node:10-alpine |
| 1.1.3-10-minimal-s390x     |   10   | s390x    |     no     |  no   | s390x/node:10-alpine   |
| 1.1.3-10-minimal-i386      |   10   | i386     |     no     |  no   | i386/node:10-alpine    |


| **Tag**                    |**Node**| **Arch** | **Python** |**Dev**| **Base Image**         |
|----------------------------|--------|----------|------------|-------|------------------------|
| 1.1.3-12-amd64             |   12   | amd64    |   2.x 3.x  |  yes  | amd64/node:12-alpine   |
| 1.1.3-12-arm32v6           |   12   | arm32v6  |   2.x 3.x  |  yes  | arm32v6/node:12-alpine |
| 1.1.3-12-arm32v7           |   12   | arm32v7  |   2.x 3.x  |  yes  | arm32v7/node:12-alpine |
| 1.1.3-12-arm64v8           |   12   | arm64v8  |   2.x 3.x  |  yes  | arm64v8/node:12-alpine |
| 1.1.3-12-s390x             |   12   | s390x    |   2.x 3.x  |  yes  | s390x/node:12-alpine   |
| 1.1.3-12-i386              |   12   | i386     |   2.x 3.x  |  yes  | i386/node:12-alpine    |
|                            |        |          |            |       |                        |
| 1.1.3-12-minimal-amd64     |   12   | amd64    |     no     |  no   | amd64/node:12-alpine   |
| 1.1.3-12-minimal-arm32v6   |   12   | arm32v6  |     no     |  no   | arm32v6/node:12-alpine |
| 1.1.3-12-minimal-arm32v7   |   12   | arm32v7  |     no     |  no   | arm32v7/node:12-alpine |
| 1.1.3-12-minimal-arm64v8   |   12   | arm64v8  |     no     |  no   | arm64v8/node:12-alpine |
| 1.1.3-12-minimal-s390x     |   12   | s390x    |     no     |  no   | s390x/node:12-alpine   |
| 1.1.3-12-minimal-i386      |   12   | i386     |     no     |  no   | i386/node:12-alpine    |

- All images have bash, tzdata, nano, curl, git, openssl and openssh-client pre-installed to support Node-RED's Projects feature.

## Manifest Lists
The following table shows the provided Manifest Lists.

| **Tag**                                | **Node-RED Base Image**                    |
|----------------------------------------|--------------------------------------------|
| latest, 1.1.3,                         | nodered/node-red:1.1.3-10-amd64            |
| latest-10, 1.1.3-10                    | nodered/node-red:1.1.3-10-arm32v6          |
|                                        | nodered/node-red:1.1.3-10-arm32v7          |
|                                        | nodered/node-red:1.1.3-10-arm64v8          |
|                                        | nodered/node-red:1.1.3-10-s390x            |
|                                        | nodered/node-red:1.1.3-10-i386             |
|                                        |                                            |
| latest-minimal, 1.1.3-minimal,         | nodered/node-red:1.1.3-10-amd64-minimal    |
| latest-10-minimal, 1.1.3-10-minimal    | nodered/node-red:1.1.3-10-arm32v6-minimal  |
|                                        | nodered/node-red:1.1.3-10-arm32v7-minimal  |
|                                        | nodered/node-red:1.1.3-10-arm64v8-minimal  |
|                                        | nodered/node-red:1.1.3-10-s390x-minimal    |
|                                        | nodered/node-red:1.1.3-10-i386-minimal     |

| **Tag**                                | **Node-RED Base Image**                    |
|----------------------------------------|--------------------------------------------|
| latest-12, 1.1.3-12                    | nodered/node-red:1.1.3-12-amd64            |
|                                        | nodered/node-red:1.1.3-12-arm32v6          |
|                                        | nodered/node-red:1.1.3-12-arm32v7          |
|                                        | nodered/node-red:1.1.3-12-arm64v8          |
|                                        | nodered/node-red:1.1.3-12-s390x            |
|                                        | nodered/node-red:1.1.3-12-i386             |
|                                        |                                            |
| latest-12-minimal, 1.1.3-12-minimal    | nodered/node-red:1.1.3-12-amd64-minimal    |
|                                        | nodered/node-red:1.1.3-12-arm32v6-minimal  |
|                                        | nodered/node-red:1.1.3-12-arm32v7-minimal  |
|                                        | nodered/node-red:1.1.3-12-arm64v8-minimal  |
|                                        | nodered/node-red:1.1.3-12-s390x-minimal    |
|                                        | nodered/node-red:1.1.3-12-i386-minimal     |

With the support of Docker manifest list, there is no need to explicitly add the tag for the architecture to use.
When a docker run command or docker service command or docker stack command is executed, docker checks which architecture is required and verifies if it is available in the docker repository. If it does, docker pulls the matching image for it.

Therefore all tags regarding Raspberry PI's are dropped.

For example: suppose you are running on a Raspberry PI 3B, which has `arm32v7` as architecture. Then just run the following command to pull the image (tagged by `1.1.3-10-arm32v7`), and run the container.
```
docker run -it -p 1880:1880 --name mynodered nodered/node-red:latest
```

The same command can be used for running on an amd64 system, since docker discovers its running on a amd64 host and pulls the image with the matching tag (`1.1.3-10-amd64`).

This gives the advantage that you don't need to know/specify which architecture you are running on and makes docker run commands and docker compose files more flexible and exchangeable across systems.

**Note**: Currently there is a bug in Docker's architecture detection that fails for `arm32v6` - eg Raspberry Pi Zero or 1. For these devices you currently need to specify the full image tag, for example:
```
docker run -it -p 1880:1880 --name mynodered nodered/node-red:1.1.3-10-minimal-arm32v6
```

## Raspberry PI - native GPIO support
| v1.0 - BREAKING: Native GPIO support for Raspberry PI has been dropped |
| --- |
The replacement for native GPIO is [node-red-node-pi-gpiod](https://github.com/node-red/node-red-nodes/tree/master/hardware/pigpiod).

Disadvantages of the native GPIO support are:
- Your Docker container needs to be deployed on the same Docker node/host on which you want to control the gpio.
- Gain access to `/dev/mem` of your Docker node/host
- privileged=true is not supported for `docker stack` command

`node-red-node-pi-gpiod` fixes all these disadvantages. With `node-red-node-pi-gpiod` it is possible to interact with gpio of multiple Raspberry Pi's from a single Node-RED container, and for multiple containers to access different gpio on the same Pi.

### Quick Migration steps to `node-red-node-pi-gpiod`
  1. Install `node-red-node-pi-gpiod` through the Node-RED palette
  2. Install and run `PiGPIOd daemon` on the host Pi.
  3. Replace all native gpio nodes with `pi gpiod` nodes.
  4. Configure `pi gpiod` nodes to connect to `PiGPIOd daemon`. Often the host machine will have an IP 172.17.0.1 port 8888 - but not always. You can use `docker exec -it mynodered ip route show default | awk '/default/ {print $3}'` to check.

For detailed install instruction please refer to the `node-red-node-pi-gpiod` [README](https://github.com/node-red/node-red-nodes/tree/master/hardware/pigpiod#node-red-node-pi-gpiod)

**Note**: There is a contributed [gpiod project](https://github.com/corbosman/node-red-gpiod) that runs the gpiod in its own container rather than on the host if required.

## Managing User Data

Once you have Node-RED running with Docker, we need to
ensure any added nodes or flows are not lost if the container is destroyed.
This user data can be persisted by mounting a data directory to a volume outside the container.
This can either be done using a bind mount or a named data volume.

Node-RED uses the `/data` directory inside the container to store user configuration data.

Depending on how and where you mount the user data directory you may want to turn off the built in healthcheck function by adding `--no-healthcheck` to the run command.

### Using a Host Directory for Persistence (Bind Mount)
To save your Node-RED user directory inside the container to a host directory outside the container, you can use the
command below. To allow access to this host directory, the node-red user (default uid=1000) inside the container must
have the same uid as the owner of the host directory.
```
docker run -it -p 1880:1880 -v /home/pi/.node-red:/data --name mynodered nodered/node-red
```

In this example the host `/home/pi/.node-red` directory is bound to the container `/data` directory.

**Note**: Users migrating from version 0.20 to 1.0 will need to ensure that any existing `/data`
directory has the correct ownership. As of 1.0 this needs to be `1000:1000`. This can be forced by
the command `sudo chown -R 1000:1000 path/to/your/node-red/data`

See [the wiki](https://github.com/node-red/node-red-docker/wiki/Permissions-and-Persistence) for detailed information
on permissions.

### Using Named Data Volumes

Docker also supports using named [data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/)
to store persistent or shared data outside the container.

To create a new named data volume to persist our user data and run a new
container using this volume.

        $ docker volume create --name node_red_user_data
        $ docker volume ls
        DRIVER              VOLUME NAME
        local               node_red_user_data
        $ docker run -it -p 1880:1880 -v node_red_user_data:/data --name mynodered nodered/node-red

Using Node-RED to create and deploy some sample flows, we can now destroy the
container and start a new instance without losing our user data.

        $ docker rm mynodered
        $ docker run -it -p 1880:1880 -v node_red_user_data:/data --name mynodered nodered/node-red

## Updating

As the /data is now preserved outside of the container, updating the base container image
is now as simple as

        $ docker pull nodered/node-red
        $ docker stop mynodered
        $ docker start mynodered


## Docker Stack / Docker Compose

Below an example of a Docker Compose file which can be run by `docker stack` or `docker-compose`.
Please refer to the official Docker pages for more info about [Docker stack](https://docs.docker.com/engine/reference/commandline/stack/) and [Docker compose](https://docs.docker.com/compose/).

```
################################################################################
# Node-RED Stack or Compose
################################################################################
# docker stack deploy node-red --compose-file docker-compose-node-red.yml
# docker-compose -f docker-compose-node-red.yml -p myNoderedProject up
################################################################################
version: "3.7"

services:
  node-red:
    image: nodered/node-red:latest
    environment:
      - TZ=Europe/Amsterdam
    ports:
      - "1880:1880"
    networks:
      - node-red-net
    volumes:
      - ~/node-red/data:/data

networks:
  node-red-net:
```

The above compose file:
- creates a node-red service
- pulls the latest node-red image
- sets the timezone to Europe/Amsterdam
- Maps the container port 1880 to the the host port 1880
- creates a node-red-net network and attaches the container to this network
- persists the `/data` dir inside the container to the users local `node-red/data` directory. The `node-red/data` directory must exist prior to starting the container.

## Project Layout
This repository contains Dockerfiles to build the Node-RED Docker images listed above.

### package.json

The package.json is a metafile that downloads and installs the required version
of Node-RED and any other npms you wish to install at build time. During the
Docker build process, the dependencies are installed under `/usr/src/node-red`.

The main sections to modify are

    "dependencies": {
        "node-red": "^1.1.3",           <-- set the version of Node-RED here
        "node-red-dashboard": "*"        <-- add any extra npm packages here
    },

This is where you can pre-define any extra nodes you want installed every time
by default, and then

    "scripts"      : {
        "start": "node-red -v $FLOWS"
    },

This is the command that starts Node-RED when the container is run.

### Startup

Node-RED is started using NPM start from this `/usr/src/node-red`, with the `--userDir`
parameter pointing to the `/data` directory on the container.

The flows configuration file is set using an environment parameter (**FLOWS**),
which defaults to *'flows.json'*. This can be changed at runtime using the
following command-line flag.
```
docker run -it -p 1880:1880 -e FLOWS=my_flows.json nodered/node-red
```

**Note**: If you set `-e FLOWS=""` then the flow file can be set via the *flowFile*
property in the `settings.js` file.

Node.js runtime arguments can be passed to the container using an environment
parameter (**NODE_OPTIONS**). For example, to fix the heap size used by
the Node.js garbage collector you would use the following command.
```
docker run -it -p 1880:1880 -e NODE_OPTIONS="--max_old_space_size=128" nodered/node-red
```

Other useful environment variables include

 - -e NODE_RED_ENABLE_SAFE_MODE=false # setting to true starts Node-RED in safe (not running) mode
 - -e NODE_RED_ENABLE_PROJECTS=false  # setting to true starts Node-RED with the projects feature enabled


### Node-RED Admin Tool

Using the administration tool, with port forwarding on the container to the host
system, extra nodes can be installed without leaving the host system.

        $ npm install -g node-red-admin
        $ node-red-admin install node-red-node-openwhisk

This tool assumes Node-RED is available at the following address
`http://localhost:1880`.

Refreshing the browser page should now reveal the newly added node in the palette.

### Node-RED Commands from the host 

Admin commands can also be accessed without installing npm or the
node-red-admin tool on the host machine. Simply prepend your command
with "npx" and apply it to the container - e.g  

        $ docker exec -it mynodered npx node-red admin hash-pw

### Container Shell

        $ docker exec -it mynodered /bin/bash

Will give a command line inside the container - where you can then run the npm install
command you wish - e.g.

        $ cd /data
        $ npm install node-red-node-smooth
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
FROM nodered/node-red
RUN npm install node-red-contrib-flightaware
```

Alternatively, you can modify the package.json in this repository and re-build
the images from scratch. This will also allow you to modify the version of
Node-RED that is installed. See [README](docker-custom/README.md) in the `docker-custom` directory.

## Running headless

The barest minimum we need to just run Node-RED is

    $ docker run -d -p 1880:1880 nodered/node-red

This will create a local running instance of a machine - that will have some
docker id number and be running on a random port... to find out run

    $ docker ps
    CONTAINER ID        IMAGE                            COMMAND             CREATED             STATUS                     PORTS                     NAMES
    4bbeb39dc8dc        nodered/node-red:latest          "npm start"         4 seconds ago       Up 4 seconds               0.0.0.0:49154->1880/tcp   furious_yalow
    $

You can now point a browser to the host machine on the tcp port reported back, so in the example
above browse to  `http://{host ip}:49154`

## Linking Containers

You can link containers "internally" within the docker runtime by using the --link option.

For example I have a simple MQTT broker container available as

        docker run -it --name mybroker eclipse-mosquitto

(no need to expose the port 1883 globally unless you want to... as we do magic below)

Then run nodered docker - but this time with a link parameter (name:alias)

        docker run -it -p 1880:1880 --name mynodered --link mybroker:broker nodered/node-red

the magic here being the `--link` that inserts a entry into the node-red instance
hosts file called *broker* that links to the external mybroker instance....  but we do
expose the 1880 port so we can use an external browser to do the node-red editing.

Then a simple flow like below should work - using the alias *broker* we just set up a second ago.

        [{"id":"190c0df7.e6f3f2","type":"mqtt-broker","broker":"broker","port":"1883","clientid":""},{"id":"37963300.c869cc","type":"mqtt in","name":"","topic":"test","broker":"190c0df7.e6f3f2","x":226,"y":244,"z":"f34f9922.0cb068","wires":[["802d92f9.7fd27"]]},{"id":"edad4162.1252c","type":"mqtt out","name":"","topic":"test","qos":"","retain":"","broker":"190c0df7.e6f3f2","x":453,"y":135,"z":"f34f9922.0cb068","wires":[]},{"id":"13d1cf31.ec2e31","type":"inject","name":"","topic":"","payload":"","payloadType":"date","repeat":"","crontab":"","once":false,"x":226,"y":157,"z":"f34f9922.0cb068","wires":[["edad4162.1252c"]]},{"id":"802d92f9.7fd27","type":"debug","name":"","active":true,"console":"false","complete":"false","x":441,"y":261,"z":"f34f9922.0cb068","wires":[]}]

This way the internal broker is not exposed outside of the docker host - of course
you may add `-p 1883:1883`  etc to the broker run command if you want to see it...

### Docker-Compose linking example

Another way to link containers is by using docker-compose. The following docker-compose.yml
file creates a Node-RED instance, and a local MQTT broker instance. In the Node-RED flow the broker can be addressed simply as `broker` at its default port `1883`.

```
version: "3.7"

services:
  node-red:
    image: nodered/node-red
    restart: unless-stopped
    volumes:
      - /home/pi/.node-red:/data
    ports:
      - 1880:1880

  broker:
    image: eclipse-mosquitto
    restart: unless-stopped
```

## Debugging containers

Sometimes it is useful to debug the code which is running inside the container.  Two scripts (*'debug'* and *'debug_brk'* in the package.json file) are available to start NodeJs in debug mode, which means that NodeJs will start listening (to port 9229) for a debug client. Various remote debugger tools (like Visual Code, Chrome Developer Tools ...) can be used to debug a Node-RED application.  A [wiki](https://github.com/node-red/node-red-docker/wiki/Debug-container-via-Chrome-Developer-Tools) page has been provided, to explain step-by-step how to use the Chrome Developer Tools debugger.

1. In most cases the *'debug'* script will be sufficient, to debug a Node-RED application that is fully up-and-running (i.e. when the application startup code is not relevant).  The NodeJs server can be started in debug mode using following command:
   ```
   docker run -it -p 1880:1880 -p 9229:9229 --name mynodered --entrypoint npm nodered/node-red run debug -- --userDir /data
   ```

2. In case debugging of the Node-RED startup code is required, the  *'debug_brk'* script will instruct NodeJs to break at the first statement of the Node-RED application.  The NodeJs server can be started in debug mode using following command:
   ```
   docker run -it -p 1880:1880 -p 9229:9229 --name mynodered --entrypoint npm nodered/node-red run debug_brk -- --userDir /data
   ```
   Note that in this case NodeJs will wait - at the first statement of the Node-RED application - until a debugger client connects...

As soon as NodeJs is listening to the debug port, this will be shown in the startup log:
```
Debugger listening on ws://0.0.0.0:9229/...
```

Let's dissect both commands:

        docker run              - run this container, initially building locally if necessary
        -it                     - attach a terminal session so we can see what is going on
        -p 1880:1880            - connect local port 1880 to the exposed internal port 1880
        -p 9229:9229            - connect local port 9229 to the exposed internal port 9229 (for debugger communication)
        --name mynodered        - give this machine a friendly local name
        --entrypoint npm        - overwrite the default entrypoint (which would run the *'start'* script)
        nodered/node-red        - the image to base it on - currently Node-RED v1.1.0
        run debug(_brk)         - (npm) arguments for the custom endpoint (which must be added AFTER the image name!)
        --                      - the arguments that will follow are not npm arguments, but need to be passed to the script
        --userDir /data         - instruct the script where the Node-RED data needs to be stored

## Common Issues and Hints

Here is a list of common issues users have reported with possible solutions.  

<br>

### User Permission Errors

See [the wiki](https://github.com/node-red/node-red-docker/wiki/Permissions-and-Persistence) for detailed information
on permissions.

If you are seeing *permission denied* errors opening files or accessing host devices, try running the container as the root user.

```
docker run -it -p 1880:1880 --name mynodered -u root nodered/node-red
```

__References:__  

https://github.com/node-red/node-red/issues/15  

https://github.com/node-red/node-red/issues/8  

<br>

### Accessing Host Devices

If you want to access a device from the host inside the container, e.g. serial port, use the following command-line flag to pass access through.

```
docker run -it -p 1880:1880 --name mynodered --device=/dev/ttyACM0 nodered/node-red
```
__References:__   

https://github.com/node-red/node-red/issues/15  

<br>

### Setting Timezone

If you want to modify the default timezone, use the TZ environment variable with the [relevant timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

```
docker run -it -p 1880:1880 --name mynodered -e TZ=Europe/London nodered/node-red
```

__References:__  

https://groups.google.com/forum/#!topic/node-red/ieo5IVFAo2o  

<br>

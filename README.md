# Node-RED Docker

[![Greenkeeper badge](https://badges.greenkeeper.io/node-red/node-red-docker.svg)](https://greenkeeper.io/)
[![Build Status](https://travis-ci.org/node-red/node-red-docker.svg?branch=master)](https://travis-ci.org/node-red/node-red-docker)
[![DockerHub Pull](https://img.shields.io/docker/pulls/nodered/node-red.svg)](https://hub.docker.com/r/nodered/node-red/)
[![DockerHub Stars](https://img.shields.io/docker/stars/nodered/node-red.svg?maxAge=2592000)](https://hub.docker.com/r/nodered/node-red/)

This project describes some of the many ways Node-RED can be run under Docker and has support for multiple architectures (amd64, arm32v6, arm32v7, arm64v8, i386 and s390x).
Some basic familiarity with Docker and the [Docker Command Line](https://docs.docker.com/engine/reference/commandline/cli/) is assumed.

**Note**: In version 1.2 we removed the named VOLUME from the build. It should not affect many users - but the details are [here](volumechanges.md).

As of Node-RED 1.0 this project provides the build for the `nodered/node-red` container on [Docker Hub](https://hub.docker.com/r/nodered/node-red/).

Previous 0.20.x versions are still available at https://hub.docker.com/r/nodered/node-red-docker.

## Quick Start
To run in Docker in its simplest form just run:

        docker run -it -p 1880:1880 -v node_red_data:/data --name mynodered nodered/node-red

Let's dissect that command:

        docker run              - run this container, initially building locally if necessary
        -it                     - attach a terminal session so we can see what is going on
        -p 1880:1880            - connect local port 1880 to the exposed internal port 1880
        -v node_red_data:/data  - mount the host node_red_data directory to the container /data directory so any changes made to flows are persisted
        --name mynodered        - give this machine a friendly local name
        nodered/node-red        - the image to base it on - currently Node-RED v4.0.3



Running that command should give a terminal window with a running instance of Node-RED.

        Welcome to Node-RED
        ===================

        10 Oct 12:57:10 - [info] Node-RED version: v4.0.3
        10 Oct 12:57:10 - [info] Node.js  version: v18.19.0
        10 Oct 12:57:10 - [info] Linux 6.6.13-100.fc38.x86_64 x64 LE
        10 Oct 12:57:11 - [info] Loading palette nodes
        10 Oct 12:57:16 - [info] Settings file  : /data/settings.js
        10 Oct 12:57:16 - [info] Context store  : 'default' [module=memory]
        10 Oct 12:57:16 - [info] User directory : /data
        10 Oct 12:57:16 - [warn] Projects disabled : editorTheme.projects.enabled=false
        10 Oct 12:57:16 - [info] Flows file     : /data/flows.json
        10 Oct 12:57:16 - [info] Creating new flow file
        10 Oct 12:57:17 - [warn]

        ---------------------------------------------------------------------
        Your flow credentials file is encrypted using a system-generated key.

        If the system-generated key is lost for any reason, your credentials
        file will not be recoverable, you will have to delete it and re-enter
        your credentials.

        You should set your own key using the 'credentialSecret' option in
        your settings file. Node-RED will then re-encrypt your credentials
        file using your chosen key the next time you deploy a change.
        ---------------------------------------------------------------------

        10 Oct 12:57:17 - [info] Starting flows
        10 Oct 12:57:17 - [info] Started flows
        10 Oct 12:57:17 - [info] Server now running at http://localhost:1880/

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
docker run -it -p 1880:1880 -v node_red_data:/data --name mynodered nodered/node-red:latest-minimal
```

The Node-RED images are based on [official Node JS Alpine Linux](https://hub.docker.com/_/node/) images to keep them as small as possible.
Using Alpine Linux reduces the built image size, but removes standard dependencies that are required for native module compilation. If you want to add dependencies with native dependencies, extend the Node-RED image with the missing packages on running containers or build new images see [docker-custom](docker-custom/README.md) and the documentation on the Node-RED site [here](https://nodered.org/docs/getting-started/docker-custom).

The following table shows the variety of provided Node-RED images.

| **Tag**                    |**Node**| **Arch** | **Python** |**Dev**| **Base Image**             |
|----------------------------|--------|----------|------------|-------|----------------------------|
| 4.0.3-18                   |   18   | amd64    |    3.x     |  yes  | amd64/node:18-alpine       |
|                            |   18   | arm32v7  |    3.x     |  yes  | arm32v7/node:18-alpine     |
|                            |   18   | arm64v8  |    3.x     |  yes  | arm64v8/node:18-alpine     |
|                            |   18   | i386     |    3.x     |  yes  | i386/node:18-alpine        |
|                            |        |          |            |       |                            |
| 4.0.3-18-minimal           |   18   | amd64    |     no     |  no   | amd64/node:18-alpine       |
|                            |   18   | arm32v7  |     no     |  no   | arm32v7/node:18-alpine     |
|                            |   18   | arm64v8  |     no     |  no   | arm64v8/node:18-alpine     |
|                            |   18   | i386     |     no     |  no   | i386/node:18-alpine        |

| **Tag**                    |**Node**| **Arch** | **Python** |**Dev**| **Base Image**             |
|----------------------------|--------|----------|------------|-------|----------------------------|
| 4.0.3-20                   |   20   | amd64    |    3.x     |  yes  | amd64/node:20-alpine       |
|                            |   20   | arm32v7  |    3.x     |  yes  | arm32v7/node:20-alpine     |
|                            |   20   | arm64v8  |    3.x     |  yes  | arm64v8/node:20-alpine     |
|                            |   20   | i386     |    3.x     |  yes  | i386/node:20-alpine        |
|                            |        |          |            |       |                            |
| 4.0.3-20-minimal           |   20   | amd64    |     no     |  no   | amd64/node:20-alpine       |
|                            |   20   | arm32v7  |     no     |  no   | arm32v7/node:20-alpine     |
|                            |   20   | arm64v8  |     no     |  no   | arm64v8/node:20-alpine     |
|                            |   20   | i386     |     no     |  no   | i386/node:20-alpine        |
|                            |        |          |            |       |                            |
| 4.0.3-debian               |   20   | amd64    |    3.x     |  yes  | amd64/node:20-buster-slim  |
|                            |   20   | arm32v7  |    3.x     |  yes  | amd64/node:20-buster-slim  |
|                            |   20   | arm64v8  |    3.x     |  yes  | amd64/node:20-buster-slim  |

| **Tag**                    |**Node**| **Arch** | **Python** |**Dev**| **Base Image**             |
|----------------------------|--------|----------|------------|-------|----------------------------|
| 4.0.3-22                   |   22   | amd64    |    3.x     |  yes  | amd64/node:22-alpine       |
|                            |   22   | arm32v7  |    3.x     |  yes  | arm32v7/node:22-alpine     |
|                            |   22   | arm64v8  |    3.x     |  yes  | arm64v8/node:22-alpine     |
|                            |   22   | i386     |    3.x     |  yes  | i386/node:22-alpine        |
|                            |        |          |            |       |                            |
| 4.0.3-22-minimal           |   22   | amd64    |     no     |  no   | amd64/node:22-alpine       |
|                            |   22   | arm32v7  |     no     |  no   | arm32v7/node:22-alpine     |
|                            |   22   | arm64v8  |     no     |  no   | arm64v8/node:22-alpine     |
|                            |   22   | i386     |     no     |  no   | i386/node:22-alpine        |

- All images have bash, tzdata, nano, curl, git, openssl and openssh-client pre-installed to support Node-RED's Projects feature.

## Manifest Lists
The following table shows the provided Manifest Lists.

| **Tag**                                | **Node-RED Base Image**                    |
|----------------------------------------|--------------------------------------------|
| latest, 4.0.3,                         | nodered/node-red:4.0.3-20                  |
| latest-20, 4.0.3-20                    |                                            |
|                                        |                                            |
|                                        |                                            |
| latest-minimal, 4.0.3-minimal,         | nodered/node-red:4.0.3-20-minimal          |
| latest-20-minimal, 4.0.3-20-minimal    |                                            |
|                                        |                                            |
| latest-debian                          | nodered/node-red:latest-debian             |


| **Tag**                                | **Node-RED Base Image**                    |
|----------------------------------------|--------------------------------------------|
| latest-18, 4.0.3-18                    | nodered/node-red:4.0.3-18                  |
|                                        |                                            |
| latest-18-minimal, 4.0.3-18-minimal    | nodered/node-red:4.0.3-18-minimal          |


| **Tag**                                | **Node-RED Base Image**                    |
|----------------------------------------|--------------------------------------------|
| latest-22, 4.0.3-22                    | nodered/node-red:4.0.3-22                  |
|                                        |                                            |
| latest-22-minimal, 4.0.3-22-minimal    | nodered/node-red:4.0.3-22-minimal          


With the support of Docker manifest list, there is no need to explicitly add the tag for the architecture to use.
When a docker run command or docker service command or docker stack command is executed, docker checks which architecture is required and verifies if it is available in the docker repository. If it does, docker pulls the matching image for it.

Therefore all tags regarding Raspberry PI's are dropped.

For example: suppose you are running on a Raspberry PI 3B, which has `arm32v7` as architecture. Then just run the following command to pull the image (tagged by `4.0.3-20`), and run the container.


```
docker run -it -p 1880:1880 -v node_red_data:/data --name mynodered nodered/node-red:latest
```

This gives the advantage that you don't need to know/specify which architecture you are running on and makes docker run commands and docker compose files more flexible and exchangeable across systems.


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

        $ docker volume create --name node_red_data_vol
        $ docker volume ls
        DRIVER              VOLUME NAME
        local               node_red_data_vol
        $ docker run -it -p 1880:1880 -v node_red_data_vol:/data --name mynodered nodered/node-red

Using Node-RED to create and deploy some sample flows, we can now destroy the
container and start a new instance without losing our user data.

        $ docker rm mynodered
        $ docker run -it -p 1880:1880 -v node_red_data_vol:/data --name mynodered nodered/node-red

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
        "node-red": "^4.0.3",           <-- set the version of Node-RED here
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
docker run -it -p 1880:1880 -e FLOWS=my_flows.json -v node_red_data:/data nodered/node-red
```

**Note**: If you set `-e FLOWS=""` then the flow file can be set via the *flowFile*
property in the `settings.js` file.

Node.js runtime arguments can be passed to the container using an environment
parameter (**NODE_OPTIONS**). For example, to fix the heap size used by
the Node.js garbage collector you would use the following command.
```
docker run -it -p 1880:1880 -e NODE_OPTIONS="--max_old_space_size=128" -v node_red_data:/data nodered/node-red
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

**NOTE**: as this does not mount the `/data` volume externally any changes to flows will not be saved and if the container is redeployed or upgraded these will be lost. The volume may persist on the host filing sysem and can probably be retrieved and remounted if required.

## Linking Containers

You can link containers "internally" within the docker runtime by using Docker [user-defined bridges](https://docs.docker.com/network/bridge/).

Before using a bridge, it needs to be created.  The command below will create a new bridge called **iot**

    docker network create iot

Then all containers that need to communicate need to be added to the same bridge using the **--network** command line option

    docker run -itd --network iot --name mybroker eclipse-mosquitto mosquitto -c /mosquitto-no-auth.conf

(no need to expose the port 1883 globally unless you want to... as we do magic below)

Then run nodered docker, also added to the same bridge

    docker run -itd -p 1880:1880 --network iot --name mynodered nodered/node-red

containers on the same user-defined bridge can take advantage of the built in name resolution provided by the bridge and use the container name (specified using the **--name** option) as the target hostname.


In the above example the broker can be reached from the Node-RED application using hostname *mybroker*.

Then a simple flow like below show the mqtt nodes connecting to the broker

        [{"id":"c51cbf73.d90738","type":"mqtt in","z":"3fa278ec.8cbaf","name":"","topic":"test","broker":"5673f1d5.dd5f1","x":290,"y":240,"wires":[["7781c73.639b8b8"]]},{"id":"7008d6ef.b6ee38","type":"mqtt out","z":"3fa278ec.8cbaf","name":"","topic":"test","qos":"","retain":"","broker":"5673f1d5.dd5f1","x":517,"y":131,"wires":[]},{"id":"ef5b970c.7c864","type":"inject","z":"3fa278ec.8cbaf","name":"","repeat":"","crontab":"","once":false,"topic":"","payload":"","payloadType":"date","x":290,"y":153,"wires":[["7008d6ef.b6ee38"]]},{"id":"7781c73.639b8b8","type":"debug","z":"3fa278ec.8cbaf","name":"","active":true,"tosidebar":true,"console":false,"tostatus":true,"complete":"payload","targetType":"msg","statusVal":"payload","statusType":"auto","x":505,"y":257,"wires":[]},{"id":"5673f1d5.dd5f1","type":"mqtt-broker","z":"","name":"","broker":"mybroker","port":"1883","clientid":"","usetls":false,"compatmode":false,"keepalive":"15","cleansession":true,"birthTopic":"","birthQos":"0","birthRetain":"false","birthPayload":"","closeTopic":"","closeRetain":"false","closePayload":"","willTopic":"","willQos":"0","willRetain":"false","willPayload":""}]

This way the internal broker is not exposed outside of the docker host - of course
you may add `-p 1883:1883`  etc to the broker run command if you want other systems outside your computer to be able to use the broker.

### Docker-Compose linking example

Another way to link containers is by using docker-compose. The following docker-compose.yml
file creates a Node-RED instance, and a local MQTT broker instance. In the Node-RED flow the broker can be addressed simply as `mybroker` at its default port `1883`.

```
version: "3.7"

services:
  mynodered:
    image: nodered/node-red
    restart: unless-stopped
    volumes:
      - /home/pi/.node-red:/data
    ports:
      - 1880:1880
  mybroker:
    image: eclipse-mosquitto
    restart: unless-stopped
    command: mosquitto -c /mosquitto-no-auth.conf
```

## Debugging containers

Sometimes it is useful to debug the code which is running inside the container.  Two scripts (*'debug'* and *'debug_brk'* in the package.json file) are available to start NodeJs in debug mode, which means that NodeJs will start listening (to port 9229) for a debug client. Various remote debugger tools (like Visual Code, Chrome Developer Tools ...) can be used to debug a Node-RED application.  A [wiki](https://github.com/node-red/node-red-docker/wiki/Debug-container-via-Chrome-Developer-Tools) page has been provided, to explain step-by-step how to use the Chrome Developer Tools debugger.

1. In most cases the *'debug'* script will be sufficient, to debug a Node-RED application that is fully up-and-running (i.e. when the application startup code is not relevant).  The NodeJs server can be started in debug mode using following command:
   ```
   docker run -it -p 1880:1880 -p 9229:9229 -v node_red_data:/data --name mynodered --entrypoint npm nodered/node-red run debug -- --userDir /data
   ```

2. In case debugging of the Node-RED startup code is required, the  *'debug_brk'* script will instruct NodeJs to break at the first statement of the Node-RED application.  The NodeJs server can be started in debug mode using following command:
   ```
   docker run -it -p 1880:1880 -p 9229:9229 -v node_red_data:/data --name mynodered --entrypoint npm nodered/node-red run debug_brk -- --userDir /data
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
        -v node_red_data:/data  - mount the internal /data to the host mode_red_data directory
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
docker run -it -p 1880:1880 -v node_red_data:/data --name mynodered -u root nodered/node-red
```

__References:__

https://github.com/node-red/node-red/issues/15

https://github.com/node-red/node-red/issues/8

<br>

### Accessing Host Devices

If you want to access a device from the host inside the container, e.g. serial port, use the following command-line flag to pass access through.

```
docker run -it -p 1880:1880 -v node_red_data:/data --name mynodered --device=/dev/ttyACM0 nodered/node-red
```
__References:__

https://github.com/node-red/node-red/issues/15

<br>

### Setting Timezone

If you want to modify the default timezone, use the TZ environment variable with the [relevant timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

```
docker run -it -p 1880:1880 -v node_red_data:/data --name mynodered -e TZ=America/New_York nodered/node-red
```

or within a docker-compose file
```
  node-red:
    environment:
      - TZ=America/New_York
```

__References:__

https://groups.google.com/forum/#!topic/node-red/ieo5IVFAo2o

<br>

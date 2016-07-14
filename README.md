# Node-RED-Docker

This project describes some of the many ways Node-RED can be run under Docker.
Some basic familiarity with Docker and the
[Docker Command Line](https://docs.docker.com/reference/commandline/cli/)
is assumed.

This project also provides the build for the (*to be renamed*) "thedceejay/nreddock"
container on [DockerHub](https://registry.hub.docker.com/u/theceejay/nreddock/).

To run this directly in docker at it's simplest just run

        docker run -it -p 1880:1880 --name mynodered theceejay/nreddock

Let's dissect that command...

        docker run      - run this container... and build locally if necessary first.
        -it             - attach a terminal session so we can see what is going on
        -p 1880:1880    - connect local port 1880 to the exposed internal port 1880
        --name mynodered - give this machine a friendly local name
        theceejay/nreddock - the image to base it on - currently Node-RED v0.10.6


Running that command should give a terminal window with a running instance of Node-RED

        Welcome to Node-RED
        ===================
        8 Apr 12:13:44 - [info] Node-RED version: v0.10.6
        8 Apr 12:13:44 - [info] Node.js  version: v0.10.38
        .... etc

You can then browse to `http://{host-ip}:1880` to get the familiar Node-RED desktop.

The advantage of doing this is that by giving it a name we can manipulate it
more easily, and by fixing the host port we know we are on familiar ground.
(Of course this does mean we can only run one instance at a time... but one step at a time folks...)

If we are happy with what we see we can stop the command window - `Ctrl-c` and then run

        $ docker ps -a
        CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS                       PORTS               NAMES
        b03e408d3905        theceejay/nreddock:latest   "npm start"         12 seconds ago      Exited (130) 7 seconds ago                       mynodered   .

Notice the machine is now stopped ("exited") - and if your browser window is still open it
should report "lost connection to server".

You can now restart it

        $ docker start mynodered

and stop it again when required

        $ docker stop mynodered

**Note** : this Dockerfile is configured to store the flows.json file and any
extra nodes you install "outside" of the container. Specifically we export the
`/root/.node-red` directory. We do this so that you may rebuild the underlying
container without permanently losing all of your customisations.

##Container Layout 

This project contains Dockerfiles to build two separate Node-RED images. 

- **standard/Dockerfile** Node-RED image using official Node.JS v4 base image.
- **small/Dockerfile** Node-RED image using Alpine Linux base image.

Using Alpine Linux reduces the built image size (~100MB vs ~700MB) but removes
standard dependencies that are required for native module compilation. If you
want to add modules with native dependencies, use the standard image or extend
the small image with the missing packages.

Build these images with the following command...

        $ docker build -t mynodered:standard -f standard/Dockerfile .
        $ docker build -t mynodered:small -f small/Dockerfile .

The project's package.json file contains Node-RED as a dependency, along with
other nodes to include in the default install. During the Docker build
process, the dependencies are installed under /usr/src/node-red.

Node-RED is started using NPM start from this directory, with the --userDir
parameter pointing to the /data directory on the container. The /data directory
is exported as a Docker volume to make it simple to save user configuration
outside the container. See below for more details on this...

##Customising

To install extra Node-RED modules via npm you can either use the Node-RED
command-line tool externally on your host machine, pointed at the running
container, run npm install manually, using a shell on the container or locally
into the mounted volume, or build a new image.

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

### Local Volume

Running a Node-RED container with a host directory mounted as the data volume,
you can manually run `npm install` within your host directory. Files created in
the host directory will automatically appear in the container's file system.

        $ docker run -it -p 1880:1880 -v ~/.node-red:/data --name mynodered theceejay/nreddock

This command mounts the host's node-red directory, containing the user's
configuration and installed nodes, as the user configuration directory inside
the container. Adding extra nodes to the container can be accomplished by
running npm install locally.

        $ cd ~/.node-red
        $ npm install node-red-node-smooth
        node-red-node-smooth@0.0.3 node_modules/node-red-node-smooth
        $ docker stop mynodered
        $ docker start mynodered


**Note** : Modules with a native dependencies will be compiled on the host
machine's architecture. These modules will not work inside the Node-RED
container unless the architecture matches the container's base image. For native
modules, it is recommended to install using a local shell or update the
project's package.json and re-build.

###Custom Image

Creating a new Docker image, using the public Node-RED images as the base image,
allows you to install extra nodes during the build process.

This Dockerfile builds a custom Node-RED image with the flightaware module
installed from NPM.

```
FROM jamesthomas/node-red
RUN npm install node-red-contrib-flightaware
```

Alternatively, you can modify the package.json in this repository and re-build
the images from scratch. This will also allow you to modify the version of
Node-RED that is installed. See below for more details...

##Adding Volumes

As previously mentioned by default we export the /data directory, with is used
to store user data for the Node-RED instance. Without any extra command
parameters this usuually gets mounted somewhere like `/var/lib/docker/vfs/dir/`
where it will appear as a directory with a long hexadecimal name. If you delete
either the running machine or the underlying image container this directory
should remain preserving your data.

If you create another image you can "migrate" the data from this directory to
the a new one that will be created when the new image starts running. There is
no "easy" way to keep track of these directories except manually.

**Note** : the new machine will not automatically pick up the old flow and
customisations.

The way to fix this is to use a named data volume... to do this you can either
mount them to a named directory on the host machine, or to a named data container.

The former is simpler, but less transportable - the latter the "more Docker way".

##Updating

Updating the base container image is as simple as

        $ docker pull theceejay/nreddock
        $ docker stop mynodered
        $ docker start mynodered

##Running headless

The barest minimum we need to just run Node-RED is

    $ docker run -d -p 1880 theceejay/nreddock

This will create a local running instance of a machine - that will have some
docker id number and be running on a random port... to find out run

    $ docker ps -a
    CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS                     PORTS                     NAMES
    4bbeb39dc8dc        theceejay/nreddock:latest   "npm start"         4 seconds ago       Up 4 seconds               0.0.0.0:49154->1880/tcp   furious_yalow
    $

You can now point a browser to the host machine on the tcp port reported back, so in the example
above browse to  `http://{host ip}:49154`

##Roll your own

the simplest way to build your own custom image is to clone this project and edit
the Dockerfile and package.json.

####package.json

The package.json is a metafile that downloads and installs the required version
of Node-RED and any other npms you wish to install at build time.

The main sections to modify are

    "dependencies": {
        "node-red": "0.10.6",           <-- set the version of Node-RED here
        "node-red-node-rbe": "*"        <-- add any extra npm packages here
    },

This is where you can pre-define any extra nodes you want installed every time
by default, and then

    "scripts"      : {
        "start": "node-red -v flow.json"
    },

This is the command that starts Node-RED when the container is run.

##Linking Containers

You can link containers "internally" within the docker runtime by using the --link option.

For example I have a simple MQTT broker container available as

        docker run -it --name mybroker theceejay/nrbroker

(no need to expose the port 1883 globally unless you want to... as we do magic below)

Then run nodered docker - but this time with a link parameter (name:alias)

        docker run -it -p 1880:1880 --name mynodered --link mybroker:broker theceejay/nreddock

the magic here being the `--link` that inserts a entry into the node-red instance
hosts file called *broker* that links to the mybroker instance....  but we do
expose the 1880 port so we can use an external browser to do the node-red editing.

Then a simple flow like below should work - using the alias *broker* we just set up a second ago.

        [{"id":"190c0df7.e6f3f2","type":"mqtt-broker","broker":"broker","port":"1883","clientid":""},{"id":"37963300.c869cc","type":"mqtt in","name":"","topic":"test","broker":"190c0df7.e6f3f2","x":226,"y":244,"z":"f34f9922.0cb068","wires":[["802d92f9.7fd27"]]},{"id":"edad4162.1252c","type":"mqtt out","name":"","topic":"test","qos":"","retain":"","broker":"190c0df7.e6f3f2","x":453,"y":135,"z":"f34f9922.0cb068","wires":[]},{"id":"13d1cf31.ec2e31","type":"inject","name":"","topic":"","payload":"","payloadType":"date","repeat":"","crontab":"","once":false,"x":226,"y":157,"z":"f34f9922.0cb068","wires":[["edad4162.1252c"]]},{"id":"802d92f9.7fd27","type":"debug","name":"","active":true,"console":"false","complete":"false","x":441,"y":261,"z":"f34f9922.0cb068","wires":[]}]

This way the internal broker is not exposed outside of the docker host - of course
you may add `-p 1883:1883`  etc to the broker run command if you want to see it...

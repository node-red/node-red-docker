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

##Customising

To install extra Node-RED modules via npm you can either use the Node-RED command-line tool
externally on your host machine - pointed at the running container... or

        $ docker exec -it mynodered /bin/bash

Will give a command line inside the container - where you can then run the npm install
command you wish - e.g.

        $ npm install node-red-node-smooth
        node-red-node-smooth@0.0.3 node_modules/node-red-node-smooth
        $ exit
        $ docker stop mynodered
        $ docker start mynodered

Refreshing the browser page should now reveal the newly added node in the palette.

##Adding Volumes

As previously mentioned by default we export the /root/.node-red directory.
Without any extra command parameters this usuually gets mounted somewhere like
`/var/lib/docker/vfs/dir/` where it will appear as a directory with a long
hexadecimal name. If you delete either the running machine or the underlying image
container this directory should remain preserving your data.

If you create another image you can "migrate" the data from this directory to
the a new one that will be created when the new image starts running. There is
no "easy" way to keep track of these directories except manually.

**Note** : the new machine will not automatically pick up the old flow and
customisations.

The way to fix this is to use a named data volume... to do this you can either
mount them to a named directory on the host machine, or to a named data container.

The former is simpler, but less transportable - the latter the "more Docker way".

####Local volume

    docker run -it -p 1880:1880 -v ~/mydata:/root/.node-red --name mynodered theceejay/nreddock

Will mount that same `root/.node-red` to the `~/mydata` directory on the host.
What this means is that if you delete and recreate an image or machine then by
adding the volume in this way will re-use the existing data - hopefully allowing
smoother upgrades and migrations.

####Data container

tbd


    docker run --name mydata --entrypoint /bin/echo mynodered Data-only container for Node-RED
    docker run -d --name mynodered --volumes-from mydata theceejay/nreddock


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
        "start": "node node_modules/node-red/red.js flow.json"
    },

This is the command that starts Node-RED when the container is run.

####Dockerfile

The existing Dockerfile is very simple

        FROM node:0.10-onbuild
        VOLUME /root/.node-red
        EXPOSE 1880

What this does is use the "on-build" version of node.js v0.10.* - this then reads
the co-located package.json file (see above) - and installs whatever is defined there...

It then exposes the `/root/.node-red` directory to the be mounted externally so we can
save flows and other npms installed after the build.

Finally it exposes the default Node-RED port 1880 to be available externally.

**Note** : This also copies any files in the same directory as the Dockerfile
to the /usr/src/app directory in the container... this means you can also add
other node_modules or pre-configured libraries - or indeed
overwrite the `node_modules/node-red/settings.js` file if you wish.

To build your image then run

        $ docker build -t customnodered .

and run with

        $ docker run -it -p 1880:1880 --name yournodered customnodered

##Minimum Viable Container

(needs Node-RED v0.10.8 to be released :-)

This example Dockerfile uses a non-offical minimal node.js runtime. It ends
up making an 80MB runtime for Node-RED (as opposed to the typical 800MB of
the official ones above.

The main impact is that GYP is missing so any node-modules that need compiling
on install will fail... The core of Node-RED is OK.

        FROM mhart/alpine-node:0.10
        RUN npm install node-red
        VOLUME /root/.node-red
        EXPOSE 1880
        CMD cd ~/.node-red && node /node_modules/node-red/red.js flow.json

As per above it can be built and run with

        $ docker build -t minnodered .
        $ docker run -it -p 1880:1880 --name myminred minnodered

## Resolution for issue #197 _"docker image always creates a /data volume"_

### Introduction

This page describes the resolution of issue [#197 docker image always creates a /data volume](https://github.com/node-red/node-red-docker/issues/197) and potential impact.  It must be noted that most of us won't see any impact and that the new Node-RED docker images with respect to docker volumes will behave as expected.

### Change = removal of line: "`VOLUME [/data]`"

The Node-RED docker images at [nodered/node-red](https://hub.docker.com/r/nodered/node-red/) up to Node-RED version 1.1.3 contained the following line:

```
VOLUME [/data]
````

This single line is now removed in recently published docker images (starting from Node-RED version 1.2.0).

### Impact of the line "`VOLUME [/data]`"

See also [documentation for `VOLUME` instruction in dockerfile reference](https://docs.docker.com/engine/reference/builder/#volume)

When a docker container is created without explicitly specifying a docker volume for `/data` folder then this line assures that a docker volume is automatically created and that the contents of the `/data` folder from the base image are copied to this automatically created volume.

Note that removing the container, will not automatically remove this volume !  So you need to explicitly remove this volume if you no longer need it - which is not that easy as this anonymous volume has a randomly generated name like "`76cc15fa0b6184c7ce6a2a4b865cdf2cd7d62661256e8ba2b5a4dff2d30da1e4`".

#### Unexpected behaviour when used with `docker-compose`

This section explains unexpected behaviour when using docker images containing also the flows based on old Node-RED docker images (v1.1.3 and earlier) in combination with docker-compose.

The problem scenario:

1. Someone creates a docker image `Img:1.0.0` which contains the Node-RED flow `Flow_1.0.0`
2. You have created a docker-compose file defining a service using this `Img:1.0.0`
3. The command "`docker-compose up`" will properly start this service and the very first time will create an anonymous volume that is mounted to the `/data` folder where the flow `Flow_1.0.0` is copied to.
4. Someone updates the docker image (= `Img:2.0.0`) which now contains the updated Node-RED flows `Flow_2.0.0`.
5. You want to use the new version of the image, so You run first the `docker-compose pull` command.  Which will correctly download image `Img:2.0.0`
6. then you run command "`docker-compose up`" to deploy the new version but this will indeed deploy the new version of the image but it won't create a new volume: it will still use the same volume created in step 3.  This also means that it will NOT copy flow `FLow_2.0.0` from the image to the mounted volume and consequently it will still use the old flow `Flow_1.0.0` instead of the new flow `Flow_2.0.0`

So in order to avoid this problem you must explicitly remove the "anonymous volume" before executing step 6.

FYI it is especially the "`(preserving mounted volumes)`" in the following paragraph of  [docker-compose up documentation](https://docs.docker.com/compose/reference/up/) that explains why we have this problem with docker-compose.

```
If there are existing containers for a service, and the service’s configuration or image was changed after the container’s creation, docker-compose up picks up the changes by stopping and recreating the containers (preserving mounted volumes).
```

# Should I care about this change ?

### A. I have explicitly specified a volume to be mounted to /data.

In case you have explicitly defined a volume to be mounted to the "`/data`" folder when creating the container then nothing changes for you.  Everything will work exactly as before.  When upgrading to a new docker image without the "`VOLUME [/data]`" it will still use the latest flows you have saved just before the upgrade.

### B. I didn't explicitly specify a volume to be mounted to /data.

It still means that the file changes saved in the  "`/data`" folder when using new Node-RED docker image (= image without the "`VOLUME [/data]`") are not lost when stopping and starting the container or rebooting the docker host machine !  They are persisted in the container writeable layer and will be kept as long as the container is not removed.

So when using the standard docker commands to  start/stop/run/remove/create containers everything will work as before.  Moreover with new Node-RED docker images you no longer need to cleanup those anonymous volumes when removing the container.

#### **ATTENTION**:  I am using `docker-compose` and have not explicitly specified a volume to be mounted to /data

So when upgrading a service to use a new Node-RED docker image (= image without the "`VOLUME [/data]`") using the "`docker-compose up`" command you will notice that the anonymous volume is still mounted to the `/data` folder as the "`docker-compose up`" command is preserving mounted volumes.  This might be a good thing in case you still want to use the flows you have saved before the upgrade.
... but this might also be an undesired thing, in case you want to use the flows in the "`/data`" folders of the new docker image.  The fix for this is easy.  You first have to remove the respective docker container and only then run the "`docker-compose up`" command as this command will now rebuild the container without mounting any volume.

When upgrading from one image to another image and both images are based on a recent Node-RED docker image (= image without the "`VOLUME [/data]`") AND there was no preserved mount of the `/data` folder then the `/data` folder is completely replaced by the `/data` folder of the new image !

## Support

If you are still stuck or need more support then we recommend to open a topic in the [Node-RED forum](https://discourse.nodered.org/) for this.
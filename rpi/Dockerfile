ARG NODE_VERSION=10
FROM arm32v7/node:${NODE_VERSION}

# add sources for raspberry pi
RUN printf "deb http://archive.raspberrypi.org/debian/ stretch main ui" > /etc/apt/sources.list.d/raspberrypi.list && \
    curl --silent http://archive.raspberrypi.org/debian/raspberrypi.gpg.key | apt-key add -

# add support for gpio library
RUN apt-get update
RUN apt-get install python-rpi.gpio

# Home directory for Node-RED application source code.
RUN mkdir -p /usr/src/node-red

# User data directory, contains flows, config and nodes.
RUN mkdir /data

WORKDIR /usr/src/node-red

# delete node user that has UID 1000
RUN userdel node

# Add node-red user so we aren't running as root.
RUN useradd --home-dir /usr/src/node-red --no-create-home node-red \
    && chown -R node-red:node-red /data \
    && chown -R node-red:node-red /usr/src/node-red

USER node-red

# package.json contains Node-RED NPM module and node dependencies
COPY package.json /usr/src/node-red/
RUN npm install

# User configuration directory volume
EXPOSE 1880

# Environment variable holding file path for flows configuration
ENV FLOWS=flows.json
ENV NODE_PATH=/usr/src/node-red/node_modules:/data/node_modules

CMD ["npm", "start", "--", "--userDir", "/data"]

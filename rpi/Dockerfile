ARG NODE_VERSION=8
FROM arm32v7/node:${NODE_VERSION}-stretch-slim

# Install the base requirements
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y python python-pip \
    && pip install RPi.GPIO \
    && npm install -g --unsafe-perm npm

# Set the Docker working directory for Node-RED
WORKDIR /usr/src/node-red

# Add node-red user so we aren't running as root.
RUN mkdir -p /data \
    && mkdir -p /usr/src/node-red \
    && useradd --home-dir /usr/src/node-red --no-create-home node-red

# package.json contains Node-RED NPM module and node dependencies
COPY package.json /usr/src/node-red/

# Install Node-RED
RUN cd /usr/src/node-red/ \
    && npm install \
    && npm install -g --unsafe-perm node-red-admin

# Clean-up
RUN apt-get clean -y \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Set ownership permissions
RUN chown -R node-red:node-red /data \
    && chown -R node-red:node-red /usr/src/node-red

# Node-RED default un-encrypted TCP port for HTTP
EXPOSE 1880

# Run Node-RED as user node-red (not as root)
USER node-red

# Environment variable holding file path for flows configuration
ENV FLOWS=flows.json
ENV NODE_PATH=/usr/src/node-red/node_modules:/data/node_modules

# Start Node-RED
CMD ["npm", "start", "--", "--userDir", "/data"]

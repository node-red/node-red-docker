ARG NODE_VERSION=10
FROM arm32v7/node:${NODE_VERSION}-stretch-slim

# Set the Docker working directory for Node-RED
WORKDIR /data

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && mkdir -p /data \
    && useradd --home-dir /data --no-create-home node-red \
    && apt-get install -y python python-pip \
    && pip install RPi.GPIO \
    && npm install -g --unsafe-perm npm \
    && npm install -g --unsafe-perm node-red \
    && npm install -g --unsafe-perm node-red-admin \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && chown -R node-red:node-red /data

# Node-RED default un-encrypted TCP port for HTTP
EXPOSE 1880

# Run Node-RED as user node-red (not as root)
USER node-red

# Environment variable holding file path for flows configuration
ENV FLOWS=flows.json
ENV NODE_PATH=/data/.node-red/node_modules

# Start Node-RED
CMD ["node-red"]

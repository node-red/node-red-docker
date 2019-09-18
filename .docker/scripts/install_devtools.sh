#!/bin/bash
set -ex

# Install Devtools
echo "Installing devtools"
apk add --no-cache --virtual devtools build-base linux-headers udev python python3

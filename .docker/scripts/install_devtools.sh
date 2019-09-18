#!/bin/bash
set -ex

# Install Devtools
if [[ ${TAG_SUFFIX} == "default" ]]; then
  echo "Installing devtools"
  apk add --no-cache build-base linux-headers udev python python3
else
  echo "Skip installing Devtools"
fi

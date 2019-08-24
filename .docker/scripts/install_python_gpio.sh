#!/bin/bash
set -ex

# Install Python2
if [[ ${PYTHON_VERSION} == "2" ]]; then
  echo "Installing Python 2"
  apk add --no-cache python
fi

# Install Python3
if [[ ${PYTHON_VERSION} == "3" ]]; then
  echo "Installing Python 3"
  apk add --no-cache python3
  echo "Fixing Python 3 symlink"
  ln -s /usr/bin/python3 /usr/bin/python
fi

# Install rpigpio library for arm
if [[ ${PYTHON_VERSION} != "0" ]]; then
  if [[ ${ARCH} == "arm32v6" ]] || [[ ${ARCH} == "arm32v7" ]]; then
    echo "Installing py-rpigpio"
    apk add py-rpigpio

    echo "Fixing 36-rpi-gpio.js for Python"
    sed -i 's/python2.7/python/g' node_modules/\@node-red/nodes/core/hardware/36-rpi-gpio.js
    # Create symlink for python libs
    ln -s /usr/lib/python$(python -c 'import sys; print(".".join(map(str, sys.version_info[:2])))') /usr/lib/python
  fi
fi

# Remove Node-Red build-in rpi-gpio when python is not installed or for non arm arch
if [[ ${PYTHON_VERSION} == "0" ]] || ! { [[ ${ARCH} == "arm32v6" ]] || [[ ${ARCH} == "arm32v7" ]]; }; then
  echo "Removing Node-RED build-in rpi-gpio"
  rm -r node_modules/\@node-red/nodes/core/hardware/*
fi

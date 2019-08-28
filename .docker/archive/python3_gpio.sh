#!/bin/bash
set -ex

# Install Python3 and pigpio library for arm
if [[ ${PYTHON_VERSION} == "3" ]]; then
  echo "Installing Python 3"
  if [[ ${OS} == "alpine" ]]; then
    apk add --no-cache python3
    echo "Fixing Python 3 symlink"
    ln -s /usr/bin/python3 /usr/bin/python
    if [[ ${ARCH} == "arm32v6" ]]; then
      echo "Installing py-rpigpio"
      apk add py-rpigpio
    fi
  else
    apt-get update && apt-get install -y --no-install-recommends python3
    echo "Fixing Python 3 symlink"
    ln -s /usr/bin/python3 /usr/bin/python
    if [[ ${ARCH} == "arm32v7" ]]; then
      echo "Installing python3-pigpio python3-rpi.gpio"
      apt-get install -y python3-pigpio python3-rpi.gpio
#       apt-get update && apt-get install -y --no-install-recommends python3-dev python3-pip python3-setuptools build-essential
#       pip3 install RPi.GPIO
#       apt-get remove python3-dev python3-pip python3-setuptools build-essential
#       apt autoremove
#       rm -rf /var/lib/apt/lists/*
    fi
  fi
fi

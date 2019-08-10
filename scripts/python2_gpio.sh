#!/bin/bash
set -ex

# Install Python2 and pigpio library for arm
if [[ ${PYTHON_VERSION} == "2" ]]; then
  echo "Installing Python 2"
  if [[ ${OS} == "alpine" ]]; then
    apk add --no-cache python
    if [[ ${ARCH} == "arm32v6" ]]; then
      echo "Installing py-rpigpio"
      apk add py-rpigpio
    fi
  else
    apt-get update && apt-get install -y --no-install-recommends python
    if [[ ${ARCH} == "arm32v7" ]]; then
      echo "Installing python-pigpio"
      apt-get install -y --no-install-recommends python-pigpio
    fi
  fi
fi

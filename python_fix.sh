#!/bin/bash
set -ex

if [[ "${PYTHON_VERSION}" == "3" ]] && [[ "${ARCH}" == "arm32v7" ]]; then
  echo "Fixing 36-rpi-gpio.js for Python 3.6"
  sed -i 's/python2.7/python3.6/g' node_modules/\@node-red/nodes/core/hardware/36-rpi-gpio.js
fi

if [[ "${ARCH}" != "arm32v7" ]]; then
  echo "Removing Node-RED build-in rpi-gpio"
  rm -r node_modules/\@node-red/nodes/core/hardware/*
fi

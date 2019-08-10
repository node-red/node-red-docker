#!/bin/bash
set -ex

# Fix 36-rpi-gpio for Python3
if [[ ${PYTHON_VERSION} == "3" ]]; then
  echo "Fixing 36-rpi-gpio.js for Python 3.6"
  sed -i 's/python2.7/python3.6/g' node_modules/\@node-red/nodes/core/hardware/36-rpi-gpio.js
fi

# Remove Node-Red build-in rpi-gpio when python is not installed or for non arm arch
if [[ ${PYTHON_VERSION} == "0" ]] || ! { [[ ${ARCH} == "arm32v6" ]] || [[ ${ARCH} == "arm32v7" ]]; }; then
  echo "Removing Node-RED build-in rpi-gpio"
  rm -r node_modules/\@node-red/nodes/core/hardware/*
fi

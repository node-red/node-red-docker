#!/bin/bash
set -ex

# Skip 36-rpi-gpio if not exists
if [[ ! -f "node_modules/\@node-red/nodes/core/hardware/36-rpi-gpio.js" ]]; then
  exit 0;
fi

# Fix 36-rpi-gpio for Python
if [[ ${PYTHON_VERSION} != "0" ]]; then
  echo "Fixing 36-rpi-gpio.js for Python"
  sed -i 's/python2.7/python/g' node_modules/\@node-red/nodes/core/hardware/36-rpi-gpio.js
  # Create symlink for python libs
  ln -s /usr/lib/python$(python -c 'import sys; print(".".join(map(str, sys.version_info[:2])))') /usr/lib/python
fi

# Remove Node-Red build-in rpi-gpio when python is not installed or for non arm arch
if [[ ${PYTHON_VERSION} == "0" ]] || ! { [[ ${ARCH} == "arm32v6" ]] || [[ ${ARCH} == "arm32v7" ]]; }; then
  echo "Removing Node-RED build-in rpi-gpio"
  rm -r node_modules/\@node-red/nodes/core/hardware/*
fi

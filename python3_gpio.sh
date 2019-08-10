#!/bin/bash
set -ex

if [[ "${PYTHON_VERSION}" == "3" ]]; then
  echo "Installing Python 3"
  apt-get update && apt-get update && apt-get install -y --no-install-recommends python3
  echo "Fixing Python 3 symlink"
  ln -s /usr/bin/python3 /usr/bin/python
  if [[ "${ARCH}" == "arm32v6" ]]; then
    echo "Installing py-rpigpio"
    apt-get install -y --no-install-recommends python3-pigpio
  fi
fi

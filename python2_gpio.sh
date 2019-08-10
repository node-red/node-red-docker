#!/bin/bash
set -ex

if [[ "${PYTHON_VERSION}" == "2" ]]; then
  echo "Installing Python 2"
  apt-get update && apt-get install -y --no-install-recommends python
  if [[ "${ARCH}" == "arm32v6" ]]; then
    echo "Installing python-pigpio"
    apt-get install -y --no-install-recommends python-pigpio
  fi
fi

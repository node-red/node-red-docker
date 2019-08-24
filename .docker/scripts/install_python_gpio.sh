#!/bin/bash
set -ex

# Install Python2
if [[ ${PYTHON_VERSION} == "2" ]]; then
  echo "Installing Python 2"
  apk add --no-cache python
else
  echo "Skip installing Python 2"
fi

# Install Python3
if [[ ${PYTHON_VERSION} == "3" ]]; then
  echo "Installing Python 3"
  apk add --no-cache python3
  echo "Fixing Python 3 symlink"
  ln -s /usr/bin/python3 /usr/bin/python
else
  echo "Skip installing Python 3"
fi

# Install rpigpio library for arm
if [[ ${PYTHON_VERSION} != "0" ]]; then
  if [[ ${ARCH} == "arm32v6" ]] || [[ ${ARCH} == "arm32v7" ]]; then
    echo "Installing py-rpigpio"
    apk add py-rpigpio
  else
    echo "Skip installing py-rpigpio"
  fi
fi

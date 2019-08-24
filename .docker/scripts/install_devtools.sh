#!/bin/bash
set -ex

# Install Python3 and pigpio library for arm
if [[ ${DEVTOOLS} == "1" ]]; then
  echo "Installing Devtools"

  apk --no-cache add --virtual builds-deps build-base
fi

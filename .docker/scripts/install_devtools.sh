#!/bin/bash
set -ex

# Install Devtools
if [[ ${DEVTOOLS} == "1" ]]; then
  echo "Installing Devtools"
  apk --no-cache add build-base
fi

#!/bin/bash
set -ex

# Install Devtools
if [[ ${DEVTOOLS} == "1" ]]; then
  echo "Installing Devtools"
  apk apk add --no-cache nmap
fi

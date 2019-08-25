#!/bin/bash
set -ex

# Install Devtools
if [[ ${DEVTOOLS} == "1" ]]; then
  echo "Installing Devtools"
  apk apk --no-cache nmap
fi

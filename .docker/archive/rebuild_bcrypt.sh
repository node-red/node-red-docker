#!/bin/bash
set -ex

# Install Devtools
if [[ ${DEVTOOLS} == "1" ]]; then
  # src: https://github.com/kelektiv/node.bcrypt.js/wiki/Installation-Instructions#alpine-linux-based-images
  echo "Rebuild bcrypt from source"
  npm rebuild bcrypt --build-from-source
fi

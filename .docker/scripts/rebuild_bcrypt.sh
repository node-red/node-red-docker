#!/bin/bash
set -ex

# Rebuild bcrypt from source
if [[ ${TAG_SUFFIX} == "default" ]]; then
  echo "Rebuild bcrypt from source"
  npm rebuild bcrypt --build-from-source
fi

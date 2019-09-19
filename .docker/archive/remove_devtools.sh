#!/bin/bash
set -ex

# Removing Devtools
if [[ ${TAG_SUFFIX} == "minimal" ]]; then
  echo "Removing devtools"
  apk del devtools
fi

#!/bin/bash
set -ex

# Uninstall Devtools
if [[ ${DEVTOOLS} == "0" ]]; then
  echo "Deleting Devtools"
  apk del .builds-deps
fi

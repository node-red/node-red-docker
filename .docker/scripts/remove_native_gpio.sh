#!/bin/bash
set -ex

# Remove native GPIO node if exists
if [[ -d "node_modules/\@node-red/nodes/core/hardware" ]]; then
  rm -r node_modules/\@node-red/nodes/core/hardware
else
  echo "Skip removing native GPIO node"
fi

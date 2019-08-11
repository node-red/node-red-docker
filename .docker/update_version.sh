#!/bin/bash
export NODE_RED_VERSION=`grep -Eo "\"node-red\": \"(\w*.\w*.\w*)" ../package.json | cut -d\" -f4`
sed "s/\(version\": \"\).*\(\"\)/\1$NODE_RED_VERSION\"/g" ../package.json > tmpfile && mv tmpfile ../package.json

echo "### Update version ######################################################"
echo "node-red version: ${NODE_RED_VERSION}"
echo "#########################################################################"

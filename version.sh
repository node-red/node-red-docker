export VERSION=`grep -Eo "\"node-red\": \"(\w*.\w*.\w*)" package.json | cut -d\" -f4`

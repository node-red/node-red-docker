#!/bin/bash

trap stop SIGINT SIGTERM

function stop() {
	kill $CHILD_PID
	wait $CHILD_PID
}

/usr/local/bin/node $NODEOPTIONS node_modules/node-red/red.js --userDir /data $FLOWS &

CHILD_PID="$!"

wait "${CHILD_PID}"
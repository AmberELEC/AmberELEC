#!/bin/bash

if [ "${1: -4}" == ".mid" ]
then
  PORT=$(aplaymidi -l | awk '/.*([0-9]*:[0-9]*) .*/ {a=$1} END{print a}')
  echo Playing "${1}" on midi port $PORT
  /usr/bin/aplaymidi -p $PORT "${1}"
  exit 0
fi

/usr/bin/mpv --input-ipc-server=/tmp/mpvsocket "${1}"
exit 0

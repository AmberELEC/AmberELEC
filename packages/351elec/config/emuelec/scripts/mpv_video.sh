#!/bin/bash

/usr/bin/mpv --input-ipc-server=/tmp/mpvsocket "${1}"
exit 0

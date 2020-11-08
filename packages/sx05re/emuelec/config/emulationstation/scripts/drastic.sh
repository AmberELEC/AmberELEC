#!/bin/sh

# Only run pixel if it exists, mainly for N2
if [ -f "/storage/.emulationstation/scripts/pixel.sh" ]; then
/storage/.emulationstation/scripts/pixel.sh
fi

cd /storage/.emulationstation/scripts/drastic/
./drastic "$1"

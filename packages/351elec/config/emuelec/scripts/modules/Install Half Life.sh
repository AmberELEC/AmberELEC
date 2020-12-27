#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

source /emuelec/scripts/env.sh
source /etc/profile

INSTALLPATH="/storage/roms/ports"
PORTNAME="half-life"

if [ ! -d "${INSTALLPATH}/${PORTNAME}" ]
then
  mkdir "${INSTALLPATH}/${PORTNAME}"
fi

clear >/dev/console
message_stream "Installing Half Life..." .02

cd ${INSTALLPATH}/${PORTNAME}
for bin in client_arm64.so controls.png hl_arm64.so libxash.so libxashmenu64.so xash3d "Copy%20Contents%20into%20valve%20folder.zip"
do
  curl -Lo ${bin} "https://github.com/krishenriksen/Half-Life-rg351p/raw/main/Half-Life/${bin}"
done

unzip -o "Copy%20Contents%20into%20valve%20folder.zip"
mv 'Copy Contents into valve folder' 'dependencies'

### Create the start script
cat <<EOF >${INSTALLPATH}/"Half Life.sh"
export LD_LIBRARY_PATH=${INSTALLPATH}/${PORTNAME}:/usr/lib

cd ${INSTALLPATH}/${PORTNAME}

if [ ! -d "valve" ]
then
  mkdir "valve"
  echo "Unable to find game data.  Please copy to ${INSTALLPATH}/${PORTNAME}/valve" >>/tmp/logs/emuelec.log
  exit 1
else
  rsync -av dependencies/* valve
  ./xash3d -fullscreen -console -sdl_joy_old_api
fi


ret_error=$?
[[ "$ret_error" != 0 ]] && (echo "Error executing Half Life.  Please check that you have copied your game data to ${INSTALLPATH}/${PORTNAME}/valve." >/tmp/logs/emuelec.log)
EOF

if [ ! "$(grep -q 'Half Life' ${INSTALLPATH}/gamelist.xml)" ]
then
	### Add to the game list
	xmlstarlet ed --omit-decl --inplace \
		-s '//gameList' -t elem -n 'game' \
		-s '//gameList/game[last()]' -t elem -n 'path'        -v './Half Life.sh'\
		-s '//gameList/game[last()]' -t elem -n 'name'        -v 'Half Life'\
		-s '//gameList/game[last()]' -t elem -n 'desc'        -v 'Half-Life is a series of first-person shooter games developed and published by Valve.'\
		-s '//gameList/game[last()]' -t elem -n 'image'       -v './images/system-half-life.png'\
		-s '//gameList/game[last()]' -t elem -n 'video'       -v './images/system-half-life.mp4'\
		-s '//gameList/game[last()]' -t elem -n 'thumbnail'   -v './images/system-half-life-thumb.png'\
		-s '//gameList/game[last()]' -t elem -n 'rating'      -v '1.0'\
		-s '//gameList/game[last()]' -t elem -n 'releasedate' -v '19981119T000000'\
		-s '//gameList/game[last()]' -t elem -n 'developer'   -v 'Valve'\
		-s '//gameList/game[last()]' -t elem -n 'publisher'   -v 'Valve'\
		${INSTALLPATH}/gamelist.xml
fi
message_stream "\nRestarting EmulationStation..." .02

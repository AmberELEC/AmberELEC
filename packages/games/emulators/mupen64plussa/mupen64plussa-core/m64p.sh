#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

. /etc/profile

echo 'starting mupen64plus stand alone emulator...'

CORE="$1"
ROM="${2##*/}"
PLATFORM="n64"
SHARE="/usr/local/share/mupen64plus"
INPUTCFGBASE="$SHARE/InputAutoCfg.ini"
CONF="/storage/.config/distribution/configs/distribution.conf"
M64PCONF="/storage/.config/mupen64plussa/mupen64plus.cfg"
TMP="/tmp/mupen64plussa"
GAMEDATA="/storage/roms/gamedata/mupen64plussa"

rm -rf $TMP
mkdir -p $TMP

function get_setting() {
	#We look for the setting on the ROM first, if not found we search for platform and lastly we search globally
	PAT="s|^${PLATFORM}\[\"${ROM}\"\].*${1}=\(.*\)|\1|p"
	EES=$(sed -n "${PAT}" "${CONF}" | head -1)

	if [ -z "${EES}" ]; then
		PAT="s|^${PLATFORM}[\.-]${1}=\(.*\)|\1|p"
		EES=$(sed -n "${PAT}" "${CONF}" | head -1)
	fi

	if [ -z "${EES}" ]; then
		PAT="s|^global[\.-].*${1}=\(.*\)|\1|p"
		EES=$(sed -n "${PAT}" "${CONF}" | head -1)
	fi

	[ -z "${EES}" ] && EES="false"
}

if [[ ! -f "$GAMEDATA/custominput.ini" ]]; then
	mkdir -p $GAMEDATA
	cp $SHARE/default.ini $GAMEDATA/custominput.ini
fi

if [[ ! -f "$M64PCONF" ]]; then
	mkdir -p /storage/.config/mupen64plussa
	cp $SHARE/mupen64plus.cfg $M64PCONF
fi

cp $M64PCONF $TMP

RESOLUTION=$(batocera-resolution "currentResolution")
echo ${RESOLUTION}
RESA=${RESOLUTION%x*}
RESB=${RESOLUTION#*x}
SCREENWIDTH=$((RESA>=RESB ? RESA : RESB))
echo ${SCREENWIDTH}
SCREENHEIGHT=$((RESA<RESB ? RESA : RESB))
echo ${SCREENHEIGHT}

SET_PARAMS="--set Core[SharedDataPath]=$TMP --set Video-Rice[ResolutionWidth]=$SCREENWIDTH"

# Game Aspect Ratio
# Get configuration from distribution.conf
get_setting "game_aspect_ratio"
echo ${EES}
if [ "${EES}" == "fullscreen" ]; then
	# TODO: Set aspect ratio to fullscreen
	SET_PARAMS="$SET_PARAMS --set Video-General[ScreenWidth]=$SCREENWIDTH --set Video-General[ScreenHeight]=$SCREENHEIGHT --set Video-Glide64mk2[aspect]=2"
else
	# TODO: Set aspect ratio to 4:3
	GAMEWIDTH=$(((SCREENHEIGHT * 4) / 3))
	SET_PARAMS="$SET_PARAMS --set Video-General[ScreenWidth]=$GAMEWIDTH --set Video-General[ScreenHeight]=$SCREENHEIGHT"
fi

# Game Aspect Ratio
# Get configuration from distribution.conf
get_setting "input_configuration"
echo ${EES}
if [ "${EES}" == "rstickc" ]; then
	cat $INPUTCFGBASE <(echo) $SHARE/rstickc.ini > $TMP/InputAutoCfg.ini
elif [ "${EES}" == "custom" ]; then
	cat $INPUTCFGBASE <(echo) $GAMEDATA/custominput.ini > $TMP/InputAutoCfg.ini
else
	# Default
	cat $INPUTCFGBASE <(echo) $SHARE/default.ini > $TMP/InputAutoCfg.ini
fi

# Show FPS
# Get configuration from distribution.conf
get_setting "show_fps"
echo ${EES}
if [ "${EES}" == "auto" ] || [ "${EES}" == "disabled" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	SET_PARAMS="$SET_PARAMS --set Video-Glide64mk2[show_fps]=0 --set Video-Rice[ShowFPS]=\"False\""
else
	SET_PARAMS="$SET_PARAMS --set Video-Glide64mk2[show_fps]=1 --set Video-Rice[ShowFPS]=\"True\""
fi

echo ${SET_PARAMS}

case $1 in
	"m64p_gl64mk2")
		/usr/local/bin/mupen64plus --configdir $TMP --gfx mupen64plus-video-glide64mk2 $SET_PARAMS "$2"
	;;
	"m64p_rice")
		/usr/local/bin/mupen64plus --configdir $TMP --gfx mupen64plus-video-rice $SET_PARAMS "$2"
	;;
	*)
		/usr/local/bin/mupen64plus --configdir $TMP --gfx mupen64plus-video-rice $SET_PARAMS "$2"
	;;
esac

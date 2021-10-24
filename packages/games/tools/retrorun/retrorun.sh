#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present 351ELEC (https://github.com/351ELEC)

. /etc/profile

echo 'starting retrorun emulator...'

CORE="$1"
ROM="$2"
PLATFORM="$3"
CONF="/storage/.config/distribution/configs/retrorun.cfg"

if [ ! -f ${CONF} ]; then
  cp -f /usr/config/distribution/configs/retrorun.cfg /storage/.config/distribution/configs/
fi

function get_setting() {
	log "Get Settings function (${1})"
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

# Auto Save
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "auto_save"
if [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_auto_save/d" ${CONF}
	echo 'retrorun_auto_save = false' >> ${CONF}
else
	sed -i "/^retrorun_auto_save/d" ${CONF}
	echo 'retrorun_auto_save = ${EES}' >> ${CONF}
fi

# Game Aspect Ratio
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "game_aspect_ratio"
if [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_auto_save/d" ${CONF}
	echo 'retrorun_aspect_ratio = auto' >> ${CONF}
else
	sed -i "/^retrorun_auto_save/d" ${CONF}
	echo 'retrorun_aspect_ratio = ${EES}' >> ${CONF}
fi

# Internal Resolution
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "internal_resolution"
if [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [ "${CORE}" == "parallel_n64" ]; then
		sed -i "/^parallel-n64-screensize/d" ${CONF}
		echo 'parallel-n64-screensize = 640x480' >> ${CONF}
	elif [ "${CORE}" == "parallel_n64_gln64" ]; then
		sed -i "/^parallel-n64_gln64-screensize/d" ${CONF}
		echo 'parallel-n64_gln64-screensize = 640x480' >> ${CONF}
	elif [ "${CORE}" == "flycast" ]; then
		sed -i "/^flycast_internal_resolution/d" ${CONF}
		echo 'flycast_internal_resolution = 640x480' >> ${CONF}
	fi
else
	if [ "${CORE}" == "parallel_n64" ]; then
		sed -i "/^parallel-n64-screensize/d" ${CONF}
		echo 'parallel-n64-screensize = ${EES}' >> ${CONF}
	elif [ "${CORE}" == "parallel_n64_gln64" ]; then
		sed -i "/^parallel-n64_gln64-screensize/d" ${CONF}
		echo 'parallel-n64_gln64-screensize = ${EES}' >> ${CONF}
	elif [ "${CORE}" == "flycast" ]; then
		sed -i "/^flycast_internal_resolution/d" ${CONF}
		echo 'flycast_internal_resolution = ${EES}' >> ${CONF}
	fi
fi

# Threaded Rendering
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "threaded_rendering"
if [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [ "${CORE}" == "flycast" ]; then
		sed -i "/^flycast_threaded_rendering/d" ${CONF}
		echo 'flycast_threaded_rendering = enabled' >> ${CONF}
	fi
else
	if [ "${CORE}" == "flycast" ]; then
		sed -i "/^flycast_threaded_rendering/d" ${CONF}
		echo 'flycast_threaded_rendering = ${EES}' >> ${CONF}
	fi
fi



rm /dev/input/by-path/platform-odroidgo2-joypad-event-joystick || true
echo 'creating fake joypad'
/usr/bin/rg351p-js2xbox --silent -t oga_joypad &
sleep 0.2
echo 'confguring inputs'
EE_DEVICE=$(cat /storage/.config/.OS_ARCH)
echo 'confguring inputs on device:'$EE_DEVICE
if [[ "$EE_DEVICE" == "RG351V" ]] || [[ "$EE_DEVICE" == "RG351MP" ]]
then
	ln -s /dev/input/event4 /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
else
	ln -s /dev/input/event3 /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
fi
chmod 777 /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
echo 'using core:' "$1"
echo 'platform:' "$3"
echo 'starting game:' "$2"

FPS=''
if [[ "$4" == "show_fps" ]] || [[ "$4" == "SHOW_FPS" ]]
then
    echo 'enabling FPS in the logs'
    FPS="-f"
fi
GPIO_JOYPAD=''
if [[ "$EE_DEVICE" == "RG351MP" ]]
then
    echo 'GPIO joypad'
    GPIO_JOYPAD="-g"
fi

sleep 0.2
if [[ "$1" =~ "pcsx_rearmed" ]] || [[ "$1" =~ "parallel_n64" ]]
then
    echo 'using 32bit'
  	export LD_LIBRARY_PATH="/usr/lib32"
	/usr/bin/retrorun32 --triggers $FPS $GPIO_JOYPAD -n -s /storage/roms/"$3"  -d /roms/bios "$1" "$2"
else
	echo 'using 64bit'
	/usr/bin/retrorun --triggers $FPS $GPIO_JOYPAD -n -s /storage/roms/"$3" -d /roms/bios "$1" "$2"
fi
sleep 0.5
rm /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
kill $(pidof rg351p-js2xbox)
echo 'end!'
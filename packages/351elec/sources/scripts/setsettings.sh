#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

# TODO: Set Atari800 to Atari5200 when neeeded / done?
# TODO: retroachivements / done?
# I use ${} for easier reading

# IMPORTANT: This script should not return (echo) anything other than the shader if its set

. /etc/profile

RETROARCHIVEMENTS=(arcade atari2600 atari7800 atarilynx colecovision famicom fbn fds gamegear gb gba gbah gbc gbch gbh genesis genh ggh intellivision mastersystem megacd megadrive megadrive-japan msx msx2 n64 neogeo neogeocd nes nesh ngp ngpc odyssey2 pcengine pcenginecd pcfx pokemini psx sega32x segacd sfc sg-1000 snes snesh snesmsu1 supergrafx supervision tg16 tg16cd vectrex virtualboy wonderswan wonderswancolor)
NOREWIND=(sega32x psx zxspectrum odyssey2 mame n64 dreamcast atomiswave naomi neogeocd saturn psp pspminis)
NORUNAHEAD=(psp sega32x n64 dreamcast atomiswave naomi neogeocd saturn)
# The following systems are listed as they don't need the Analogue D-Pad mode on RA
NOANALOGUE=(n64 psx wonderswan wonderswancolor psp pspminis)

INDEXRATIOS=(4/3 16/9 16/10 16/15 21/9 1/1 2/1 3/2 3/4 4/1 9/16 5/4 6/5 7/9 8/3 8/7 19/12 19/14 30/17 32/9 config squarepixel core custom)
CONF="/storage/.config/distribution/configs/distribution.conf"
SOURCERACONF="/usr/config/retroarch/retroarch.cfg"
RACONF="/storage/.config/retroarch/retroarch.cfg"
RAAPPENDCONF="/tmp/raappend.cfg"
RACORECONF="/storage/.config/retroarch/retroarch-core-options.cfg"
SNAPSHOTS="/storage/roms/savestates"
PLATFORM=${1,,}
ROM="${2##*/}"
CORE=${3,,}
SHADERSET=0
LOGSDIR="/tmp/logs"
LOGFILE="exec.log"
EE_DEVICE=$(cat /storage/.config/.OS_ARCH)

#Snapshot
SNAPSHOT="$@"
SNAPSHOT="${SNAPSHOT#*--snapshot=*}"

### Enable logging
if [ "$(get_es_setting string LogLevel)" == "minimal" ]; then
	LOG=false
else
	LOG=true
	VERBOSE=true
fi

function log() {
	if [ ${LOG} == true ]; then
		if [[ ! -d "$LOGSDIR" ]]; then
			mkdir -p "$LOGSDIR"
		fi
		DATE=$(date +"%b %d %H:%M:%S")
		echo "${DATE} ${MYNAME}: $1" 2>&1 >> ${LOGSDIR}/${LOGFILE}
	fi
}

## Create / delete raappend.cfg
echo -n > "${RAAPPENDCONF}"

### Move operations to /tmp so we're not writing to the microSD slowing us down.
### Also test the file to ensure it's not 0 bytes which can happen if someone presses reset.
if [ ! -s ${RACONF} ]; then
	log "Fix broken RA conf"
	cp -f "${SOURCERACONF}" "${RACONF}"
fi

if [ ! -d "${SNAPSHOTS}/${PLATFORM}" ]; then
	mkdir -p "${SNAPSHOTS}/${PLATFORM}"
fi

function doexit() {
	log "Exiting.."
	sync
	exit 0
}

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

##
## Global Setting that have to stay in retroarch.cfg
## All setttings that should applay when retroarch is as standalone
##

## Wifi
# Cleanup old settings first
sed -i "/wifi_enabled/d" ${RACONF}
# Get configuration from distribution.conf and set to retroarch.cfg
if [ "$(get_ee_setting wifi.enabled)" = "1" ]; then
	echo 'wifi_enabled = "true"' >> ${RACONF}
else
	echo 'wifi_enabled = "false"' >> ${RACONF}
fi

# RA menu rgui, ozone, glui or xmb (fallback if everthing else fails)
# if empty (auto in ES) do nothing to enable configuration in RA
get_setting "retroarch.menu_driver"
if [ "${EES}" != "false" ]; then
	# delete setting only if we set new ones
	# therefore configuring in RA is still possible
	sed -i "/menu_driver/d" ${RACONF}
	sed -i "/menu_linear_filter/d" ${RACONF}
	# Set new menu driver
	if [ "${EES}" == "rgui" ]; then
		# menu_liner_filter is only needed for rgui
		echo 'menu_driver = "rgui"' >> ${RACONF}
		echo 'menu_linear_filter = "true"' >> ${RACONF}
	elif [ "${EES}" == "ozone" ]; then
		echo 'menu_driver = "ozone"' >> ${RACONF}
	elif [ "${EES}" == "glui" ]; then
		echo 'menu_driver = "glui"' >> ${RACONF}
	else
		# play it save and set xmb if nothing else matches
		echo 'menu_driver = "xmb"' >> ${RACONF}
	fi
fi


##
## Global Settings that go into the temorary config file
##

## FPS
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "showFPS"
[ "${EES}" == "1" ] && echo 'fps_show = "true"' >> ${RAAPPENDCONF} || echo 'fps_show = "false"' >> ${RAAPPENDCONF}


## RetroAchievements / Cheevos
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "retroachievements"
for i in "${!RETROARCHIVEMENTS[@]}"; do
	if [[ "${RETROARCHIVEMENTS[$i]}" = "${PLATFORM}" ]]; then
		if [ "${EES}" == "1" ]; then
		echo 'cheevos_enable = "true"' >> ${RAAPPENDCONF}
		get_setting "retroachievements.username"
		echo "cheevos_username = \"${EES}\"" >> ${RAAPPENDCONF}
		get_setting "retroachievements.password"
		echo "cheevos_password = \"${EES}\"" >> ${RAAPPENDCONF}

		# retroachievements_hardcore_mode
		get_setting "retroachievements.hardcore"
		[ "${EES}" == "1" ] && echo 'cheevos_hardcore_mode_enable = "true"' >> ${RAAPPENDCONF} || echo 'cheevos_hardcore_mode_enable = "false"' >> ${RAAPPENDCONF}

		# retroachievements_leaderboards
		get_setting "retroachievements.leaderboards"
		if [ "${EES}" == "enabled" ]; then
			echo 'cheevos_leaderboards_enable = "true"' >> ${RAAPPENDCONF}
		elif [ "${EES}" == "trackers only" ]; then
			echo 'cheevos_leaderboards_enable = "trackers"' >> ${RAAPPENDCONF}
		elif [ "${EES}" == "notifications only" ]; then
			echo 'cheevos_leaderboards_enable = "notifications"' >> ${RAAPPENDCONF}
		else
			echo 'cheevos_leaderboards_enable = "false"' >> ${RAAPPENDCONF}
		fi

		# retroachievements_verbose_mode
		get_setting "retroachievements.verbose"
		[ "${EES}" == "1" ] && echo 'cheevos_verbose_enable = "true"' >> ${RAAPPENDCONF} || echo 'cheevos_verbose_enable = "false"' >> ${RAAPPENDCONF}

		# retroachievements_automatic_screenshot
		get_setting "retroachievements.screenshot"
		[ "${EES}" == "1" ] && echo 'cheevos_auto_screenshot = "true"' >> ${RAAPPENDCONF} || echo 'cheevos_auto_screenshot = "false"' >> ${RAAPPENDCONF}
		else
		echo 'cheevos_enable = "false"' >> ${RAAPPENDCONF}
		echo 'cheevos_username = ""' >> ${RAAPPENDCONF}
		echo 'cheevos_password = ""' >> ${RAAPPENDCONF}
		echo 'cheevos_hardcore_mode_enable = "false"' >> ${RAAPPENDCONF}
		echo 'cheevos_leaderboards_enable = "false"' >> ${RAAPPENDCONF}
		echo 'cheevos_verbose_enable = "false"' >> ${RAAPPENDCONF}
		echo 'cheevos_auto_screenshot = "false"' >> ${RAAPPENDCONF}
		fi
	fi
done

## Netplay
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "netplay"
if [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	echo 'netplay = false' >> ${RAAPPENDCONF}
else
	echo 'netplay = true' >> ${RAAPPENDCONF}
	get_setting "netplay.mode"
	NETPLAY_MODE=${EES}
	# Security : hardcore mode disables save states, which would kill netplay
	sed -i '/cheevos_hardcore_mode_enable =/d' ${RAAPPENDCONF}
	echo 'cheevos_hardcore_mode_enable = "false"' >> ${RAAPPENDCONF}

	if [[ "${NETPLAY_MODE}" == "host" ]]; then
		# Quite strangely, host mode requires netplay_mode to be set to false when launched from command line
		echo 'netplay_mode = false' >> ${RAAPPENDCONF}
		echo 'netplay_client_swap_input = false' >> ${RAAPPENDCONF}
		get_setting "netplay.port"
		echo "netplay_ip_port = ${EES}" >> ${RAAPPENDCONF}
	elif [[ "${NETPLAY_MODE}" == "client" ]]; then
		# But client needs netplay_mode = true ... bug ?
		echo 'netplay_mode = true' >> ${RAAPPENDCONF}
		get_setting "netplay.client.ip"
		echo "netplay_ip_address = ${EES}" >> ${RAAPPENDCONF}
		get_setting "netplay.client.port"
		echo "netplay_ip_port = ${EES}" >> ${RAAPPENDCONF}
		echo 'netplay_client_swap_input = true' >> ${RAAPPENDCONF}
	fi # Host or Client

	# relay
	get_setting "netplay.relay"
	if [[ ! -z "${EES}" && "${EES}" != "none" ]]; then
		echo 'netplay_use_mitm_server = true' >> ${RAAPPENDCONF}
		echo "netplay_mitm_server = ${EES}" >> ${RAAPPENDCONF}
	else
		echo 'netplay_use_mitm_server = false' >> ${RAAPPENDCONF}
		# sed -i "/netplay_mitm_server/d" ${RACONF}
	fi

	get_setting "netplay.frames"
	echo "netplay_delay_frames = ${EES}" >> ${RAAPPENDCONF}
	get_setting "netplay.nickname"
	echo "netplay_nickname = ${EES}" >> ${RAAPPENDCONF}
	# spectator mode
	get_setting "netplay.spectator"
	[ "${EES}" == "1" ] && echo 'netplay_spectator_mode_enable = true' >> ${RAAPPENDCONF} || echo 'netplay_spectator_mode_enable = false' >> ${RAAPPENDCONF}
fi

## AI Translation Service
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "ai_service_enabled"
if [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	echo 'ai_service_enable = "false"' >> ${RAAPPENDCONF}
else
	echo 'ai_service_enable = "true"' >> ${RAAPPENDCONF}
	get_setting "ai_target_lang"
	AI_LANG=${EES}
	[[ "$AI_LANG" == "false" ]] && AI_LANG="0"
	get_setting "ai_service_url"
	AI_URL=${EES}
	echo "ai_service_source_lang = \"${AI_LANG}\"" >> ${RAAPPENDCONF}
	if [ "${AI_URL}" == "false" ] || [ "${AI_URL}" == "auto" ] || [ "${AI_URL}" == "none" ]; then
		echo "ai_service_url = \"http://ztranslate.net/service?api_key=BATOCERA&mode=Fast&output=png&target_lang=\"${AI_LANG}\"" >> ${RAAPPENDCONF}
	else
		echo "ai_service_url = \"${AI_URL}&mode=Fast&output=png&target_lang=\"${AI_LANG}\"" >> ${RAAPPENDCONF}
	fi
fi

##
## Global/System/Game specific settings
##

## Ratio
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "ratio"
if [[ "${EES}" == "false" ]]; then
	# 22 is the "Core Provided" aspect ratio and its set by default if no other is selected
	echo 'aspect_ratio_index = "22"' >> ${RAAPPENDCONF}
else
for i in "${!INDEXRATIOS[@]}"; do
	if [[ "${INDEXRATIOS[$i]}" = "${EES}" ]]; then
		break
	fi
done
	echo "aspect_ratio_index = \"${i}\"" >> ${RAAPPENDCONF}
fi

## Video Smooth
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "smooth"
[ "${EES}" == "1" ] && echo 'video_smooth = "true"' >> ${RAAPPENDCONF} || echo 'video_smooth = "false"' >> ${RAAPPENDCONF}

## Video Integer Scale
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "integerscale"
[ "${EES}" == "1" ] && echo 'video_scale_integer = "true"' >> ${RAAPPENDCONF} || echo 'video_scale_integer = "false"' >> ${RAAPPENDCONF}

## RGA Scaling / CTX Scaling
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting	"rgascale"
[ "${EES}" == "1" ] && echo 'video_ctx_scaling = "true"' >> ${RAAPPENDCONF} || echo 'video_ctx_scaling = "false"' >> ${RAAPPENDCONF}

## Shaderset
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "shaderset"
if [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	echo 'video_shader_enable = "false"' >> ${RAAPPENDCONF}
	echo 'video_shader = ""' >> ${RAAPPENDCONF}
else
	echo "video_shader = \"${EES}\"" >> ${RAAPPENDCONF}
	echo 'video_shader_enable = "true"' >> ${RAAPPENDCONF}
	echo "--set-shader /tmp/shaders/${EES}"
fi

## Rewind
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "rewind"
(for e in "${NORUNAHEAD[@]}"; do [[ "${e}" == "${PLATFORM}" ]] && exit 0; done) && RA=0 || RA=1
if [ $RA == 1 ] && [ "${EES}" == "1" ]; then
	echo 'rewind_enable = "true"' >> ${RAAPPENDCONF}
else
	echo 'rewind_enable = "false"' >> ${RAAPPENDCONF}
fi

## Autosave
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "autosave"
if [ "${EES}" == false ] || [ "${EES}" == "1" ]; then
	echo 'savestate_auto_save = "true"' >> ${RAAPPENDCONF}
	echo 'savestate_auto_load = "true"' >> ${RAAPPENDCONF}
	AUTOLOAD=true
else
	echo 'savestate_auto_save = "false"' >> ${RAAPPENDCONF}
	echo 'savestate_auto_load = "false"' >> ${RAAPPENDCONF}
	AUTOLOAD=false
fi

## Snapshots
echo 'savestate_directory = "'"${SNAPSHOTS}/${PLATFORM}"'"' >> ${RAAPPENDCONF}
if [ ! -z ${SNAPSHOT} ]
then
	if [ ${AUTOLOAD} == true ]
	then
		sed -i "/savestate_auto_load =/d" ${RAAPPENDCONF}
		sed -i "/savestate_auto_save =/d" ${RAAPPENDCONF}
		echo 'savestate_auto_save = "true"' >> ${RAAPPENDCONF}
		echo 'savestate_auto_load = "true"' >> ${RAAPPENDCONF}
		echo "state_slot = \"${SNAPSHOT}\"" >> ${RAAPPENDCONF}
	else
		sed -i "/savestate_auto_load =/d" ${RAAPPENDCONF}
		sed -i "/savestate_auto_save =/d" ${RAAPPENDCONF}
		echo 'savestate_auto_save = "false"' >> ${RAAPPENDCONF}
		echo 'savestate_auto_load = "false"' >> ${RAAPPENDCONF}
		echo 'state_slot = "0"' >> ${RAAPPENDCONF}
	fi
fi

## Runahead
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "runahead"
(for e in "${NORUNAHEAD[@]}"; do [[ "${e}" == "${PLATFORM}" ]] && exit 0; done) && RA=0 || RA=1
if [ $RA == 1 ]; then
	if [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
		echo 'run_ahead_enabled = "false"' >> ${RAAPPENDCONF}
		echo 'run_ahead_frames = "1"' >> ${RAAPPENDCONF}
	else
		echo 'run_ahead_enabled = "true"' >> ${RAAPPENDCONF}
		echo "run_ahead_frames = \"${EES}\"" >> ${RAAPPENDCONF}
	fi
fi

## Secondinstance
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "secondinstance"
(for e in "${NORUNAHEAD[@]}"; do [[ "${e}" == "${PLATFORM}" ]] && exit 0; done) && RA=0 || RA=1
if [ $RA == 1 ]; then
	[ "${EES}" == "1" ] && echo 'run_ahead_secondary_instance = "true"' >> ${RAAPPENDCONF} || echo 'run_ahead_secondary_instance = "false"' >> ${RAAPPENDCONF}
fi


## D-Pad to Analogue support, option in ES is missng atm but is managed as global.analogue=1 in distribution.conf (that is made by postupdate.sh)
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "analogue"
(for e in "${NOANALOGUE[@]}"; do [[ "${e}" == "${PLATFORM}" ]] && exit 0; done) && RA=1 || RA=0
if [ $RA == 1 ] || [ "${EES}" == "false" ] || [ "${EES}" == "0" ]; then
        echo 'input_player1_analog_dpad_mode = "0"' >> ${RAAPPENDCONF}
else
        echo 'input_player1_analog_dpad_mode = "1"' >> ${RAAPPENDCONF}
fi

##
## Settings for special cores
##

## atari800 core needs other settings when emulation atari5200
if [ "${CORE}" == "atari800" ]; then
	log "Atari 800 section"
	ATARICONF="/storage/.config/distribution/configs/atari800.cfg"
	ATARI800CONF="/storage/.config/retroarch/config/Atari800/Atari800.opt"
	[[ ! -f "$ATARI800CONF" ]] && touch "$ATARI800CONF"

	sed -i "/atari800_system =/d" ${RACORECONF}
	sed -i "/RAM_SIZE=/d" ${ATARICONF}
	sed -i "/STEREO_POKEY=/d" ${ATARICONF}
	sed -i "/BUILTIN_BASIC=/d" ${ATARICONF}
	sed -i "/atari800_system =/d" ${ATARI800CONF}

	if [ "${PLATFORM}" == "atari5200" ]; then
		echo "atari800_system = \"5200\"" >> ${RACORECONF}
		echo "atari800_system = \"5200\"" >> ${ATARI800CONF}
		echo "RAM_SIZE=16" >> ${ATARICONF}
		echo "STEREO_POKEY=0" >> ${ATARICONF}
		echo "BUILTIN_BASIC=0" >> ${ATARICONF}
	else
		echo "atari800_system = \"800XL (64K)\"" >> ${RACORECONF}
		echo "atari800_system = \"800XL (64K)\"" >> ${ATARI800CONF}
		echo "RAM_SIZE=64" >> ${ATARICONF}
		echo "STEREO_POKEY=1" >> ${ATARICONF}
		echo "BUILTIN_BASIC=1" >> ${ATARICONF}
 	fi
fi

## Gambatte
if [ "${CORE}" == "gambatte" ]; then
	log "Gambatte section"
	GAMBATTECONF="/storage/.config/retroarch/config/Gambatte/Gambatte.opt"
	[[ ! -f "$GAMBATTECONF" ]] && touch "$GAMBATTECONF"

	sed -i "/gambatte_gb_colorization =/d" ${RACORECONF}
	sed -i "/gambatte_gb_internal_palette =/d" ${RACORECONF}
	sed -i "/gambatte_gb_colorization =/d" ${GAMBATTECONF}
	sed -i "/gambatte_gb_internal_palette =/d" ${GAMBATTECONF}

	get_setting "renderer.colorization"
	if [ "${EES}" == "false" ] || [ "${EES}" == "auto" ] || [ "${EES}" == "none" ]; then
		echo "gambatte_gb_colorization = \"disabled\"" >> ${RACORECONF}
		echo "gambatte_gb_internal_palette = \"\"" >> ${RACORECONF}
		echo "gambatte_gb_colorization = \"disabled\"" >> ${GAMBATTECONF}
		echo "gambatte_gb_internal_palette = \"\"" >> ${GAMBATTECONF}
	elif [ "${EES}" == "Best Guess" ]; then
		echo "gambatte_gb_colorization = \"auto\"" >> ${RACORECONF}
		echo "gambatte_gb_internal_palette = \"\"" >> ${RACORECONF}
		echo "gambatte_gb_colorization = \"auto\"" >> ${GAMBATTECONF}
		echo "gambatte_gb_internal_palette = \"\"" >> ${GAMBATTECONF}
	else
		echo "gambatte_gb_colorization = \"internal\"" >> ${RACORECONF}
		echo "gambatte_gb_internal_palette = \"${EES}\"" >> ${RACORECONF}
		echo "gambatte_gb_colorization = \"internal\"" >> ${GAMBATTECONF}
		echo "gambatte_gb_internal_palette = \"${EES}\"" >> ${GAMBATTECONF}
	fi
fi

# We set up the controller index
#sed -i "/input_libretro_device_p1/d" ${RACONF}
CONTROLLERS="$@"
CONTROLLERS="${CONTROLLERS#*--controllers=*}"

for i in 1 2 3 4 5; do
log "Controller section (${1})"
if [[ "$CONTROLLERS" == *p${i}* ]]; then
PINDEX="${CONTROLLERS#*-p${i}index }"
PINDEX="${PINDEX%% -p${i}guid*}"
#sed -i "/input_player${i}_joypad_index =/d" ${RACONF}
echo "input_player${i}_joypad_index = \"${PINDEX}\"" >> ${RAAPPENDCONF}

# Setting controller type for different cores
if [ "${PLATFORM}" == "atari5200" ]; then
	sed -i "/input_libretro_device_p${i}/d" ${RAAPPENDCONF}
	echo "input_libretro_device_p${i} = \"513\"" >> ${RAAPPENDCONF}
fi

fi
done

##
## Bezels / Decorations
##

# List of possible Bezel Folders
BEZELDIR=(/tmp/overlays/bezels /storage/roms/bezels)
# Define the resolutions of the differen systems (0:x 1:y 2:width 3:height) as seen in Scaling -> Aspect Ration -> Custom
# RG351P/M=480x320
# RG351V=640x480
if [ "${EE_DEVICE}" == "RG351P" ]; then
	declare -A SystemViewport=(
		['gb']="80 16 320 288"
		['gbc']="80 16 320 288"
		['supervision']="80 0 320 320"
		['gamegear']="80 16 320 288"
		['pokemini']="96 64 288 192"
	)
else #Must be the V then
	declare -A SystemViewport=(
		['gb']="80 24 480 432"
		['gbc']="80 24 480 432"
		['supervision']="80 0 480 480"
		['gamegear']="80 24 480 432"
		['pokemini']="128 112 384 256"
	)
fi
# Get configuration from distribution.conf and set to retroarch.cfg
get_setting "bezel"
if [ "${EES}" != "false" ] && [ "${EES}" != "none" ] && [ "${EES}" != "0" ] && [ ${SystemViewport[${PLATFORM}]+_} ]; then
	# set path
	for p in ${BEZELDIR[@]}; do
		if [ -d "${p}"/"${EES}" ]; then
			path="${p}"/"${EES}"
		fi
	done
	# if there a $ROM.cfg?
	# excatctly the same?
	if [ -f "${path}"/"${ROM%.*}".cfg ]; then
		bezelcfg="${path}"/"${ROM%.*}".cfg
	# only the name without ()
	elif [ -f "${path}"/"${ROM%% (*}".cfg ]; then
		bezelcfg="${path}"/"${ROM%% (*}".cfg
	elif [ -f "${path}"/default.cfg ]; then
		bezelcfg="${path}"/default.cfg
	fi
	# configure bezel
	echo 'input_overlay_enable = "true"'		>> ${RAAPPENDCONF}
	echo "input_overlay = \"${bezelcfg}\""		>> ${RAAPPENDCONF}
	echo 'input_overlay_hide_in_menu = "true"'	>> ${RAAPPENDCONF}
	echo 'input_overlay_opacity = "1.000000"'	>> ${RAAPPENDCONF}
	echo 'input_overlay_show_inputs = "2"'		>> ${RAAPPENDCONF}
	# delete / set scaling and aspect ratio:
	sed -i "/video_scale_integer/d" ${RAAPPENDCONF}
	sed -i "/aspect_ratio_index/d" ${RAAPPENDCONF}
	echo 'video_scale_integer = "false"'	>> ${RAAPPENDCONF}
	echo 'aspect_ratio_index = "23"'		>> ${RAAPPENDCONF}
	# configure custom scaling
	# needs some grouping to reflect the hack systems as well (i. e. gb=gb, gbh, gbc and gbch)
	declare -a resolution=(${SystemViewport[${PLATFORM}]})
	echo "custom_viewport_x = \"${resolution[0]}\""			>> ${RAAPPENDCONF}
	echo "custom_viewport_y = \"${resolution[1]}\""			>> ${RAAPPENDCONF}
	echo "custom_viewport_width = \"${resolution[2]}\""		>> ${RAAPPENDCONF}
	echo "custom_viewport_height = \"${resolution[3]}\""	>> ${RAAPPENDCONF}
else
	# disable decorations
	echo 'input_overlay_enable = "false"'		>> ${RAAPPENDCONF}
fi

##
## Clean Exit
##
doexit

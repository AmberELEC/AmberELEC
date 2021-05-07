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

INDEXRATIOS=(4/3 16/9 16/10 16/15 21/9 1/1 2/1 3/2 3/4 4/1 9/16 5/4 6/5 7/9 8/3 8/7 19/12 19/14 30/17 32/9 config squarepixel core custom)
CONF="/storage/.config/distribution/configs/distribution.conf"
SOURCERACONF="/usr/config/retroarch/retroarch.cfg"
RACONF="/storage/.config/retroarch/retroarch.cfg"
RACORECONF="/storage/.config/retroarch/retroarch-core-options.cfg"
SNAPSHOTS="/storage/roms/savestates"
PLATFORM=${1,,}
CORE=${3,,}
ROM="${2##*/}"
SETF=0
SHADERSET=0
LOGSDIR="/tmp/logs"
LOGFILE="exec.log"

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
        if [ ${LOG} == true ]
        then
                if [[ ! -d "$LOGSDIR" ]]
                then
                        mkdir -p "$LOGSDIR"
                fi
		DATE=$(date +"%b %d %H:%M:%S")
		echo "${DATE} ${MYNAME}: $1" 2>&1 >> ${LOGSDIR}/${LOGFILE}
        fi
}

### Move operations to /tmp so we're not writing to the microSD slowing us down.
### Also test the file to ensure it's not 0 bytes which can happen if someone presses reset.
FILELENGTH="$(cat ${RACONF} | wc -l)"
if [ "${FILELENGTH}" -lt "1" ]
then
  log "Fix broken RA conf"
  cp -f "${SOURCERACONF}" "${RACONF}"
fi

if [ ! -d "${SNAPSHOTS}/${PLATFORM}" ]
then
  mkdir -p "${SNAPSHOTS}/${PLATFORM}"
fi

function doexit() {
  log "Exiting.."
  sync
  exit 0
}

## group_platform is not used as it would group the RA savestate_directory-setting as well
## add all the platforms directly to RETROARCHIVEMENTS 
##
#function group_platform() {
#log "group platform function (${1})"
#case ${1} in 
#	"atari2600")
#	PLATFORM="atari2600"
#	;;
#	"atari7800")
#	PLATFORM="atari7800"
#	;;
#	"atarilynx")
#	PLATFORM="atarilynx"
#	;;
#	"wonderswan"|"wonderswancolor")
#	PLATFORM="wonderswan"
#	;;
#	"colecovision")
#	PLATFORM="colecovision"
#	;;
#	"vectrex")
#	PLATFORM="vectrex"
#	;;
#	"msx"|"msx2")
#	PLATFORM="msx"
#	;;
#	"pcengine"|"pcenginecd"|"pcfx"|"supergrafx"|"tg16"|"tg16cd")
#	PLATFORM="pcengine"
#	;;
#	"gb"|"gbh")
#	PLATFORM="gb"
#	;;
#	"gba"|"gbah")
#	PLATFORM="gba"
#	;;
#	"gbc"|"gbch")
#	PLATFORM="gb"
#	;;
#	"nes"|"nesh"|"fds"|"famicom")
#	PLATFORM="nes"
#	;;
#	"n64")
#	PLATFORM="n64"
#	;;
#	"pokemini")
#	PLATFORM="pokemini"
#	;;
#	"snes"|"snesh"|"snesmsu1"|"sfc")
#	PLATFORM="snes"
#	;;
#	"virtualboy")
#	PLATFORM="virtualboy"
#	;;
#	"mastersystem")
#	PLATFORM="mastersystem"
#	;;	
#	"genesis genh"|"megadrive"|"megadrive-japan")
#	PLATFORM="megadrive"
#	;;
#	"sega32x")
#	PLATFORM="sega32x"
#	;;
#	"gamegear"|"ggh")
#	PLATFORM="gamegear"
#	;;
#	"sg-1000")
#	PLATFORM="sg-1000"
#	;;
#	"segacd"|"megacd")
#	PLATFORM="segacd"
#	;;
#	"neogeo"|"neogeocd")
#	PLATFORM="neogeo"
#	;;
#	"ngp"|"ngpc")
#	PLATFORM="ngp"
#	;;
#	"psx")
#	PLATFORM="psx"
#	;;
#	"tic80")
#	PLATFORM="tic80"
#	;;
#	"fbn")
#	PLATFORM="arcade"
#	;;
#       "intellivision")
#	PLATFORM="intellivision"
#	;;
#esac
#
#	}
#
#group_platform 

function clean_settings() {
log "Clean settings function"
# IMPORTANT: Every setting we change should be removed from retroarch.cfg before we do any changes.
	sed -i '/video_scale_integer =/d' ${RACONF}
        sed -i '/video_ctx_scaling =/d' ${RACONF}
	sed -i '/video_shader =/d' ${RACONF}
	sed -i '/video_shader_enable =/d' ${RACONF}
	sed -i '/video_smooth =/d' ${RACONF}
	sed -i '/aspect_ratio_index =/d' ${RACONF}
	sed -i '/rewind_enable =/d' ${RACONF}
	sed -i '/run_ahead_enabled =/d' ${RACONF}
	sed -i '/run_ahead_frames =/d' ${RACONF}
	sed -i '/run_ahead_secondary_instance =/d' ${RACONF}
	sed -i "/state_slot =/d" ${RACONF}
	sed -i '/savestate_auto_save =/d' ${RACONF}
	sed -i '/savestate_auto_load =/d' ${RACONF}
	sed -i '/savestates_in_content_dir =/d' ${RACONF}
	sed -i '/savestate_directory =/d' ${RACONF}
	sed -i '/cheevos_enable =/d' ${RACONF}
	sed -i '/cheevos_username =/d' ${RACONF}
	sed -i '/cheevos_password =/d' ${RACONF}
	sed -i '/cheevos_hardcore_mode_enable =/d' ${RACONF}
	sed -i '/cheevos_leaderboards_enable =/d' ${RACONF}
	sed -i '/cheevos_verbose_enable =/d' ${RACONF}
	sed -i '/cheevos_auto_screenshot =/d' ${RACONF}
	sed -i '/ai_service_mode =/d' ${RACONF}
	sed -i '/ai_service_enable =/d' ${RACONF}
	sed -i '/ai_service_source_lang =/d' ${RACONF}
	sed -i '/ai_service_url =/d' ${RACONF}
	sed -i "/input_libretro_device_p1/d" ${RACONF}
	sed -i "/fps_show/d" ${RACONF}
	sed -i "/netplay =/d" ${RACONF}
	sed -i "/netplay_ip_port/d" ${RACONF}
	sed -i "/netplay_delay_frames/d" ${RACONF}
	sed -i "/netplay_nickname/d" ${RACONF}
	sed -i "/netplay_client_swap_input/d" ${RACONF}
	sed -i "/netplay_ip_port/d" ${RACONF}
	sed -i "/netplay_server_ip/d" ${RACONF}
	sed -i "/netplay_client_swap_input/d" ${RACONF}
	sed -i "/netplay_spectator_mode_enable/d" ${RACONF}
	sed -i "/netplay_use_mitm_server/d" ${RACONF}
	sed -i "/netplay_ip_address/d" ${RACONF}
	sed -i "/netplay_mitm_server/d" ${RACONF}
	sed -i "/netplay_mode/d" ${RACONF}
	sed -i "/wifi_enabled/d" ${RACONF}
}

function default_settings() {
log "Default settings function"
# IMPORTANT: Every setting we change should have a default value here
	clean_settings
	echo 'video_scale_integer = "false"' >> ${RACONF}
	echo 'video_ctx_scaling = "false"' >> ${RACONF}
	echo 'video_shader = ""' >> ${RACONF}
	echo 'video_shader_enable = "false"' >> ${RACONF}
	echo 'video_smooth = "false"' >> ${RACONF} 
	echo 'aspect_ratio_index = "22"' >> ${RACONF}
	echo 'rewind_enable = "false"' >> ${RACONF} 
	echo 'run_ahead_enabled = "false"' >> ${RACONF}
	echo 'run_ahead_frames = "1"' >> ${RACONF}
	echo 'run_ahead_secondary_instance = "false"' >> ${RACONF}
	echo 'savestate_auto_load = "false"' >> ${RACONF}
	echo 'savestate_directory = "'"${SNAPSHOTS}/${PLATFORM}"'"' >> ${RACONF}
	echo 'cheevos_enable = "false"' >> ${RACONF}
	echo 'cheevos_username = ""' >> ${RACONF}
	echo 'cheevos_password = ""' >> ${RACONF}
	echo 'cheevos_hardcore_mode_enable = "false"' >> ${RACONF}
	echo 'cheevos_leaderboards_enable = "false"' >> ${RACONF}
	echo 'cheevos_verbose_enable = "false"' >> ${RACONF}
	echo 'cheevos_auto_screenshot = "false"' >> ${RACONF}
	echo 'ai_service_mode = "0"' >> ${RACONF}
	echo 'ai_service_enable = false' >> ${RACONF}
	echo 'ai_service_source_lang = "0"' >> ${RACONF}
	echo 'ai_service_url = ""' >> ${RACONF}
	echo "input_libretro_device_p1 = \"1\"" >> ${RACONF}
	echo 'fps_show = false' >> ${RACONF}
	echo 'netplay = false' >> ${RACONF}
	echo 'wifi_enabled = "false"' >> ${RACONF}
}

function set_setting() {
log "Set Settings function (${1})"
# we set the setting on the configuration file
case ${1} in
	"wifi")
	if [ "$(get_ee_setting wifi.enabled)" = "1" ]
	then
		echo 'wifi_enabled = "true"' >> ${RACONF}
	else
                echo 'wifi_enabled = "false"' >> ${RACONF}
        fi
	;;
	"ratio")
	if [[ "${2}" == "false" ]]; then
		# 22 is the "Core Provided" aspect ratio and its set by default if no other is selected
		echo 'aspect_ratio_index = "22"' >> ${RACONF}
	else	
	for i in "${!INDEXRATIOS[@]}"; do
		if [[ "${INDEXRATIOS[$i]}" = "${2}" ]]; then
			break
		fi
	done
		echo "aspect_ratio_index = \"${i}\""  >> ${RACONF}
	fi
	;;
	"smooth")
		[ "${2}" == "1" ] && echo 'video_smooth = "true"' >> ${RACONF} || echo 'video_smooth = "false"' >> ${RACONF} 
	;;
	"rewind")
	(for e in "${NORUNAHEAD[@]}"; do [[ "${e}" == "${PLATFORM}" ]] && exit 0; done) && RA=0 || RA=1
			if [ $RA == 1 ] && [ "${2}" == "1" ]; then
				echo 'rewind_enable = "true"' >> ${RACONF}
			else
				echo 'rewind_enable = "false"' >> ${RACONF} 
			fi
	;;
	"autosave")
		if [ "${2}" == false ] || [ "${2}" == "1" ]; then 
			echo 'savestate_auto_save = "true"' >> ${RACONF}
			echo 'savestate_auto_load = "true"' >> ${RACONF}
			AUTOLOAD=true
		else
			echo 'savestate_auto_save = "false"' >> ${RACONF}
			echo 'savestate_auto_load = "false"' >> ${RACONF}
			AUTOLOAD=false
		fi
	;;
	"snapshot")
		echo 'savestate_directory = "'"${SNAPSHOTS}/${PLATFORM}"'"' >> ${RACONF}
		if [ ! -z ${SNAPSHOT} ]
		then
			if [ ${AUTOLOAD} == true ]
			then
				sed -i "/savestate_auto_load =/d" ${RACONF}
				sed -i "/savestate_auto_save =/d" ${RACONF}
				echo 'savestate_auto_save = "true"' >> ${RACONF}
				echo 'savestate_auto_load = "true"' >> ${RACONF}
				echo "state_slot = \"${SNAPSHOT}\"" >> ${RACONF}
			else
				sed -i "/savestate_auto_load =/d" ${RACONF}
				sed -i "/savestate_auto_save =/d" ${RACONF}
				echo 'savestate_auto_save = "false"' >> ${RACONF}
				echo 'savestate_auto_load = "false"' >> ${RACONF}
				echo 'state_slot = "0"' >> ${RACONF}
			fi
		fi
	;;
	"integerscale")
		[ "${2}" == "1" ] && echo 'video_scale_integer = "true"' >> ${RACONF} || echo 'video_scale_integer = "false"' >> ${RACONF} 
	;;
        "rgascale")
                [ "${2}" == "1" ] && echo 'video_ctx_scaling = "true"' >> ${RACONF} || echo 'video_ctx_scaling = "false"' >> ${RACONF}
        ;;
	"shaderset")
		if [ "${2}" == "false" ] || [ "${2}" == "none" ] || [ "${2}" == "0" ]; then 
			echo 'video_shader_enable = "false"' >> ${RACONF}
			echo 'video_shader = ""' >> ${RACONF}
		else
			echo "video_shader = \"${2}\"" >> ${RACONF}
			echo 'video_shader_enable = "true"' >> ${RACONF}
			echo "--set-shader /tmp/shaders/${2}"
		fi
	;;
	"runahead")
	(for e in "${NORUNAHEAD[@]}"; do [[ "${e}" == "${PLATFORM}" ]] && exit 0; done) && RA=0 || RA=1
    if [ $RA == 1 ]; then
		if [ "${2}" == "false" ] || [ "${2}" == "none" ] || [ "${2}" == "0" ]; then 
			echo 'run_ahead_enabled = "false"' >> ${RACONF}
			echo 'run_ahead_frames = "1"' >> ${RACONF}
		else
			echo 'run_ahead_enabled = "true"' >> ${RACONF}
			echo "run_ahead_frames = \"${2}\"" >> ${RACONF}
		fi
	fi
	;;
	"secondinstance")
	(for e in "${NORUNAHEAD[@]}"; do [[ "${e}" == "${PLATFORM}" ]] && exit 0; done) && RA=0 || RA=1
    if [ $RA == 1 ]; then
		[ "${2}" == "1" ] && echo 'run_ahead_secondary_instance = "true"' >> ${RACONF} || echo 'run_ahead_secondary_instance = "false"' >> ${RACONF} 
	fi
	;;
	"ai_service_enabled")
		if [ "${2}" == "false" ] || [ "${2}" == "none" ] || [ "${2}" == "0" ]; then
			echo 'ai_service_enable = "false"' >> ${RACONF}
		else
			echo 'ai_service_enable = "true"' >> ${RACONF}
			get_setting "ai_target_lang"
			AI_LANG=${EES}
			[[ "$AI_LANG" == "false" ]] && $AI_LANG="0"
			get_setting "ai_service_url"
			AI_URL=${EES}
			echo "ai_service_source_lang = \"${AI_LANG}\"" >> ${RACONF}
			if [ "${AI_URL}" == "false" ] || [ "${AI_URL}" == "auto" ] || [ "${AI_URL}" == "none" ]; then
				echo "ai_service_url = \"http://ztranslate.net/service?api_key=BATOCERA&mode=Fast&output=png&target_lang=\"${AI_LANG}\"" >> ${RACONF}
			else
				echo "ai_service_url = \"${AI_URL}&mode=Fast&output=png&target_lang=\"${AI_LANG}\"" >> ${RACONF}
			fi
		fi
	;;
	"retroachievements")
		for i in "${!RETROARCHIVEMENTS[@]}"; do
			if [[ "${RETROARCHIVEMENTS[$i]}" = "${PLATFORM}" ]]; then
				if [ "${2}" == "1" ]; then
					echo 'cheevos_enable = "true"' >> ${RACONF}
					get_setting "retroachievements.username"
					echo "cheevos_username = \"${EES}\""  >> ${RACONF}
					get_setting "retroachievements.password"
					echo "cheevos_password = \"${EES}\""  >> ${RACONF}

					# retroachievements_hardcore_mode
					get_setting "retroachievements.hardcore"
					[ "${EES}" == "1" ] && echo 'cheevos_hardcore_mode_enable = "true"' >> ${RACONF} || echo 'cheevos_hardcore_mode_enable = "false"' >> ${RACONF}
                        
					# retroachievements_leaderboards
					get_setting "retroachievements.leaderboards"
					[ "${EES}" == "1" ] && echo 'cheevos_leaderboards_enable = "true"' >> ${RACONF} || echo 'cheevos_leaderboards_enable = "false"' >> ${RACONF}
           
					# retroachievements_verbose_mode
					get_setting "retroachievements.verbose"
					[ "${EES}" == "1" ] && echo 'cheevos_verbose_enable = "true"' >> ${RACONF} || echo 'cheevos_verbose_enable = "false"' >> ${RACONF}
            
					# retroachievements_automatic_screenshot
					get_setting "retroachievements.screenshot"
					[ "${EES}" == "1" ] && echo 'cheevos_auto_screenshot = "true"' >> ${RACONF} || echo 'cheevos_auto_screenshot = "false"' >> ${RACONF}
				else
					echo 'cheevos_enable = "false"' >> ${RACONF}
					echo 'cheevos_username = ""' >> ${RACONF}
					echo 'cheevos_password = ""' >> ${RACONF}
					echo 'cheevos_hardcore_mode_enable = "false"' >> ${RACONF}
					echo 'cheevos_leaderboards_enable = "false"' >> ${RACONF}
					echo 'cheevos_verbose_enable = "false"' >> ${RACONF}
					echo 'cheevos_auto_screenshot = "false"' >> ${RACONF}
				fi
			fi
		done
	;; 
	"netplay")

	if [ "${2}" == "false" ] || [ "${2}" == "none" ] || [ "${2}" == "0" ]; then
			echo 'netplay = false' >> ${RACONF}
	else
		echo 'netplay = true' >> ${RACONF}
		
		get_setting "netplay.mode"
		NETPLAY_MODE=${EES}
		
        # Security : hardcore mode disables save states, which would kill netplay
        sed -i '/cheevos_hardcore_mode_enable =/d' ${RACONF}
        echo 'cheevos_hardcore_mode_enable = "false"' >> ${RACONF}
	
	if [[ "${NETPLAY_MODE}" == "host" ]]; then
        # Quite strangely, host mode requires netplay_mode to be set to false when launched from command line
        echo 'netplay_mode = false' >> ${RACONF}
        echo 'netplay_client_swap_input = false' >> ${RACONF}
        get_setting "netplay.port"
        echo "netplay_ip_port = ${EES}" >> ${RACONF}
        
	elif [[ "${NETPLAY_MODE}" == "client" ]]; then
		# But client needs netplay_mode = true ... bug ?
        echo 'netplay_mode = true' >> ${RACONF}
        
        get_setting "netplay.client.ip"
        echo "netplay_ip_address = ${EES}" >> ${RACONF}
        
        get_setting "netplay.client.port"
        echo "netplay_ip_port = ${EES}" >> ${RACONF}
        
        echo 'netplay_client_swap_input = true' >> ${RACONF}
	fi # Host or Client 

            # relay
        get_setting "netplay.relay"
        if [[ ! -z "${EES}" && "${EES}" != "none" ]]; then
            echo 'netplay_use_mitm_server = true'  >> ${RACONF}
            echo "netplay_mitm_server = ${EES}" >> ${RACONF}
        else
            echo 'netplay_use_mitm_server = false' >> ${RACONF}
            sed -i "/netplay_mitm_server/d" ${RACONF}
        fi
        
        get_setting "netplay.frames"
        echo "netplay_delay_frames = ${EES}" >> ${RACONF}

        get_setting "netplay.nickname"
        echo "netplay_nickname = ${EES}" >> ${RACONF}
        
     
    # mode spectator
         get_setting "netplay.spectator"
         [ "${EES}" == "1" ] && echo 'netplay_spectator_mode_enable = true' >> ${RACONF} || echo 'netplay_spectator_mode_enable = false' >> ${RACONF}
       
	fi
	;;
	"fps")
    # Display FPS
	get_setting "showFPS"
    [ "${EES}" == "1" ] && echo 'fps_show = "true"' >> ${RACONF} || echo 'fps_show = "false"' >> ${RACONF}
	;;
esac
}

function get_setting() {
log "Get Settings function (${1})"
#We look for the setting on the ROM first, if not found we search for platform and lastly we search globally
	PAT="s|^${PLATFORM}\[\"${ROM}\"\].*${1}=\(.*\)|\1|p"
	EES=$(sed -n "${PAT}" "${CONF}")

if [ -z "${EES}" ]; then
	PAT="s|^${PLATFORM}[\.-]${1}=\(.*\)|\1|p"
	EES=$(sed -n "${PAT}" "${CONF}")
fi

if [ -z "${EES}" ]; then
	PAT="s|^global[\.-].*${1}=\(.*\)|\1|p"
	EES=$(sed -n "${PAT}" "${CONF}")
fi

# Sanity check in case there there are 2 variables set, only use the first line
EES=$(echo $EES | head -1)

[ -z "${EES}" ] && EES="false"
set_setting ${1} ${EES}
}

clean_settings

for s in wifi ratio smooth shaderset rewind autosave snapshot integerscale rgascale runahead secondinstance retroachievements ai_service_enabled netplay fps; do
log "Get settings loop (${1})"
get_setting $s
[ -z "${EES}" ] || SETF=1
done

if [ $SETF == 0 ]; then
# If no setting was changed, set all options to default on the configuration files
default_settings
fi

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
CONTROLLERS="$@"
CONTROLLERS="${CONTROLLERS#*--controllers=*}"

for i in 1 2 3 4 5; do
log "Controller section (${1})"
if [[ "$CONTROLLERS" == *p${i}* ]]; then
PINDEX="${CONTROLLERS#*-p${i}index }"
PINDEX="${PINDEX%% -p${i}guid*}"
sed -i "/input_player${i}_joypad_index =/d" ${RACONF}
echo "input_player${i}_joypad_index = \"${PINDEX}\"" >> ${RACONF}

# Setting controller type for different cores
if [ "${PLATFORM}" == "atari5200" ]; then
	sed -i "/input_libretro_device_p${i}/d" ${RACONF}
	echo "input_libretro_device_p${i} = \"513\"" >> ${RACONF}
fi

fi
done
EE_DEVICE=$(cat /storage/.config/.OS_ARCH)

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

# Show bezel if enabled
get_setting "bezel"
[ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ] && ${TBASH} /usr/bin/bezels.sh "default" || ${TBASH} /usr/bin/bezels.sh "$PLATFORM" "${ROM}"

doexit

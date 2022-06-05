#!/bin/bash

source /etc/profile

EE_DEVICE=$(cat /storage/.config/.OS_ARCH)
EXECLOG="/tmp/logs/exec.log"
ROM="${1##*/}"
PLATFORM="nds"
BASEFOLDER="/storage/drastic/aarch64/drastic/"
CONFFOLDER="${BASEFOLDER}config"
DRASTICFOLDER="${BASEFOLDER}drastic"
CONFFILE="${CONFFOLDER}/drastic.cfg"
CONF="/storage/.config/distribution/configs/distribution.conf"

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

function set_config_value(){
        sed -i "s/^\(${1} = \).*/${1} = ${2}/" ${CONFFILE}
}

function set_es_setting(){
        ES_KEY="${1}"   # Key with the value we're getting from ES
        DEFF="${2}"     # Default value
        CFG_KEY="${3}"  # Key in the config file
        DEF552="${4}"   # Default for the 552 if applicable.

        get_setting "${ES_KEY}"
        if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ]; then
                if [ "$EE_DEVICE" == "RG552" ] && [ ! -z "${DEF552}" ]; then
                        set_config_value "${CFG_KEY}" "${DEF552}"
                else
                        set_config_value "${CFG_KEY}" "${DEFF}"
                fi
        else
                set_config_value "${CFG_KEY}" "${EES}"
        fi
        

}



if [ ! -d "${CONFFOLDER}" ]
then
  mkdir -p "${CONFFOLDER}"
  cp -rf /usr/share/drastic/drastic.cfg "${CONFFOLDER}"
fi

if [ ! -f "${CONFFILE}" ]
then
  cp -rf /usr/share/drastic/config/drastic.cfg "${CONFFOLDER}"
fi

if [ ! -f "${DRASTICFOLDER}" ]
then
  mkdir -p "${BASEFOLDER}"
  cp -rf /usr/share/drastic/data/* "${BASEFOLDER}"
fi

cd "${BASEFOLDER}"

# Emulation Station Settings

set_es_setting "highres_3d" "0" "hires_3d" "1"
set_es_setting "threaded_3d" "1" "threaded_3d"
set_es_setting "frameskip_type" "2" "frameskip_type"
set_es_setting "frames_skipped" "1" "frameskip_value"
set_es_setting "show_fps" "0" "show_frame_counter"
set_es_setting "screen_mode" "1" "screen_orientation"
set_es_setting "screen_swap" "0" "screen_swap"
set_es_setting "disable_edge_marking" "0" "disable_edge_marking"
set_es_setting "bios_language" "1" "firmware.language"
set_es_setting "birthday_month" "0" "firmware.birthday_month"
set_es_setting "birthday_day" "1" "firmware.birthday_day"
set_es_setting "favorite_color" "4" "firmware.favorite_color"

# End of EmulationStation settings implementation


./drastic "${1}" >> $EXECLOG 2>&1

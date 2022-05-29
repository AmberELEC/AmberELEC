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

# EmulationStation settings implementation
get_setting "highres_3d"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ]; then
	if [ "$EE_DEVICE" == "RG552" ]; then
		set_config_value "hires_3d" "1"
	else
		set_config_value "hires_3d" "0"
	fi
else 
	set_config_value "hires_3d" "${EES}"
fi
	
get_setting "threaded_3d"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ]; then
	set_config_value "threaded_3d" "1"
else 
	set_config_value "threaded_3d" "${EES}"
fi

get_setting "frameskip_type"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ]; then
	set_config_value "frameskip_type" "0"
else 
	set_config_value "frameskip_type" "${EES}"
fi

get_setting "frames_skipped"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ]; then
	set_config_value "frameskip_value" "1"
else 
	set_config_value "frameskip_value" "${EES}"
fi
# End of EmulationStation settings implementation


./drastic "${1}" >> $EXECLOG 2>&1

#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

. /etc/profile

ROM="${1##*/}"
PLATFORM="laserdisc"
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

# Joystick directions
# Get configuration from distribution.conf
get_setting "joystick_directions"
if [ "${EES}" == "auto" ] || [ "${EES}" == "standard" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	TIPHAT=''
else
	TIPHAT='-tiphat'
fi

dir="${1}"
name=${dir##*/}
name=${name%.*}
ext=${dir##*/}
ext=${ext,,}
ext=${ext#*.}
config="/storage/.config/distribution/configs/hypseus"
configfile="${config}/hypinput.ini"

# Attempt to auto configure gamepad
GAMEPADINFO="$(sdljoytest -skip_loop)"
JOYNAME=$(echo "${GAMEPADINFO}" | grep "Joystick 0 name " | sed "s|Joystick 0 name ||" | sed "s|'||g")

for file in /tmp/joypads/*.cfg; do
	GAMEPAD=$(cat "$file" | grep input_device|  cut -d'"' -f 2)
	if [ "${JOYNAME}" == "${GAMEPAD}" ]; then
		GPFILE="${file}"

		for key in KEY_UP KEY_DOWN KEY_LEFT KEY_RIGHT KEY_BUTTON1 KEY_BUTTON2 KEY_BUTTON3 KEY_START1 KEY_COIN1 KEY_PAUSE KEY_CONSOLE KEY_TEST KEY_SERVICE; do

			case ${key} in
				"KEY_UP")
					if [[ "${TIPHAT}" == "-tiphat" ]]; then
						button=$(cat "${GPFILE}" | grep -E 'input_down_btn' | cut -d '"' -f2)
						keyboard="1073741905 0"
					else
						button=$(cat "${GPFILE}" | grep -E 'input_up_btn' | cut -d '"' -f2)
						keyboard="1073741906 0"
					fi
				;;
				"KEY_DOWN")
					if [[ "${TIPHAT}" == "-tiphat" ]]; then
						button=$(cat "${GPFILE}" | grep -E 'input_up_btn' | cut -d '"' -f2)
						keyboard="1073741906 0"
					else
						button=$(cat "${GPFILE}" | grep -E 'input_down_btn' | cut -d '"' -f2)
						keyboard="1073741905 0"
					fi
				;;
				"KEY_LEFT")
					button=$(cat "${GPFILE}" | grep -E 'input_left_btn' | cut -d '"' -f2)
					keyboard="1073741904 0"
				;;
				"KEY_RIGHT")
					button=$(cat "${GPFILE}" | grep -E 'input_right_btn' | cut -d '"' -f2)
					keyboard="1073741903 0"
				;;
				"KEY_BUTTON1")
					button=$(cat "${GPFILE}" | grep -E 'input_a_btn' | cut -d '"' -f2)
					keyboard="1073742048 0"
				;;
				"KEY_BUTTON2")
					button=$(cat "${GPFILE}" | grep -E 'input_b_btn' | cut -d '"' -f2)
					keyboard="1073742050 0"
				;;
				"KEY_BUTTON3")
					button=$(cat "${GPFILE}" | grep -E 'input_x_btn' | cut -d '"' -f2)
					keyboard="32 0"
				;;
				"KEY_START1")
					button=$(cat "${GPFILE}" | grep -E 'input_start_btn' | cut -d '"' -f2)
					keyboard="49 0"
				;;
				"KEY_COIN1")
					button=$(cat "${GPFILE}" | grep -E 'input_select_btn' | cut -d '"' -f2)
					keyboard="53 54"
				;;
				"KEY_PAUSE")
					button=$(cat "${GPFILE}" | grep -E 'input_l2_btn' | cut -d '"' -f2)
					keyboard="0 0"
				;;
				"KEY_CONSOLE")
					button=$(cat "${GPFILE}" | grep -E 'input_r2_btn' | cut -d '"' -f2)
					keyboard="0 0"
				;;
				"KEY_TEST")
					button=$(cat "${GPFILE}" | grep -E 'input_l_btn' | cut -d '"' -f2)
					keyboard="0 0"
				;;
				"KEY_SERVICE")
					button=$(cat "${GPFILE}" | grep -E 'input_r_btn' | cut -d '"' -f2)
					keyboard="0 0"
				;;
			esac

			# if the button is in fact a hat extract the number, else use the button number+1
			if [[ "${button}" == "h"* ]]; then
				if [[ "${key}" == "KEY_UP" ]] && [[ "${TIPHAT}" == "-tiphat" ]]; then
					button="0 -002"
				elif [[ "${key}" == "KEY_DOWN" ]] && [[ "${TIPHAT}" == "-tiphat" ]]; then
					button="0 +002"
				elif [[ "${key}" == "KEY_UP" ]]; then
					button="0 +002"
				elif [[ "${key}" == "KEY_DOWN" ]]; then
					button="0 -002"
				elif [[ "${key}" == "KEY_LEFT" ]]; then
					button="0 +001"
				elif [[ "${key}" == "KEY_RIGHT" ]]; then
					button="0 -001"
				fi
			else
				button="$((${button} + 1))"
				if [[ "${key}" == "KEY_UP" ]] && [[ "${TIPHAT}" == "-tiphat" ]]; then
					button="${button} +002"
				elif [[ "${key}" == "KEY_DOWN" ]] && [[ "${TIPHAT}" == "-tiphat" ]]; then
					button="${button} -002"
				fi
			fi

			sed -i "s|${key}.*|${key} = ${keyboard} ${button} |" ${configfile}
		done
	fi
done # finish auto gamepad

if [[ -f "${dir}/${name}.commands" ]]; then
	params=$(<"${dir}/${name}.commands")
fi

cd "${config}"

if [[ "${ext}" == "ld" ]] && [[ -f "${dir}/${name}.singe" ]]; then
	mkdir "/storage/roms/laserdisc/${name}.daphne"
	mount -obind ${dir} "/storage/roms/laserdisc/${name}.daphne"
	hypseus singe vldp -framefile "${dir}/${name}.txt" -script "${dir}/${name}.singe" -fullscreen -retropath $TIPHAT $params
	sleep 0.1
	umount "/storage/roms/laserdisc/${name}.daphne"
	rmdir "/storage/roms/laserdisc/${name}.daphne"
elif [[ "${ext}" == "daphne" ]] && [[ ! -f "${dir}/${name}.singe" ]]; then
	hypseus "${name}" vldp -framefile "${dir}/${name}.txt" -fullscreen $TIPHAT $params
else
	text_viewer -e -w -t "No supported LaserDisc game found!" -m "Please go to https://amberelec.org/systems/laserdisc for further information!"
fi

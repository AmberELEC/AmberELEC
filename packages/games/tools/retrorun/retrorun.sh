#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

. /etc/profile

echo 'Starting retrorun emulator...'

CORE="$1"
ROM="${2##*/}"
PLATFORM="$3"
CONF="/storage/.config/distribution/configs/distribution.conf"
RRCONF="/storage/.config/distribution/configs/retrorun.cfg"

if [ ! -f ${RRCONF} ]; then
  cp -f /usr/config/distribution/configs/retrorun.cfg /storage/.config/distribution/configs/
fi

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


### GLOBAL SETTINGS ###
echo 'Global settings.'
# Auto Save
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "auto_save"
echo "auto_save:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_auto_save/d" ${RRCONF}
	echo 'retrorun_auto_save = false' >> ${RRCONF}
else
	sed -i "/^retrorun_auto_save/d" ${RRCONF}
	echo "retrorun_auto_save = ${EES}" >> ${RRCONF}
fi

# Audio Buffer
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "audio_buffer"
echo "audio_buffer:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_audio_buffer/d" ${RRCONF}
	echo 'retrorun_audio_buffer= 1024' >> ${RRCONF}
else
	sed -i "/^retrorun_audio_buffer/d" ${RRCONF}
	echo "retrorun_audio_buffer= ${EES}" >> ${RRCONF}
fi

# Mouse Speed Factor
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "mouse_speed"
echo "mouse_speed:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_mouse_speed_factor/d" ${RRCONF}
	echo 'retrorun_mouse_speed_factor= 5' >> ${RRCONF}
else
	sed -i "/^retrorun_mouse_speed_factor/d" ${RRCONF}
	echo "retrorun_mouse_speed_factor= ${EES}" >> ${RRCONF}
fi

# Map left analog to DPAD
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "map_left_analog_to_dpad"
echo "map_left_analog_to_dpad:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
        sed -i "/^retrorun_force_left_analog_stick/d" ${RRCONF}
        echo 'retrorun_force_left_analog_stick = false' >> ${RRCONF}
else
        sed -i "/^retrorun_force_left_analog_stick/d" ${RRCONF}
        echo "retrorun_force_left_analog_stick = ${EES}" >> ${RRCONF}
fi

# Game Aspect Ratio
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "game_aspect_ratio"
echo "game_aspect_ratio:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_aspect_ratio/d" ${RRCONF}
	echo 'retrorun_aspect_ratio = auto' >> ${RRCONF}
else
	sed -i "/^retrorun_aspect_ratio/d" ${RRCONF}
	echo "retrorun_aspect_ratio = ${EES}" >> ${RRCONF}
fi

# Show FPS
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "show_fps"
echo "show_fps:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "disabled" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_fps_counter/d" ${RRCONF}
	echo 'retrorun_fps_counter = disabled' >> ${RRCONF}
else
	sed -i "/^retrorun_fps_counter/d" ${RRCONF}
	echo "retrorun_fps_counter = ${EES}" >> ${RRCONF}
fi

# Swap triggers
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "swap_triggers"
echo "swap_triggers:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "disabled" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_swap_l1r1_with_l2r2/d" ${RRCONF}
	echo 'retrorun_swap_l1r1_with_l2r2 = false' >> ${RRCONF}
else
	sed -i "/^retrorun_swap_l1r1_with_l2r2/d" ${RRCONF}
	echo "retrorun_swap_l1r1_with_l2r2 = ${EES}" >> ${RRCONF}
fi

# Swap analog sticks
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "swap_analog_sticks"
echo "swap_analog_sticks:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "disabled" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_swap_sticks/d" ${RRCONF}
	echo 'retrorun_swap_sticks = false' >> ${RRCONF}
else
	sed -i "/^retrorun_swap_sticks/d" ${RRCONF}
	echo "retrorun_swap_sticks = ${EES}" >> ${RRCONF}
fi

# Tate Mode
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "tate_mode"
echo "tate_mode:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_tate_mode/d" ${RRCONF}
	echo 'retrorun_tate_mode = auto' >> ${RRCONF}
else
	sed -i "/^retrorun_tate_mode/d" ${RRCONF}
	echo "retrorun_tate_mode = ${EES}" >> ${RRCONF}
fi

# Force FPS
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "force_fps"
echo "force_fps:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "disabled" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_loop_declared_fps/d" ${RRCONF}
	echo 'retrorun_loop_declared_fps = false' >> ${RRCONF}
else
	sed -i "/^retrorun_loop_declared_fps/d" ${RRCONF}
	echo "retrorun_loop_declared_fps = ${EES}" >> ${RRCONF}
fi

### MISC SETTINGS ###
echo 'Misc settings.'
# Internal Resolution
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "internal_resolution"
echo "internal_resolution:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "parallel_n64" ]]; then
		sed -i "/^parallel-n64-screensize/d" ${RRCONF}
		echo 'parallel-n64-screensize = 640x480' >> ${RRCONF}
	elif [[ "${CORE}" == "flycast" ]]; then
		sed -i "/^flycast_internal_resolution/d" ${RRCONF}
		echo 'flycast_internal_resolution = 640x480' >> ${RRCONF}
	elif [[ "${CORE}" == "flycast2021" ]]; then
		sed -i "/^flycast2021_internal_resolution/d" ${RRCONF}
		echo 'flycast2021_internal_resolution = 640x480' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" == "parallel_n64" ]]; then
		sed -i "/^parallel-n64-screensize/d" ${RRCONF}
		echo "parallel-n64-screensize = ${EES}" >> ${RRCONF}
	elif [[ "${CORE}" == "flycast" ]]; then
		sed -i "/^flycast_internal_resolution/d" ${RRCONF}
		echo "flycast_internal_resolution = ${EES}" >> ${RRCONF}
	elif [[ "${CORE}" == "flycast2021" ]]; then
		sed -i "/^flycast2021_internal_resolution/d" ${RRCONF}
		echo "flycast2021_internal_resolution = ${EES}" >> ${RRCONF}
	fi
fi

### PARALLEL-N64 SETTINGS ###
echo 'Parallel-n64 settings.'
# Parallel-N64 Graphic plug-in
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "gfx_plugin"
echo "gfx_plugin:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "parallel_n64" ]]; then
		sed -i "/^parallel-n64-gfxplugin/d" ${RRCONF}
		echo 'parallel-n64-gfxplugin = rice' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" == "parallel_n64" ]]; then
		sed -i "/^parallel-n64-gfxplugin/d" ${RRCONF}
		echo "parallel-n64-gfxplugin = ${EES}" >> ${RRCONF}
	fi
fi

# Parallel-N64 Overclock
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "overclock"
echo "overclock:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "parallel_n64" ]]; then
		sed -i "/^parallel-n64-virefresh/d" ${RRCONF}
		echo 'parallel-n64-virefresh = auto' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" == "parallel_n64" ]]; then
		sed -i "/^parallel-n64-virefresh/d" ${RRCONF}
		echo "parallel-n64-virefresh = ${EES}" >> ${RRCONF}
	fi
fi

### FLYCAST SETTINGS ###
echo 'Flycast settings.'
# Flycast: Synchronous Rendering
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "synchronous_rendering"
echo "synchronous_rendering:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "flycast" ]]; then
		sed -i "/^flycast_synchronous_rendering/d" ${RRCONF}
		echo 'flycast_synchronous_rendering = disabled' >> ${RRCONF}
	elif [[ "${CORE}" == "flycast2021" ]]; then
		sed -i "/^flycast2021_synchronous_rendering/d" ${RRCONF}
		echo 'flycast2021_synchronous_rendering = disabled' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" == "flycast" ]]; then
		sed -i "/^flycast_synchronous_rendering/d" ${RRCONF}
		echo "flycast_synchronous_rendering = ${EES}" >> ${RRCONF}
	elif [[ "${CORE}" == "flycast2021" ]]; then
		sed -i "/^flycast2021_synchronous_rendering/d" ${RRCONF}
		echo "flycast2021_synchronous_rendering = ${EES}" >> ${RRCONF}
	fi
fi

# Flycast: Enables/Disables a division optimization
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "div_matching"
echo "div_matching:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "flycast" ]]; then
		sed -i "/^flycast_div_matching/d" ${RRCONF}
		echo 'flycast_div_matching = auto' >> ${RRCONF}
	elif [[ "${CORE}" == "flycast2021" ]]; then
		sed -i "/^flycast2021_div_matching/d" ${RRCONF}
		echo 'flycast2021_div_matching = auto' >> ${RRCONF}
	fi
else
        if [[ "${CORE}" == "flycast" ]]; then
		sed -i "/^flycast_div_matching/d" ${RRCONF}
		echo "flycast_div_matching = ${EES}" >> ${RRCONF}
	elif [[ "${CORE}" == "flycast2021" ]]; then
		sed -i "/^flycast2021_div_matching/d" ${RRCONF}
		echo "flycast2021_div_matching = ${EES}" >> ${RRCONF}
	fi
fi

# Flycast Auto Frameskip
# Get configuration from distribution.conf and set to retrorun.cfg
# default value for flycast_auto_skip_frame it's 'some'
if [[ "$EE_DEVICE" == "RG552" ]]; then
	DEFAULT_AUTO_SKIP_FRAME='disabled' # this is better on RG552
else
	DEFAULT_AUTO_SKIP_FRAME='some'
fi
get_setting "auto_frameskip"
echo "auto_frameskip:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "flycast" ]]; then
		sed -i "/^flycast_auto_skip_frame/d" ${RRCONF}
		echo "flycast_auto_skip_frame = ${DEFAULT_AUTO_SKIP_FRAME}" >> ${RRCONF}
	fi
else
	if [[ "${CORE}" == "flycast" ]]; then
		sed -i "/^flycast_auto_skip_frame/d" ${RRCONF}
		echo "flycast_auto_skip_frame = ${EES}" >> ${RRCONF}
	fi
fi

# Flycast: Enables/Disables the DSP. Fixes audio issues on some games.
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "dsp"
echo "dsp:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "flycast" ]]; then
		sed -i "/^flycast_enable_dsp/d" ${RRCONF}
		echo 'flycast_enable_dsp = disabled' >> ${RRCONF}
	elif [[ "${CORE}" == "flycast2021" ]]; then
		sed -i "/^flycast2021_enable_dsp/d" ${RRCONF}
		echo 'flycast2021_enable_dsp = disabled' >> ${RRCONF}
	fi
else
        if [[ "${CORE}" == "flycast" ]]; then
		sed -i "/^flycast_enable_dsp/d" ${RRCONF}
		echo "flycast_enable_dsp = ${EES}" >> ${RRCONF}
	elif [[ "${CORE}" == "flycast2021" ]]; then
		sed -i "/^flycast2021_enable_dsp/d" ${RRCONF}
		echo "flycast2021_enable_dsp = ${EES}" >> ${RRCONF}
	fi
fi

### PSX PCSX_REARMED ###
echo 'Pcsx-rearmed settings.'
# PSX CPU Clock
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "psx_cpu_clock"
echo "psx_cpu_clock:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "pcsx_rearmed" ]]; then
		sed -i "/^pcsx_rearmed_psxclock/d" ${RRCONF}
		echo 'pcsx_rearmed_psxclock = 57' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" == "pcsx_rearmed" ]]; then
		sed -i "/^pcsx_rearmed_psxclock/d" ${RRCONF}
		echo "pcsx_rearmed_psxclock = ${EES}" >> ${RRCONF}
	fi
fi

### PSX DUCKSTATION ###
echo 'Psx-duckstation settings.'
# PSX CPU Overclock
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "psx_cpu_overclock"
echo "psx_cpu_overclock:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "duckstation" ]]; then
		sed -i "/^duckstation_CPU.Overclock/d" ${RRCONF}
		echo 'duckstation_CPU.Overclock = 100' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" == "duckstation" ]]; then
		sed -i "/^duckstation_CPU.Overclock/d" ${RRCONF}
		echo "duckstation_CPU.Overclock = ${EES}" >> ${RRCONF}
	fi
fi

### PSX SWANSTATION ###
echo 'Psx-swanstation settings.'
# PSX CPU Overclock
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "psx_cpu_overclock"
echo "psx_cpu_overclock:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "swanstation" ]]; then
		sed -i "/^swanstation_CPU.Overclock/d" ${RRCONF}
		echo 'swanstation_CPU.Overclock = 100' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" == "swanstation" ]]; then
		sed -i "/^swanstation_CPU.Overclock/d" ${RRCONF}
		echo "swanstation_CPU.Overclock = ${EES}" >> ${RRCONF}
	fi
fi

### PPSSPP (PSP) ###
echo 'PPSSPP settings.'
# PPSSPP FrameSkip
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "frameskip"
echo "frameskip:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "ppsspp" ]]; then
		sed -i "/^ppsspp_frameskip/d" ${RRCONF}
		echo 'ppsspp_frameskip = 0' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" == "ppsspp" ]]; then
		sed -i "/^ppsspp_frameskip/d" ${RRCONF}
		echo "ppsspp_frameskip = ${EES}" >> ${RRCONF}
	fi
fi

# PPSSPP rendering mode
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "rendering_mode"
echo "rendering_mode:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "ppsspp" ]]; then
		sed -i "/^ppsspp_rendering_mode=/d" ${RRCONF}
		echo 'ppsspp_rendering_mode = buffered' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" == "ppsspp" ]]; then
		sed -i "/^ppsspp_rendering_mode=/d" ${RRCONF}
		echo "ppsspp_rendering_mode = ${EES}" >> ${RRCONF}
	fi
fi

### BEETLE VB SETTINGS ###
echo 'Beetle-vb settings.'
# Beetle VB - Palette
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "palette"
echo "palette:${EES}"
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" == "beetle_vb" ]]; then
		sed -i "/^vb_color_mode/d" ${RRCONF}
		echo 'vb_color_mode = black & red' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" == "beetle_vb" ]]; then
		sed -i "/^vb_color_mode/d" ${RRCONF}
		echo "vb_color_mode = ${EES}" >> ${RRCONF}
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
	if [[ $(cat /sys/firmware/devicetree/base/model | tr '\0' '\n') == *"D007 Plus"* ]]; then
		ln -s /dev/input/event5 /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
	else
		ln -s /dev/input/event4 /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
	fi
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

sleep 0.2
EMU="/tmp/cores/$1_libretro.so"
/usr/bin/retrorun --triggers $FPS -s /storage/roms/"$3" -d /roms/bios "$EMU" "$2"
sleep 0.5
rm /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
kill $(pidof rg351p-js2xbox)
echo 'end!'
#!/bin/bash
echo 'starting retrorun emulator...'
if [ ! -f /storage/.config/distribution/configs/retrorun.cfg ]; then
  cp -f /usr/config/distribution/configs/retrorun.cfg /storage/.config/distribution/configs/
fi
CORE="$1"
ROM="$2"
PLATFORM="$3"

retrorun_config_file="/storage/.config/distribution/configs/retrorun.cfg"

source /etc/profile
rom_name=$(basename "${ROM}")
resolution=$(get_ee_setting resolution "${PLATFORM}" "${rom_name}")

echo "resolution: ${resolution} rom: ${rom_name}"

# Because the config file is on the SD card, we are careful to only write when needed
if [ "$resolution" != "" ]; then
  if ! grep "^parallel-n64-screensize = ${resolution}" "${retrorun_config_file}"; then
    echo "Updating resolution..." 
    sed -i "/^parallel-n64-screensize/d" ${retrorun_config_file}
    echo "parallel-n64-screensize = ${resolution}" >> ${retrorun_config_file}
  else
    echo "resolution already correct"
  fi
else
  if grep "^parallel-n64-screensize =" ${retrorun_config_file}; then
    echo "Updating resolution..."
    sed -i "/^parallel-n64-screensize/d" ${retrorun_config_file}
  else
    echo "resolution already correct"
  fi
fi

rm /dev/input/by-path/platform-odroidgo2-joypad-event-joystick || true
echo 'creating fake joypad'
/usr/bin/rg351p-js2xbox --silent -t oga_joypad &

echo 'confguring inputs'
EE_DEVICE=$(cat /storage/.config/.OS_ARCH)
echo 'confguring inputs on device:'$EE_DEVICE
if [[ "$EE_DEVICE" == "RG351V" ]]
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

if [[ "$1" =~ "pcsx_rearmed" ]] || [[ "$1" =~ "parallel_n64" ]] || [[ "$1" =~ "uae4arm" ]]
then
    echo 'using 32bit'
  	export LD_LIBRARY_PATH="/usr/lib32"
	/usr/bin/retrorun32 --triggers $FPS -n -s /storage/roms/"$3"  -d /roms/bios "$1" "$2"
else
	echo 'using 64bit'
	/usr/bin/retrorun --triggers $FPS -n -s /storage/roms/"$3" -d /roms/bios "$1" "$2"
fi

rm /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
kill $(pidof rg351p-js2xbox)
echo 'end!'

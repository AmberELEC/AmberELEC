#!/bin/bash
echo 'starting retrorun emulator...'
if [ ! -f /storage/.config/distribution/configs/retrorun.cfg ]; then
  cp -f /usr/config/distribution/configs/retrorun.cfg /storage/.config/distribution/configs/
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
if [[ "$1" =~ "pcsx_rearmed" ]] || [[ "$1" =~ "parallel_n64" ]] || [[ "$1" =~ "uae4arm" ]]
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
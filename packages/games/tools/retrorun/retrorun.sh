#!/bin/bash
echo starting retrorun emulator...
rm /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
/usr/bin/rg351p-js2xbox --silent -t oga_joypad &
sleep 1
ln -s /dev/input/event3 /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
chmod 777 /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
sleep 1
echo using core: "$1"
echo starting game... "$2"
sleep 1
if [[ "$1" == "/tmp/cores/pcsx_rearmed_libretro.so" ]] || [[ "$1" == "/tmp/cores/parallel_n64_libretro.so" ]] || [[ "$1" == "/tmp/cores/uae4arm_libretro.so" ]]
then
  export LD_LIBRARY_PATH="/usr/lib32"
  /usr/bin/retrorun32 --triggers -n -s /tmp/logs -d /roms/bios "$1" "$2"
else
  /usr/bin/retrorun --triggers -n -s /tmp/logs -d /roms/bios "$1" "$2"
fi
sleep 1
kill $(pidof rg351p-js2xbox)
echo end!

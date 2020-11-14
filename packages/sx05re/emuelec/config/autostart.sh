#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

# DO NOT modify this file, if you need to use autostart please use /storage/.config/custom_start.sh 

# Enable these 3 following lines to add a small boost in performance mostly for s912 devices but might work for others, but remember to keep an eye on the temp!
# echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# echo "performance" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
# echo 5 > /sys/class/mpgpu/cur_freq
umount /var/media/GAMES
mount -o umask=000 -t vfat /dev/mmcblk0p3 /storage/roms

# It seems some slow SDcards have a problem creating the symlink on time :/
CONFIG_DIR="/storage/.emulationstation"
CONFIG_DIR2="/storage/.config/emulationstation"

if [ ! -L "$CONFIG_DIR" ]; then
ln -sf $CONFIG_DIR2 $CONFIG_DIR
fi

# Automatic updates
rsync -av --delete --exclude=custom_start.sh /usr/config/emuelec/scripts/ /storage/.config/emuelec/scripts
cp /usr/config/autostart.sh /storage/.config/autostart.sh

# Apply some kernel tuning
sysctl vm.swappiness=1

# copy bezel if it doesn't exists
if [ ! -f "/storage/roms/bezels/default.cfg" ]; then 
mkbezels/
cp -rf /usr/share/retroarch-overlays/bezels/* /storage/roms/bezels/
fi

# Create game directories if they don't exist..
# Temporary hack to be replaced with emuelec-dirs.conf

for dir in 3do BGM amiga amstradcpc arcade atari2600 atari5200 atari7800          \
	   atari800 atarijaguar atarilynx atarist atomiswave bios c128 c16        \
	   c64 capcom coleco cps1 cps2 cps3 daphne daphne/roms daphne/sound       \
	   dreamcast famicom fbneo fds gameandwatch gamegear gb gba gbc           \
	   genesis gw mame mastersystem megadrive megadrive-japan msx msx2        \
	   n64 naomi nds neocd neogeo nes ngp ngpc odyssey openbor pcengine       \
	   pcenginecd pcfx psp psx saturn sc-3000 scummvm sega32x segacd sfc      \
	   sg-1000 sgfx snes tg16 tg16cd uzebox vectrex vic20 videopac virtualboy \
	   wonderswan wonderswancolor x68000 zx81 zxspectrum ports ports/VVVVVV   \
	   ports/quake ports/diablo ports/doom ports/doom2 ports/cannonball       \
	   ports/CaveStory ports/reminiscence ports/xrick ports/opentyrian
do
  if [ ! -d "/storage/roms/${dir}" ]; then
    mkdir -p "/storage/roms/${dir}"
    chown root:root "/storage/roms/${dir}"
    chmod 0777 "/storage/roms/${dir}"
  fi
done

# Restore config if backup exists
BACKUPFILE="/storage/downloads/ee_backup_config.zip"

if [ -f ${BACKUPFILE} ]; then 
	unzip -o ${BACKUPFILE} -d /
	rm ${BACKUPFILE}
fi

# Check if we have unsynched update files
/usr/config/emuelec/scripts/force_update.sh

# Set video mode, this has to be done before starting ES
DEFE=$(get_ee_setting ee_videomode)

if [ "${DEFE}" != "Custom" ]; then
    [ ! -z "${DEFE}" ] && echo "${DEFE}" > /sys/class/display/mode
fi 

if [ -s "/storage/.config/EE_VIDEO_MODE" ]; then
        echo $(cat /storage/.config/EE_VIDEO_MODE) > /sys/class/display/mode
elif [ -s "/flash/EE_VIDEO_MODE" ]; then
        echo $(cat /flash/EE_VIDEO_MODE) > /sys/class/display/mode
fi

# finally we correct the FB according to video mode
/emuelec/scripts/setres.sh

# Clean cache garbage when boot up.
rm -rf /storage/.cache/cores/*

# handle SSH
DEFE=$(get_ee_setting ee_ssh.enabled)

case "$DEFE" in
"0")
	systemctl stop sshd
	rm /storage/.cache/services/sshd.conf
	;;
*)
	mkdir -p /storage/.cache/services/
	touch /storage/.cache/services/sshd.conf
	systemctl start sshd
	;;
esac

# Show splash creen 
/emuelec/scripts/show_splash.sh intro


# run custom_start before FE scripts
/storage/.config/custom_start.sh before


# What to start at boot?
DEFE=$(get_ee_setting ee_boot)

case "$DEFE" in
"Retroarch")
	rm -rf /var/lock/start.retro
	touch /var/lock/start.retro
	systemctl start retroarch
	;;
*)
	rm /var/lock/start.games
	touch /var/lock/start.games
    systemctl start emustation
	;;
esac

# write logs to tmpfs not the sdcard
rm -rf /storage/.config/emuelec/logs
mkdir /tmp/logs
ln -s /tmp/logs /storage/.config/emuelec/logs

# default to ondemand performance in EmulationStation
normperf

# Enable the PWM for rumble

echo 0 > /sys/class/pwm/pwmchip0/export
echo 1000000 > /sys/class/pwm/pwmchip0/pwm0/period
echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
echo 1000000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle

# Restore last saved brightness
if [ -e /storage/.brightness ]
then
  cat /storage/.brightness > /sys/class/backlight/backlight/brightness
else
  echo 75 >/sys/class/backlight/backlight/brightness
  echo 75 >/storage/.brightness
fi

# run custom_start ending scripts
/storage/.config/custom_start.sh after

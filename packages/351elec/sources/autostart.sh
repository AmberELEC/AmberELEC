#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

# Set max performance mode to start the boot.
maxperf

# write logs to tmpfs not the sdcard
mkdir /tmp/logs
ln -s /storage/roms/gamedata/retroarch/logs/ /tmp/logs/retroarch

# Apply some kernel tuning
sysctl vm.swappiness=1

if [ -e "/storage/.newcfg" ]
then
  # Restore overclock setting
  OVERCLOCK_SETTING=$(get_ee_setting overclock)
  OVERCLOCK_STATE=$((grep "\-oc.dtb" /flash/boot.ini >/dev/null 2>&1 && echo 1) || echo 0)
  if [ ! "${OVERCLOCK_STATE}" == "${OVERCLOCK_SETTING}" ]
  then
    echo -en '\e[0;0H\e[37mRestoring overclock...\e[0m' >/dev/console
    if [ "${OVERCLOCK_SETTING}" = "1" ]
    then
      /usr/bin/351elec-overclock on
    else
      /usr/bin/351elec-overclock off
    fi
    sleep 1
    systemctl reboot
  fi
fi

# Restore config if backup exists
BPATH="/storage/roms/backup/"
BACKUPFILE="${BPATH}/351ELEC_BACKUP.zip"

if [ -e "${BPATH}/.restore" ]
then
  if [ -f "${BACKUPFILE}" ]; then
    echo -en '\e[0;0H\e[37mRestoring backup and rebooting...\e[0m' >/dev/console
    unzip -o ${BACKUPFILE} -d /
    rm ${BACKUPFILE}
    systemctl reboot
  fi
fi

# Restore identity if it exists from a factory reset
IDENTITYFILE="${BPATH}/identity.tar.gz"

if [ -e "${IDENTITYFILE}" ]
then
  cd /
  tar -xvzf ${IDENTITYFILE} >${BPATH}/restore.log
  rm ${IDENTITYFILE}
  echo -en '\e[0;0H\e[37mIdentity restored, rebooting...\e[0m' >/dev/console
  systemctl reboot
fi

if [ ! -e "/storage/.newcfg" ]
then
  echo -en '\e[0;0H\e[37mPlease wait, initializing system...\e[0m' >/dev/console
fi

# It seems some slow SDcards have a problem creating the symlink on time :/
CONFIG_DIR="/storage/.emulationstation"
CONFIG_DIR2="/storage/.config/emulationstation"

if [ ! -L "$CONFIG_DIR" ]; then
  ln -sf $CONFIG_DIR2 $CONFIG_DIR
fi

# Create the distribution directory if it doesn't exist, sync it if it does
if [ ! -d "/storage/.config/distribution" ]
then
  rsync -a /usr/config/distribution /storage/.config/distribution &
else
  rsync -a --delete --exclude=custom_start.sh --exclude=locale --exclude=configs --exclude=ports \
    /usr/config/distribution/ /storage/.config/distribution &
fi

# Clean cache garbage when boot up.
rsync -a --delete /tmp/cache/ /storage/.cache/cores/ &

# Copy in build metadata
rsync /usr/config/.OS* /storage/.config &

# Copy remappings
rsync --ignore-existing -raz /usr/config/remappings/* /storage/remappings/ &

# Copy OpenBOR
rsync --ignore-existing -raz /usr/config/openbor /storage &

## Not needed any more
## copy bezel if it doesn't exists
#if [ ! -f "/storage/roms/bezels/default.cfg" ]; then
#  mkbezels/
#  rsync --ignore-existing -raz /usr/share/retroarch-overlays/bezels/* /storage/roms/bezels/ &
#fi
##

# Copy pico-8
cp -f  "/usr/bin/pico-8.sh" "/storage/roms/pico-8/Start Pico-8.sh" &

# Move ports to the FAT volume
rsync -a --exclude gamelist.xml /usr/config/distribution/ports/* /storage/roms/ports &

# Wait for the rsync processes to finish.
wait

if [ ! -e "/storage/roms/ports/gamelist.xml" ]
then
  cp -f /usr/config/distribution/ports/gamelist.xml /storage/roms/ports
fi
rm -rf /storage/.config/distribution/ports

# End Automatic updates

# Set video mode, this has to be done before starting ES
#DEFE=$(get_ee_setting ee_videomode)
#
#if [ "${DEFE}" != "Custom" ]; then
#    [ ! -z "${DEFE}" ] && echo "${DEFE}" > /sys/class/display/mode
#fi
#
#if [ -s "/storage/.config/EE_VIDEO_MODE" ]; then
#        echo $(cat /storage/.config/EE_VIDEO_MODE) > /sys/class/display/mode
#elif [ -s "/flash/EE_VIDEO_MODE" ]; then
#        echo $(cat /flash/EE_VIDEO_MODE) > /sys/class/display/mode
#fi

# finally we correct the FB according to video mode
/usr/bin/setres.sh

# handle SSH
DEFE=$(get_ee_setting ee_ssh.enabled)

case "$DEFE" in
"0")
	systemctl stop sshd
	rm /storage/.cache/services/sshd.conf
	;;
"1")
	mkdir -p /storage/.cache/services/
	touch /storage/.cache/services/sshd.conf
	systemctl start sshd
	;;
*)
	systemctl stop sshd
	rm /storage/.cache/services/sshd.conf
	;;
esac

# handle SAMBA
DEFE=$(get_ee_setting ee_samba.enabled)

case "$DEFE" in
"0")
	systemctl stop nmbd
	systemctl stop smbd
	rm /storage/.cache/services/smb.conf
	;;
"1")
	mkdir -p /storage/.cache/services/
	touch /storage/.cache/services/smb.conf
	systemctl start nmbd
	systemctl start smbd
	;;
*)
	systemctl stop nmbd
	systemctl stop smbd
	rm /storage/.cache/services/smb.conf
	;;
esac

# Show splash Screen
/usr/bin/show_splash.sh intro &

# Migrate game data to the games partition
GAMEDATA="/storage/roms/gamedata"
if [ ! -d "${GAMEDATA}" ]
then
  mkdir -p "${GAMEDATA}"
fi

for GAME in ppsspp dosbox scummvm retroarch hatari openbor opentyrian
do
  # Migrate or copy fresh data
  if [ ! -d "${GAMEDATA}/${GAME}" ]
  then
    if [ -d "/storage/.config/${GAME}" ]
    then
      mv "/storage/.config/${GAME}" "${GAMEDATA}/${GAME}"
    else
      rsync -a "/usr/config/${GAME}/" "${GAMEDATA}/${GAME}/"
    fi
  fi

  # Link the original location to the new data location
  if [ ! -L "/storage/.config/${GAME}" ]
  then
    rm -rf "/storage/.config/${GAME}" 2>/dev/null
    ln -sf "${GAMEDATA}/${GAME}" "/storage/.config/${GAME}"
  fi
done

# Covers drastic
if [ ! -d "${GAMEDATA}/drastic" ]
then
  if [ -d "/storage/drastic" ]
  then
    mv "/storage/drastic" "${GAMEDATA}/drastic"
  else
    mkdir "${GAMEDATA}/drastic"
  fi
fi

if [ ! -L "/storage/drastic" ]
then
  rm -rf "/storage/drastic" 2>/dev/null
  ln -sf "${GAMEDATA}/drastic" "/storage/drastic"
fi

# Controller remaps
if [ ! -d "${GAMEDATA}/remappings" ]
then
  if [ -d "/storage/remappings" ]
  then
    mv "/storage/remappings" "${GAMEDATA}/remappings"
  else
    cp -rf "/usr/config/remappings" "${GAMEDATA}/remappings"
  fi
fi

if [ ! -L "/storage/remappings" ]
then
   rm -rf "/storage/remappings" 2>/dev/null
   ln -sf "${GAMEDATA}/remappings" "/storage/remappings"
fi

# Migrate pico-8 binaries if they exist
if [ -e "/storage/roms/ports/pico-8/pico8_dyn" ]
then
  if [ ! -d "/storage/roms/pico-8" ]
  then
    mkdir -p "/storage/roms/pico-8"
  fi
  mv "/storage/roms/ports/pico-8/"* "/storage/roms/pico-8"
  rm -rf "/storage/roms/ports/pico-8" &
fi

## Only call postupdate once after an UPDATE
if [ "UPDATE" == "$(cat /storage/.config/boot.hint)" ]; then
        /usr/bin/postupdate.sh
	echo "OK" > /storage/.config/boot.hint
fi

sync &

# run custom_start before FE scripts
/storage/.config/custom_start.sh before

# default to ondemand performance in EmulationStation
normperf

# Restore last saved brightness
BRIGHTNESS=$(get_ee_setting system.brightness)
if [[ ! "${BRIGHTNESS}" =~ [0-9] ]]
then
  BRIGHTNESS=255
fi
BRIGHTNESS=$(printf "%.0f" ${BRIGHTNESS})
echo ${BRIGHTNESS} > /sys/class/backlight/backlight/brightness
set_ee_setting system.brightness ${BRIGHTNESS}

# If the WIFI adapter isn't enabled, disable it on startup
# to soft block the radio and save a bit of power.
if [ "$(get_ee_setting wifi.enabled)" == "0" ]
then
  connmanctl disable wifi
fi

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

# run custom_start ending scripts
/storage/.config/custom_start.sh after


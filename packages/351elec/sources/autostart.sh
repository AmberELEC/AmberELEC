#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

if [ ! -d "/storage/roms" ]
then
  mkdir /storage/roms
fi

UPDATE_ROOT=/storage/.update

if [ ! "$(/usr/bin/mount 2>/dev/null| grep [r]oms)" ]
then
  rm -rf /storage/roms/*
  /usr/bin/mount -o umask=000 /dev/mmcblk0p3 /storage/roms
fi

if [ ! -d "/storage/roms/update" ]
then
  /usr/bin/mkdir -p /storage/roms/update &>/dev/null
fi

/usr/bin/mountpoint -q /storage/roms &>/dev/null
if [ $? == "0" ]
then
  /usr/bin/mkdir -p "$UPDATE_ROOT" &>/dev/null
  /usr/bin/mount --bind /storage/roms/update "$UPDATE_ROOT" &>/dev/null
fi

# It seems some slow SDcards have a problem creating the symlink on time :/
CONFIG_DIR="/storage/.emulationstation"
CONFIG_DIR2="/storage/.config/emulationstation"

if [ ! -L "$CONFIG_DIR" ]; then
ln -sf $CONFIG_DIR2 $CONFIG_DIR
fi

# Automatic updates
rsync -a --delete --exclude=custom_start.sh --exclude=drastic.sh /usr/config/emuelec/scripts/ /storage/.config/emuelec/scripts
cp /usr/config/EE_VERSION /storage/.config

# Copy in any new PPSSPP INIs from git
rsync --ignore-existing -raz /usr/config/ppsspp/PSP/SYSTEM/*.ini /storage/.config/ppsspp/PSP/SYSTEM

# Copy remappings
rsync --ignore-existing -raz /usr/config/remappings/* /storage/remappings/

# Copy OpenBOR
rsync --ignore-existing -raz /usr/config/openbor /storage

# Move ports to the FAT volume
rsync -a --exclude gamelist.xml /usr/config/emuelec/ports/* /storage/roms/ports
if [ ! -e "/storage/roms/ports/gamelist.xml" ]
then
  cp /usr/config/emuelec/ports/gamelist.xml /storage/roms/ports
fi
rm -rf /usr/config/emuelec/ports

# End Automatic updates

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
	   atari800 atarilynx atarist atomiswave bios c128 c16                    \
	   c64 capcom coleco cps1 cps2 cps3 daphne daphne/roms daphne/sound       \
	   dreamcast eduke famicom fbneo fds gameandwatch gamegear gb gba gbc     \
	   genesis gw intellivision mame mastersystem megadrive megadrive-japan   \
	   mplayer msx msx2 n64 naomi nds neocd neogeo nes ngp ngpc odyssey       \
           openbor pcengine pc pcenginecd pcfx pico-8 psp psx saturn sc-3000      \
	   scummvm sega32x segacd sfc sg-1000 sgfx snes tg16 tg16cd tic-80 uzebox \
	   vectrex vic20 videopac virtualboy wonderswan wonderswancolor x68000    \
	   zx81 zxspectrum ports ports/VVVVVV ports/quake ports/diablo ports/doom \
	   ports/doom2 ports/cannonball ports/CaveStory ports/reminiscence        \
	   ports/xrick ports/opentyrian ports/cgenius ports/cgenius/games
do
  if [ ! -d "/storage/roms/${dir}" ]; then
    mkdir -p "/storage/roms/${dir}"
    chown root:root "/storage/roms/${dir}"
    chmod 0777 "/storage/roms/${dir}"
  fi
done

# Copy pico-8
cp "/usr/bin/pico-8.sh" "/storage/roms/pico-8/Start Pico-8.sh"

# Restore config if backup exists
BPATH="/storage/roms/backup/"
BACKUPFILE="${BPATH}/351ELEC_BACKUP.zip"

if [ -e "${BPATH}/.restore" ]
then
  if [ -f "${BACKUPFILE}" ]; then
    message_stream "Restoring backup..." .02
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
  message_stream "Identity restored...rebooting..." .02
  systemctl reboot
fi

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

# Migrate game data to the games partition
GAMEDATA="/storage/roms/gamedata"
if [ ! -d "${GAMEDATA}" ]
then
  mkdir -p "${GAMEDATA}"
fi

for GAME in ppsspp dosbox scummvm retroarch hatari openbor opentyrian residualvm
do
  # Migrate or copy fresh data
  if [ ! -d "${GAMEDATA}/${GAME}" ]
  then
    if [ -d "/storage/.config/${GAME}" ]
    then
      mv "/storage/.config/${GAME}" "${GAMEDATA}/${GAME}"
    else
      cp -rf "/usr/config/${GAME}" "${GAMEDATA}/${GAME}"
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
  rm -rf "/storage/roms/ports/pico-8"
fi

# Show splash Screen 
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

# Restore last saved brightness
if [ -e /storage/.brightness ]
then
  cat /storage/.brightness > /sys/class/backlight/backlight/brightness
else
  echo 75 >/sys/class/backlight/backlight/brightness
  echo 75 >/storage/.brightness
fi

clear

# run custom_start ending scripts
/storage/.config/custom_start.sh after


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
      /usr/bin/amberelec-overclock on
    else
      /usr/bin/amberelec-overclock off
    fi
    sleep 1
    systemctl reboot
  fi
fi

# Restore config if backup exists
BPATH="/storage/roms/backup/"
BACKUPFILE="${BPATH}/AmberELEC_BACKUP.zip"

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

# Setup default artbook symlink for use in ES
DEFAULT_THEME_USR=/usr/config/emulationstation/themes/es-theme-art-book-next/
DEFAULT_THEME_STORAGE=/storage/.config/emulationstation/themes/es-theme-art-book-next-default
if [ ! -e "$DEFAULT_THEME_STORAGE" ]; then
  ln -s $DEFAULT_THEME_USR $DEFAULT_THEME_STORAGE
fi

# Create the distribution directory if it doesn't exist, sync it if it does
if [ ! -d "/storage/.config/distribution" ]
then
  rsync -a /usr/config/distribution/ /storage/.config/distribution/ &
else
  rsync -a --delete --exclude=custom_start.sh --exclude=configs --exclude=lzdoom.ini --exclude=gzdoom.ini --exclude=raze.ini --exclude=ecwolf.cfg /usr/config/distribution/ /storage/.config/distribution/ &
fi

# Clean cache garbage when boot up.
rsync -a --delete /tmp/cache/ /storage/.cache/cores/ &

# Copy in build metadata
rsync /usr/config/.OS* /storage/.config &

# Copy remappings
rsync --ignore-existing -raz /usr/config/remappings/* /storage/remappings/ &

# Move ports to the GAMES volume
rsync -a --exclude gamelist.xml /usr/config/ports/* /storage/roms/homebrew &

# Sync ES locale if missing
if [ ! -d "/storage/.config/emulationstation/locale" ]
then
  rsync -a /usr/config/locale/ /storage/.config/emulationstation/locale/ &
fi

# Wait for the rsync processes to finish.
wait

if [ ! -e "/storage/roms/homebrew/gamelist.xml" ]
then
  cp -f /usr/config/ports/gamelist.xml /storage/roms/homebrew
fi

# End Automatic updates

# restart volume control service
systemctl stop volume; systemctl start volume &

# start services
/usr/bin/startservices.sh &

# Show splash Screen
/usr/bin/show_splash.sh intro &

# Migrate game data to the games partition
GAMEDATA="/storage/roms/gamedata"
if [ ! -d "${GAMEDATA}" ]
then
  mkdir -p "${GAMEDATA}"
fi

for GAME in ppsspp dosbox retroarch hatari
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

# Create drastic gamedata folder
if [ ! -d "${GAMEDATA}/drastic" ]
then
  mkdir -p "${GAMEDATA}/drastic"
  ln -sf "${GAMEDATA}/drastic" "/storage/drastic"
fi

# Controller remaps
if [ ! -d "${GAMEDATA}/remappings" ]
then
  if [ -d "/storage/remappings" ]
  then
    mv "/storage/remappings" "${GAMEDATA}/remappings"
  else
    mkdir -p "${GAMEDATA}/remappings"
  fi
fi

if [ ! -L "/storage/remappings" ]
then
   rm -rf "/storage/remappings" 2>/dev/null
   ln -sf "${GAMEDATA}/remappings" "/storage/remappings"
fi

## Only call postupdate once after an UPDATE
if [ "UPDATE" == "$(cat /storage/.config/boot.hint)" ]; then
	echo -en '\e[0;0H\e[37mExecuting postupdate...\e[0m' >/dev/console
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
  BRIGHTNESS=100
fi

# Ensure user doesn't get "locked out" with super low brightness
if [[ "${BRIGHTNESS}" -lt "3" ]]
then
  BRIGHTNESS=3
fi
BRIGHTNESS=$(printf "%.0f" ${BRIGHTNESS})
echo ${BRIGHTNESS} > /sys/class/backlight/backlight/brightness
set_ee_setting system.brightness ${BRIGHTNESS}

# If the WIFI adapter isn't enabled, disable it on startup
# to soft block the radio and save a bit of power.
if [ "$(get_ee_setting wifi.enabled)" == "0" ]
then
  connmanctl disable wifi
  # Power down the WIFI device
  if [ "$(cat /sys/firmware/devicetree/base/model)" == "Anbernic RG552" ]; then
    echo 0 > /sys/class/gpio/gpio113/value
  elif [ "$(cat /sys/firmware/devicetree/base/model)" == "Anbernic RG351P" ]; then
    echo 0 > /sys/class/gpio/gpio110/value
  else
    echo 0 > /sys/class/gpio/gpio5/value
  fi
fi

if [ "$(get_ee_setting wifi.internal.disabled)" == "1" ]
then
  /usr/bin/batocera-internal-wifi disable-no-refresh
fi


if [ "$(cat /sys/firmware/devicetree/base/model)" == "Anbernic RG351MP" ]; then
	amixer -c 0 cset iface=MIXER,name='Playback Path' SPK_HP
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

clear > /dev/console

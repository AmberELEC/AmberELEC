#!/bin/bash

case $1 in
   pre)
    # Store system brightness
    cat /sys/class/backlight/backlight/brightness > /storage/.brightness
    # Store sound state. Try to avoid having max volume after resume
    alsactl store -f /tmp/asound.state
    # workaround until dwc2 is fixed
    modprobe -r dwc2
    # stop hotkey service
    systemctl stop headphones
    # stop volume service
    systemctl stop volume
    # This file is used by ES to determine if we just woke up from sleep
    touch /run/.last_sleep_time
    ;;
   post)
    # Restore pre-sleep sound state
    alsactl restore -f /tmp/asound.state
    # workaround until dwc2 is fixed
    (echo $(lsmod 2>/dev/null) | grep dwc2 >/dev/null) && modprobe -r dwc2
    modprobe -i dwc2
    # Restore system brightness
    cat /storage/.brightness > /sys/class/backlight/backlight/brightness
    # re-detect and reapply sound, brightness and hp state
    systemctl start headphones
    # start volume service
    systemctl start volume
    ;;
esac

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
    ;;
   post)
    # Restore pre-sleep sound state
    alsactl restore -f /tmp/asound.state
    # workaround until dwc2 is fixed
    (echo $(lsmod 2>/dev/null) | grep dwc2 >/dev/null) && modprobe -r dwc2
    modprobe -i dwc2
    # Restore system brightness
    cat /storage/.brightness > /sys/class/backlight/backlight/brightness

    # Touch 'resume_time' file to indicate date when last resume occurred (can be used to fix screensaver ES issue)
    touch /run/.resume_time

    # re-detect and reapply sound, brightness and hp state
    systemctl start headphones
        ;;
esac
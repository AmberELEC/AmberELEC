#!/bin/bash

case $1 in
   pre)
    # Store system brightness
    cat /sys/class/backlight/backlight/brightness > /storage/.brightness
    # unload esp8090 WiFi module
    # Store sound state. Try to avoid having max volume after resume
    alsactl store -f /tmp/asound.state
    # workaround until dwc2 is fixed
    modprobe -r dwc2
    # stop hotkey service
    systemctl stop odroidgoa-headphones.service
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
    systemctl start odroidgoa-headphones.service
	;;
esac

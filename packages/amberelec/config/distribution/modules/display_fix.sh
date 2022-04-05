#!/bin/bash

text_viewer -w -y -t "RG351MP/V Display Fix" -m "\nThis fix will remove flickering from some devices, don't apply this fix unless you've an issue with your display.\n\nWould you like to apply the display fix?\n\nNote: YES will apply the display fix, NO will restore the original AmberELEC setting.\n\nPlease, reboot your device after applying this fix."
response=$?
case $response in
  0)
    mount -oremount,rw /flash
    cp -f /usr/share/bootloader/rk3326*.dtb /flash
    mount -oremount,ro /flash
  ;;
  21)
    mount -oremount,rw /flash
    cp -f /usr/share/timing_fix/rk3326*.dtb /flash
    mount -oremount,ro /flash
  ;;
esac

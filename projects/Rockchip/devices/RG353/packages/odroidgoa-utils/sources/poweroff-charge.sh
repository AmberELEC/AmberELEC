#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later

# Called after shutdown.target, umount.target and final.target have completed.
# Use the native bootloader charging mode when an RG353 charger is present.
case "$(tr -d '\000' < /proc/device-tree/model)" in
  "Anbernic RG353M"|"Anbernic RG353P"|"Anbernic RG353V")
    for supply in ac usb; do
      if [ "$(cat /sys/class/power_supply/${supply}/online 2>/dev/null)" = "1" ]; then
        SYSTEMCTL_SKIP_AUTO_KEXEC=1 SYSTEMCTL_SKIP_AUTO_SOFT_REBOOT=1 \
          /usr/bin/systemctl --force --reboot-argument=charge reboot && exit 0
        break
      fi
    done
    ;;
esac

exec /usr/bin/systemctl --force poweroff

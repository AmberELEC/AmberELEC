#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present AmberELEC

set -e
SYSTEM_ROOT="${SYSTEM_ROOT:-}"
BOOT_ROOT="${BOOT_ROOT:-/flash}"
BOOT_PART=$(awk -v mountpoint="${BOOT_ROOT}" '$2 == mountpoint { print $1 }' /proc/mounts)
STORAGE_PART=$(awk '$2 == "/storage" { print $1 }' /proc/mounts)
BOOT_DISK="${BOOT_PART%p3}"

# This target boots from SD; never update the Android loader on eMMC.
case "$(tr -d '\0' < /sys/firmware/devicetree/base/model)" in
  "Anbernic RG353M"|"Anbernic RG353V/VS") ;;
  *) exit 1 ;;
esac
[ "${BOOT_PART}" != "${BOOT_DISK}" ]
[ "$(cat /sys/class/block/${BOOT_DISK##*/}/device/type)" = "SD" ]
[ "${STORAGE_PART}" = "${BOOT_DISK}p4" ]
# The generated boot configuration uses UUIDs; blkid is not in the initramfs.
BOOT_UUID=""
DISK_UUID=""
for arg in $(cat /proc/cmdline); do
  case "$arg" in
    boot=UUID=*) BOOT_UUID="${arg#boot=UUID=}" ;;
    disk=UUID=*) DISK_UUID="${arg#disk=UUID=}" ;;
  esac
done
[ -n "${BOOT_UUID}" ] && [ -n "${DISK_UUID}" ]

BOOTLOADER_DIR="${SYSTEM_ROOT}/usr/share/bootloader"
[ "$(stat -t "${BOOTLOADER_DIR}/idbloader.img" | awk '{print $2}')" -lt 8355840 ]
[ "$(stat -t "${BOOTLOADER_DIR}/u-boot.itb" | awk '{print $2}')" -le 4194304 ]
[ "$(stat -t "${BOOTLOADER_DIR}/resource.img" | awk '{print $2}')" -le 4194304 ]

mount -o remount,rw "${BOOT_ROOT}"
trap 'sync; mount -o remount,ro "${BOOT_ROOT}"' EXIT
mkdir -p "${BOOT_ROOT}/extlinux"
cp "${BOOTLOADER_DIR}"/rk3566-353*.dtb "${BOOT_ROOT}/"
sed -e "s/@BOOT_UUID@/${BOOT_UUID}/g" -e "s/@DISK_UUID@/${DISK_UUID}/g" \
  "${BOOTLOADER_DIR}/extlinux/extlinux.conf" > "${BOOT_ROOT}/extlinux/extlinux.conf"

dd if="${BOOTLOADER_DIR}/idbloader.img" of="${BOOT_DISK}" bs=32k seek=1 conv=fsync,notrunc
dd if="${BOOTLOADER_DIR}/u-boot.itb" of="${BOOT_DISK}" bs=64k seek=128 conv=fsync,notrunc
dd if="${BOOTLOADER_DIR}/resource.img" of="${BOOT_DISK}" bs=64k seek=192 conv=fsync,notrunc
echo UPDATE > /storage/.config/boot.hint

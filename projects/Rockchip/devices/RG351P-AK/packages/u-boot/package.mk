# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="u-boot"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://www.denx.de/wiki/U-Boot"
PKG_DEPENDS_TARGET="toolchain swig:host"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p arch/$TARGET_KERNEL_ARCH/boot/dts
  mkdir -p $INSTALL/usr/share/bootloader
  tar -xvzf rk3326-odroidgo2-linux-dtb.tar.gz
  cp rk3326-odroidgo2-linux-dtb/rk3326-odroidgo2-linux.dtb arch/$TARGET_KERNEL_ARCH/boot/dts
  cp rk3326-odroidgo2-linux-dtb/rk3326-odroidgo2-linux-v11.dtb arch/$TARGET_KERNEL_ARCH/boot/dts

  # Always install the update script
  find_file_path bootloader/update.sh && cp -av ${FOUND_PATH} $INSTALL/usr/share/bootloader

  # Always install the canupdate script
  if find_file_path bootloader/canupdate.sh; then
    cp -av ${FOUND_PATH} $INSTALL/usr/share/bootloader
    sed -e "s/@PROJECT@/${DEVICE:-$PROJECT}/g" \
        -i $INSTALL/usr/share/bootloader/canupdate.sh
  fi
}

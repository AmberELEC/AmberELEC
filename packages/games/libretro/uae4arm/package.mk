# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="uae4arm"
PKG_VERSION="276979efa4f862d1f84afeff5a2e794de4744024"
PKG_SHA256="97a793a6624055cb99c83ca0202b0acd9403bab8c9e16f3dff85d0fdccb944ff"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Chips-fr/uae4arm-rpi"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain flac mpg123"
PKG_LONGDESC="Port of uae4arm for libretro (rpi/android)"
PKG_TOOLCHAIN="make"

make_target() {
  if [ "${DEVICE}" = "RG552" ]; then
    make -f Makefile.libretro platform=rpi4_aarch64
  else
    make -f Makefile.libretro platform=rpi3_aarch64
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp uae4arm_libretro.so ${INSTALL}/usr/lib/libretro/
}

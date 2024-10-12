# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="bluemsx"
PKG_VERSION="b83fe4b699d4a2682a57ba442f78e8690af2ac3a"
PKG_SHA256="640c58c8db4bf5fbd16fa3f90e32032d7f3641626eb06b9cf524037318576f49"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/blueMSX-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Port of blueMSX to the libretro API."
PKG_TOOLCHAIN="make"

make_target() {
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp bluemsx_libretro.so ${INSTALL}/usr/lib/libretro/
}

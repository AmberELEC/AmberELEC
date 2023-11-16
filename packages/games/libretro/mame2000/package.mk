# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mame2000"
PKG_VERSION="1472da3a39ab14fff8325b1f51a1dfdb8eabb5c8"
PKG_SHA256="e70d596045b9753084329caee49767e0ca1fb2567657a6a1fbeb3b486c594df9"
PKG_LICENSE="MAME"
PKG_SITE="https://github.com/libretro/mame2000-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="MAME - Multiple Arcade Machine Emulator"
PKG_TOOLCHAIN="make"

make_target() {
  make WANT_LIBCO=0
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mame2000_libretro.so ${INSTALL}/usr/lib/libretro/
}
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="gpsp"
PKG_VERSION="541adc9e1c6c9328c07058659594d6300ae0fa19"
PKG_SHA256="089389a3e97b239a8e22278820d11f4a94af4c1df1a618df82ccd093ed054d56"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/gpsp"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="gameplaySP is a Gameboy Advance emulator for Playstation Portable"
PKG_TOOLCHAIN="make"

make_target() {
  if [ "${ARCH}" == "arm" ]; then
    make CC=${CC} platform=unix
  else
    make CC=${CC} platform=arm64
  fi  
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp gpsp_libretro.so ${INSTALL}/usr/lib/libretro/
}

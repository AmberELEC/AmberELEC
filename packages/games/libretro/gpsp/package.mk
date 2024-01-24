# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="gpsp"
PKG_VERSION="9fc117ef5c719047818513c7e394c24371cb1dbd"
PKG_SHA256="3a689c361c2766bca8eb1f3ad5191ce126f046ab45d8f2b3c73ac1dd4ccdad54"
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

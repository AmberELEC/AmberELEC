# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="gpsp"
PKG_VERSION="85a2ac6c911ffcc77cf1bab418c78fe5218c0b1a"
PKG_SHA256="dd38d602ea9919445873b290e28310aebe61272bec63af0f7f919ba494e06795"
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

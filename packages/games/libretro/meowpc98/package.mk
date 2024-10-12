# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="meowpc98"
PKG_VERSION="06e01c29509989e66caebcd6f862ea6ca2cea46e"
PKG_SHA256="3ca649a57e12a5f38e9ab96d02a80dee7c43a4f0a3b57868c4dc3c4c5c14d7ba"
PKG_LICENSE="Unknown"
PKG_SITE="https://github.com/libretro/libretro-meowPC98"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Neko Project 2 (PC98 emulator) port for libretro/RetroArch"
PKG_TOOLCHAIN="make"

make_target() {
  make -C libretro -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp libretro/nekop2_libretro.so ${INSTALL}/usr/lib/libretro/
}

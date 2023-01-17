# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="bsnes"
PKG_VERSION="dabf6679024124b2f819c79f279dbb85a5263255"
PKG_SHA256="7f99234feb03ed2060d7a27304b4cc28735c380e217a8c92d8eb90559ec427ce"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/bsnes-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="bsnes is a Super Nintendo (SNES) emulator focused on performance, features, and ease of use."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i 's/\-O[23]/-Ofast/' ${PKG_BUILD}/Makefile
  sed -i 's/CFLAGS :=//' ${PKG_BUILD}/Makefile
  sed -i 's/CXXFLAGS :=//' ${PKG_BUILD}/Makefile
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -v bsnes_libretro.so ${INSTALL}/usr/lib/libretro
}

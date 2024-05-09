# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="bsnes"
PKG_VERSION="b2f3ca10ee48546ad267719fb21bcf6b503d91e6"
PKG_SHA256="2475e833b8f643aee46927560c9484c6dd7e0e5e8b55740004d98d892c5add89"
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

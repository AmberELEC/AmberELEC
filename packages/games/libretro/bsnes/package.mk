# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="bsnes"
PKG_VERSION="e5c7772582a0ea564eed79baad9ab7955225c062"
PKG_SHA256="5ac9c8dc67b25a5c2ebcc315114e000a414421de5c7df2306ac6cd4e1aa255b9"
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

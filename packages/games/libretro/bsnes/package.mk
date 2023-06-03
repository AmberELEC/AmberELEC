# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="bsnes"
PKG_VERSION="3c1868250b90f5961eccd044a780489c29e4c40f"
PKG_SHA256="a4d2d098ceaa93e67c6fd33445e429d541b5e37e3f972a438618ca2da2c16c46"
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

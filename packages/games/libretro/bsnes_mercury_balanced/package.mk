# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="bsnes_mercury_balanced"
PKG_VERSION="fb9a41fe9bc230a07c4506cad3cbf21d3fa635b4"
PKG_SHA256="5217be2136f120f2ed2aa3bd5225c039c6e45d618b88ceed1f607d8e3b3d79b6"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/bsnes-mercury"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Fork of bsnes with various performance improvements."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i 's/\-O[23]/-Ofast/' ${PKG_BUILD}/Makefile
  sed -i 's/CFLAGS :=//' ${PKG_BUILD}/Makefile
  sed -i 's/CXXFLAGS :=//' ${PKG_BUILD}/Makefile
}

make_target() {
  make PROFILE=balanced
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp -f bsnes_mercury_balanced_libretro.so ${INSTALL}/usr/lib/libretro
}

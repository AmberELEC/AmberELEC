# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="bsnes_mercury_balanced"
PKG_VERSION="60c204ca17941704110885a815a65c740572326f"
PKG_SHA256="906d88cfe52a1561fb7b026beba96467a4a827ed538a069fbba9249db11ac81a"
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

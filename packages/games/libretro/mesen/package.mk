# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mesen"
PKG_VERSION="d25d60fc190f3f7603a1113ef1e11d9da65b7583"
PKG_SHA256="f94cf7195ed1937189442c2f0241bc682ce4bb6c3e5a17b611968023af1f65d2"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/Mesen"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Mesen is a cross-platform (Windows & Linux) NES/Famicom emulator built in C++"
PKG_TOOLCHAIN="make"

pre_make_target() {
  sed -i 's/\-O[23]//' Libretro/Makefile
}

make_target() {
  make -C Libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp Libretro/mesen_libretro.so ${INSTALL}/usr/lib/libretro
}

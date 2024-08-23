# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mesen"
PKG_VERSION="91db6be681f70b2080525c267af6132555323ea1"
PKG_SHA256="b5951625aeaf2549e77b6e6d1605ce66a3fd8615d4726ffa0bc19b8b9133ade8"
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

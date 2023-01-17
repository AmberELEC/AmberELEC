# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mesen-s"
PKG_VERSION="32a7adfb4edb029324253cb3632dfc6599ad1aa8"
PKG_SHA256="17e29212103691a3ae73862cd22c8d1dc6cdbb2b3750eac3dc1687d087d0cc05"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/Mesen-S"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Mesen-S is a cross-platform (Windows & Linux) SNES emulator built in C++"
PKG_TOOLCHAIN="make"

pre_make_target() {
  sed -i 's/\-O[23]//' Libretro/Makefile
}

make_target() {
  make -C Libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp Libretro/mesen-s_libretro.so ${INSTALL}/usr/lib/libretro
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mesen-s"
PKG_VERSION="d4fca31a6004041d99b02199688f84c009c55967"
PKG_SHA256="f9a601bcb518bf750b5674bc3990675245fe3cfae6d824be8fb4bd61d13cecc4"
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

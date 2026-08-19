# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="emuscv"
PKG_VERSION="769ad162db63884222949f2add2a4b56a6499b25"
PKG_SITE="https://gitlab.com/MaaaX-EPOCH84/libretro-emuscv"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="An EPOCH/YENO Super Cassette Vision (1984) home video game emulator for Libretro"
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="-f Makefile.libretro platform=unix"

pre_make_target() {
  export TERM=xterm
  sed -i 's/`sdl2-config --cflags`//g' ${PKG_BUILD}/Makefile.libretro
  sed -i 's/`sdl2-config --libs`/-lSDL2/g' ${PKG_BUILD}/Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/emuscv_libretro.so ${INSTALL}/usr/lib/libretro/
}

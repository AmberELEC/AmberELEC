# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="fake08"
PKG_VERSION="d98376fc41c34e3cd6d3ffc25ae9c2970efd5286"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/jtothebell/fake-08"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A Pico-8 player/emulator for console homebrew"
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="-C platform/libretro"

pre_make_target() {
  sed -i 's|togglePauseMenu();|//togglePauseMenu();|g' ${PKG_BUILD}/source/vm.cpp
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/platform/libretro/fake08_libretro.so ${INSTALL}/usr/lib/libretro/
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="scummvm"
PKG_VERSION="c160631a5dfe8b26f9c0a10fc62a7484a603aef4"
PKG_SHA256="a67499ef0b0cfa75404ff763f0ce6a85973734a4fd5816bb61571000057510f2"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/scummvm/scummvm"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="ScummVM is a program which allows you to run certain classic graphical point-and-click adventure games, provided you already have their data files."

configure_target() {
  :
}

make_target() {
  cd ${PKG_BUILD}/backends/platform/libretro
  make all
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp scummvm_libretro.so ${INSTALL}/usr/lib/libretro/
  mkdir -p ${INSTALL}/usr/share/scummvm
  unzip scummvm.zip -d ${INSTALL}/usr/share/
}

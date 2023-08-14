# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="scummvm"
PKG_VERSION="948f004a783ba8676eb49853dc2f6aadd2fec9e4"
PKG_SHA256="7d27ea6e85c0b7ac9a00534990726b5d7d9e13c25756530b5912ed95501a6c2a"
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

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="scummvm"
PKG_VERSION="f8a9cde69722c417b82503e475c739d937f8a0e2"
PKG_SHA256="7a2db710433076cf24cb4c06497893f069a6bb2e0916e0bdb13eaa0d6d708fe4"
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

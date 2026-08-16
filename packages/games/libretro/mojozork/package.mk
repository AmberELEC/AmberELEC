# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mojozork"
PKG_VERSION="f94c3104aa18036d9ed5f0243814483f82e486cb"
PKG_SHA256="947f26dc4be2c4413b2f70e3b31c23ad1ea84eff8fa331d89619c14acea56f9c"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/icculus/mojozork"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A simple Z-Machine implementation in a single C file"
PKG_TOOLCHAIN="cmake"

pre_configure_target() {
	PKG_CMAKE_OPTS_TARGET+=" -DLIBRETRO=ON "
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/.${TARGET_NAME}/mojozork_libretro.so ${INSTALL}/usr/lib/libretro/
}

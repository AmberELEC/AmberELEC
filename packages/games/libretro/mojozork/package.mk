# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mojozork"
PKG_VERSION="89832e31d9d05c4e81908286b99db21924f3ba1a"
PKG_SHA256="e30b9fea3cb782f4070d149f5c1852021982f6ab991e10704387358f013e9a2c"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/icculus/mojozork"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A simple Z-Machine implementation in a single C file"
PKG_TOOLCHAIN="cmake"

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET+=" -DMOJOZORK_LIBRETRO=ON -DMOJOZORK_STANDALONE_DEFAULT=OFF -DMOJOZORK_MULTIZORK_DEFAULT=OFF "
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/.${TARGET_NAME}/mojozork_libretro.so ${INSTALL}/usr/lib/libretro/
}

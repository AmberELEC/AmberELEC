# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mojozork"
PKG_VERSION="74d3e36ed89a6e44930cd103b9054f9fd8767b99"
PKG_SHA256="8153fbd907f41cf6fe0954e07f6a48e221ca504706b111ab808c7a538ea9f282"
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

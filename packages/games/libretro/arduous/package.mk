# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="arduous"
PKG_VERSION="50c1e48084f003dee582ed5f4f5c0f59eb30bc4c"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/arduous"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="arduous for libretro"
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
  export CXXFLAGS="${CXXFLAGS} -Wno-error=maybe-uninitialized"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp arduous_libretro.so ${INSTALL}/usr/lib/libretro/
}

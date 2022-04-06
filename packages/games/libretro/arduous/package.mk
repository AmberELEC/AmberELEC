# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="arduous"
PKG_VERSION="42b4fe77d676fb78338a6962713144234f4d563b"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/arduous"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="arduous for libretro"
PKG_LONGDESC="arduous for libretro"

PKG_IS_ADDON="no"
PKG_TOOLCHAIN="cmake-make"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CXXFLAGS="$CXXFLAGS -Wno-error=maybe-uninitialized"
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp arduous_libretro.so $INSTALL/usr/lib/libretro/
}

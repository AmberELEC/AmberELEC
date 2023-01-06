# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="prosystem"
PKG_VERSION="da596828a6c65753f771bc9bbea5c428ae73af76"
PKG_SHA256="e5de2e25ede2109355bb5b2a63d19c5c7dc0c1b0922bd5b28c7908a7e13ddfbe"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/prosystem-libretro"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Port of ProSystem to libretro."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp prosystem_libretro.so $INSTALL/usr/lib/libretro/
}

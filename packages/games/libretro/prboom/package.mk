# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="prboom"
PKG_VERSION="1de4411265c717d787b1d512b7f1529314c9c281"
PKG_SHA256="00b2cbaa2ce9ead2d0d23fbf4be7961a60091fd7297ff22e91b60787ac38cd9f"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/libretro-prboom"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro implementation of Doom"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp prboom_libretro.so $INSTALL/usr/lib/libretro/prboom_libretro.so
}

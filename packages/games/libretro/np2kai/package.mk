# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="np2kai"
PKG_VERSION="910ab3f636af8d159c85464029f3e59b1a835374"
PKG_SHA256="7fc2f52d7297b3707b3cc7868fae06d08a32a48d782ade8ab293bd0f7cd399d5"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/AZO234/NP2kai"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Neko Project II kai"
PKG_TOOLCHAIN="make"

make_target() {
  VERSION="${PKG_VERSION:0:7}"
  cd $PKG_BUILD/sdl
  make NP2KAI_VERSION=$VERSION NP2KAI_HASH=$VERSION
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/sdl/np2kai_libretro.so $INSTALL/usr/lib/libretro/
}

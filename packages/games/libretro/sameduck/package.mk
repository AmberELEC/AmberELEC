# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="sameduck"
PKG_VERSION="5cc014b23af963f9e9a77091a1e6ff7a7852e8a7"
PKG_SHA256="ca2a07e36812a838f00a506415b9e30280da9f36ea773011524ff07c5f0f98a9"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/LIJI32/SameBoy"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_GIT_CLONE_BRANCH="SameDuck"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Mega Duck/Cougar Boy emulator written in C"
PKG_TOOLCHAIN="make"

make_target() {
  make -C libretro
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp build/bin/sameduck_libretro.so $INSTALL/usr/lib/libretro/
}

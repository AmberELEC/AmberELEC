# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="puae2021"
PKG_VERSION="ad76cee77577ebdea256378a1be489b3d95cec2a"
PKG_SHA256="1a6c439f9f94ea0ef28cc255f6234ee54aff3a584d19951164934c2375427759"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/libretro-uae"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="WIP libretro port of UAE (P-UAE and libco) Expect bugs"
PKG_LONGDESC="WIP libretro port of UAE (P-UAE and libco) Expect bugs"
PKG_TOOLCHAIN="make"
PKG_GIT_CLONE_BRANCH="2.6.1"

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp puae2021_libretro.so $INSTALL/usr/lib/libretro/
}

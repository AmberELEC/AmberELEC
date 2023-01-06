# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vba-next"
PKG_VERSION="4191e09e2b0fcf175a15348c1fa8a12bbc6320dd"
PKG_SHA256="afbe59106a9709622f0384eed9641224a475842720eb9aefbfc6edff166222b8"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/vba-next"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Optimized port of VBA-M to Libretro. "
PKG_TOOLCHAIN="make"

make_target() {
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp vba_next_libretro.so $INSTALL/usr/lib/libretro/
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vba-next"
PKG_VERSION="2b96fd3a77025f3083daf61126b1852d5e0eace7"
PKG_SHA256="f4007a96d4d1280e7ac8a5552a99233bfa41475dd3a6f5865444107e77430f34"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/vba-next"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Optimized port of VBA-M to Libretro. "
PKG_TOOLCHAIN="make"

make_target() {
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp vba_next_libretro.so ${INSTALL}/usr/lib/libretro/
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vba-next"
PKG_VERSION="2c726f25da75a5600ef5791ce904befe06c4dddd"
PKG_SHA256="d60c8624cf2bca726d09be927e35af3d8e2b78a6be32bbe8ef8b7bc8a955702e"
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

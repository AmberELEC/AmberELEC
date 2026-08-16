# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="fmsx"
PKG_VERSION="f013e213458e06d9df718e4bc4b09d46f88aa899"
PKG_SHA256="ddd0b48489da2498feff8d3613c0471367d23d9fe331d1367ecf199360ee87f8"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/fmsx-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Port of fMSX 4.9 to the libretro API."
PKG_TOOLCHAIN="make"

make_target() {
  make
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp fmsx_libretro.so ${INSTALL}/usr/lib/libretro/
}
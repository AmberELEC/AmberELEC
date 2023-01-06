# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="opera"
PKG_VERSION="8a49bb8877611037438aeb857cb182f41ee0e3a1"
PKG_SHA256="48f94380633808ea01f4608f03ceb6b4b10709ba18abf1df6665f06ae839e7a7"
PKG_LICENSE="LGPL with additional notes"
PKG_SITE="https://github.com/libretro/opera-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Port of 4DO/libfreedo to libretro."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/Makefile
}

make_target() {
  make CC=${CC} CXX=${CXX} AR=${AR}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp opera_libretro.so ${INSTALL}/usr/lib/libretro/
}

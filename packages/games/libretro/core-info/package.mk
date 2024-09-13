# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="core-info"
PKG_VERSION="8f34027736fa7d0154a9568fb6cd1b07010e92fa"
PKG_SHA256="0cac79be7ef1c236aba2ffddf8fecca0c377853e9c7bd7dd1997578cfd87a79d"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/libretro-core-info"
PKG_URL="https://github.com/libretro/libretro-core-info/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain util-linux:host"
PKG_LONGDESC="Mirror of libretro's core info files"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  ${TOOLCHAIN}/bin/rename -v mednafen beetle ${PKG_BUILD}/*.info
  cp ${PKG_BUILD}/*.info ${INSTALL}/usr/lib/libretro/
  cp ${PKG_BUILD}/flycast_libretro.info ${INSTALL}/usr/lib/libretro/flycast2021_libretro.info
  sed -i 's/Flycast/Flycast 2021/g' ${INSTALL}/usr/lib/libretro/flycast2021_libretro.info 
}

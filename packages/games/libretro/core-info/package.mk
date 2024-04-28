# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="core-info"
PKG_VERSION="a0a5dff2a11313ee4a757df689260300a616e38a"
PKG_SHA256="d6acf7428c705719751e18f161e81aa9ca5542044e0807fbadfd7e12e83bf0dd"
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

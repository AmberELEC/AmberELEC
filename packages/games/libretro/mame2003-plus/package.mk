# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mame2003-plus"
PKG_VERSION="9f2dffe5ff58200da8659c9c92d5b4a8980d7b94"
PKG_SHA256="99a5e1b97168cd8f17cf882a6a7609fbe115b036e1daeef8cc3bc762edcbf15b"
PKG_LICENSE="MAME"
PKG_SITE="https://github.com/libretro/mame2003-plus-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="MAME - Multiple Arcade Machine Emulator"
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/Makefile
}

make_target() {
  make ARCH="" CC="${CC}" NATIVE_CC="${CC}" LD="${CC}"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mame2003_plus_libretro.so ${INSTALL}/usr/lib/libretro/
}

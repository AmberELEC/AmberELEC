# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mame2003-plus"
PKG_VERSION="debcb547ea7ae197433142810e99e1313c58cb14"
PKG_SHA256="5e544c5b2cebfea8062d4a26d33a9daa866140d8fe49439f426043454e01990c"
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

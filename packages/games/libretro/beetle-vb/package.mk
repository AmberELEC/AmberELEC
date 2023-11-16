# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-vb"
PKG_VERSION="9d1bd03f21dac7897f65269e1095496331efce8b"
PKG_SHA256="7c3d8fd2f8535be7de6f76be010ec6d34837d7c30caeb0096cae6e5c1e07c442"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-vb-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro implementation of Mednafen VB. (VirtualBoy)"
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/Makefile
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mednafen_vb_libretro.so ${INSTALL}/usr/lib/libretro/beetle_vb_libretro.so
}

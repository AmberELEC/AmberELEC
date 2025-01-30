# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="cap32"
PKG_VERSION="f8f4b0b704c44970001fcf839d8d010e5af435ff"
PKG_SHA256="395ef5e9d0db40ef6e87915fc0d605cf82d19e6cca230c9308f3f97b94dba81c"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/libretro-cap32"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="caprice32 4.2.0 libretro"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp cap32_libretro.so ${INSTALL}/usr/lib/libretro/
}

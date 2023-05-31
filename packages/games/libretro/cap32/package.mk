# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="cap32"
PKG_VERSION="0e3edf8ef45966b375c652efb044ffea46d33200"
PKG_SHA256="aeb8be7b5cccd65c91ce6a58eb274ef26c6d15831fcf0a2f2d3ea04acf58d825"
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

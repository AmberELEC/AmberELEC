# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vecx"
PKG_VERSION="33a8a89e92dbcef047a12e2c02dd55878be02a8f"
PKG_SHA256="0502910863f5574d9fdd5809091b96a2c7d6511b6add44bf8df7464a688dc77a"
PKG_LICENSE="GPLv2|LGPLv2.1"
PKG_SITE="https://github.com/libretro/libretro-vecx"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro adaptation of vecx"
PKG_TOOLCHAIN="make"

make_target() {
  make -f Makefile.libretro HAS_GPU=1 HAS_GLES=1
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp vecx_libretro.so ${INSTALL}/usr/lib/libretro/vecx_libretro.so
}
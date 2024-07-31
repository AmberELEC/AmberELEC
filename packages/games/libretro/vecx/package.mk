# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vecx"
PKG_VERSION="0e48a8903bd9cc359da3f7db783f83e22722c0cf"
PKG_SHA256="71425883be40be36b0cbeb301dda2248de4fbce87227164154b20bffbe5f8a52"
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
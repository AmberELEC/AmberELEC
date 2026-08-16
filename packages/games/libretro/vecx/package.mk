# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vecx"
PKG_VERSION="8f671cc9d737f2890c3ce19e177e2984dcae121f"
PKG_SHA256="cd59fe10619be54c60bb6feb2f48c607291f38bd9638b78ee975081d80450065"
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
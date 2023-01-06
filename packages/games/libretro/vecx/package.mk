# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="vecx"
PKG_VERSION="b5c17bb7fd4a704f58160bc699322a16d0643396"
PKG_SHA256="2ea4e397ed0339f1cb28a0ecd0c1ab74e60f99e0923e6d6bee66aeb4ff2fa4a8"
PKG_LICENSE="GPLv2|LGPLv2.1"
PKG_SITE="https://github.com/libretro/libretro-vecx"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro adaptation of vecx"
PKG_TOOLCHAIN="make"

make_target() {
  make -f Makefile.libretro HAS_GPU=1 HAS_GLES=1
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp vecx_libretro.so $INSTALL/usr/lib/libretro/vecx_libretro.so
}
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

PKG_NAME="mupen64plus-nx"
PKG_VERSION="6e9dcd2cd9d23d3e79eaf2349bf7e9f25ad45bf1"
PKG_SHA256="6f674ce910c85dc5f43e2c3685484d8da8f7e420d4da242f2b524b692da5909f"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mupen64plus-libretro-nx"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain nasm:host $OPENGLES"
PKG_SECTION="libretro"
PKG_SHORTDESC="mupen64plus NX"
PKG_LONGDESC="mupen64plus NX"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-lto"

pre_configure_target() {
  sed -e "s|^GIT_VERSION ?.*$|GIT_VERSION := \" ${PKG_VERSION:0:7}\"|" -i Makefile

if [ $ARCH == "arm" ]; then
  sed -i "s|cortex-a53|cortex-a35|g" Makefile
  PKG_MAKE_OPTS_TARGET+=" platform=odroidgoa"
else
  PKG_MAKE_OPTS_TARGET+=" platform=amlogic64"
fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp mupen64plus_next_libretro.so $INSTALL/usr/lib/libretro/
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-pcfx"
PKG_VERSION="7ed3694713e9bc8ac3e95187ae8350a129f4a46f"
PKG_SHA256="0ee8e25cc5816fe17d710bd5497b9c93af4841b35038f7252124433cbb9694a0"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-pcfx-libretro"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro implementation of Mednafen PC-FX."
PKG_TOOLCHAIN="make"

make_target() {
  if [ "$ARCH" == "i386" -o "$ARCH" == "x86_64" ]; then
    make platform=unix CC=$CC CXX=$CXX AR=$AR
  else
    make platform=armv CC=$CC CXX=$CXX AR=$AR
  fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp mednafen_pcfx_libretro.so $INSTALL/usr/lib/libretro/beetle_pcfx_libretro.so
}

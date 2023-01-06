# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="beetle-lynx"
PKG_VERSION="f8fc53b15a64f804cbb5ff5b8992af31a917c993"
PKG_SHA256="4c649eb8733fe00d75c7933f6207188c161bebb6d73da0a6dce550edca073f2a"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/beetle-lynx-libretro"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="libretro implementation of Mednafen Lynx"
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp mednafen_lynx_libretro.so $INSTALL/usr/lib/libretro/beetle_lynx_libretro.so
}

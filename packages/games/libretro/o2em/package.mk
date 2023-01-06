# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="o2em"
PKG_VERSION="3303cc15e4323280084471f694f6d34c78199725"
PKG_SHA256="b01b126c12e193042ccc13b0c44a6d570962ea4c4256da37512b8137c26bb7e8"
PKG_LICENSE="Artistic License"
PKG_SITE="https://github.com/libretro/libretro-o2em"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Port of O2EM to the libretro API, an Odyssey 2 / VideoPac emulator."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp o2em_libretro.so $INSTALL/usr/lib/libretro/
}

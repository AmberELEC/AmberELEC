# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="snes9x2010"
PKG_VERSION="e86e54624a7910a64a9a744e3734d4067c48d240"
PKG_SHA256="efa887b420c4c2eafd69fde72bdfd9d76820e14864e3cebd83b4e66e463a5051"
PKG_LICENSE="Non-commercial"
PKG_SITE="https://github.com/libretro/snes9x2010"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Snes9x 2010. Port of Snes9x 1.52+ to Libretro (previously called SNES9x Next). Rewritten in C and several optimizations and speedhacks."
PKG_TOOLCHAIN="make"

make_target() {
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp snes9x2010_libretro.so $INSTALL/usr/lib/libretro/
}

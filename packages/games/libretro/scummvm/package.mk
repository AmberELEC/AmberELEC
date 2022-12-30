# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="scummvm"
PKG_VERSION="b2b75baad5f6fe0c72b6c08334b59775cceb1419"
PKG_SHA256="9539af7153d4ac00676a452e14be2f942806479cde1f95db0002bfb7219c2098"
PKG_REV="1"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/scummvm/scummvm"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="Script Creation Utility for Maniac Mansion Virtual Machine"
PKG_LONGDESC="ScummVM is a program which allows you to run certain classic graphical point-and-click adventure games, provided you already have their data files."

pre_configure_target() {
  cd ..
  rm -rf .$TARGET_NAME
  cd ${PKG_BUILD}/backends/platform
  rm -rf libretro
  git clone https://github.com/diablodiab/scummvm-libretro-backend libretro
}

configure_target() {
  :
}

make_target() {
  make -C ${PKG_BUILD}/backends/platform/libretro/build
  cd ${PKG_BUILD}/backends/platform/libretro/aux-data
  ./bundle_aux_data.bash
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp ${PKG_BUILD}/backends/platform/libretro/build/scummvm_libretro.so $INSTALL/usr/lib/libretro/
  mkdir -p $INSTALL/usr/share/scummvm
  unzip ${PKG_BUILD}/backends/platform/libretro/aux-data/scummvm.zip -d $INSTALL/usr/share/
}

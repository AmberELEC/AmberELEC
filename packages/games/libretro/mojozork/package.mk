# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mojozork"
PKG_VERSION="22b638ccd0948d46b7902d45387caaccef35b38a"
PKG_SHA256="9c4e5eab696263c63a3d4599fa78c2fd7cf0952e5f22e684531e94e2fc3f3664"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/icculus/mojozork"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="libretro"
PKG_SHORTDESC="A simple Z-Machine implementation in a single C file"
PKG_TOOLCHAIN="cmake"

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET+=" -DMOJOZORK_LIBRETRO=ON -DMOJOZORK_STANDALONE_DEFAULT=OFF -DMOJOZORK_MULTIZORK_DEFAULT=OFF "
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/mojozork_libretro.info $INSTALL/usr/lib/libretro/
  cp $PKG_BUILD/.$TARGET_NAME/mojozork_libretro.so $INSTALL/usr/lib/libretro/
}

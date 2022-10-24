# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="swanstation"
PKG_VERSION="f6fc4f2192dca855b639a642236ed878f1eb7994"
PKG_SHA256="a43d4fd6683de8427d602891655f6a99be91947d41119fce9934ab7598e10da7"
PKG_ARCH="aarch64"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/swanstation"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain nasm:host $OPENGLES"
PKG_SECTION="libretro"
PKG_SHORTDESC="SwanStation - PlayStation 1, aka. PSX Emulator"
PKG_TOOLCHAIN="cmake"
PKG_BUILD_FLAGS="-lto"

pre_configure_target() {
 PKG_CMAKE_OPTS_TARGET+=" -DCMAKE_BUILD_TYPE=Release -DBUILD_LIBRETRO_CORE=ON "
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/.$TARGET_NAME/swanstation_libretro.so $INSTALL/usr/lib/libretro/
}

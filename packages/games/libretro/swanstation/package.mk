# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="swanstation"
PKG_VERSION="f2e335bfd4751410dfb24d933f762b9a4fd7fdeb"
PKG_SHA256="a86317ffb41d09903f8a311f1f7c8aa6bf1496479eb80ed59066f4af7a98fb0e"
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

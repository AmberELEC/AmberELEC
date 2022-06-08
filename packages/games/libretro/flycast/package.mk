# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="flycast"
PKG_VERSION="b5f1552ed813bd729598cb8a9b5aa5d148453431"
PKG_SITE="https://github.com/flyinghead/flycast"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain $OPENGLES libzip"
PKG_LONGDESC="Flycast is a multi-platform Sega Dreamcast, Naomi and Atomiswave emulator"
PKG_TOOLCHAIN="cmake"

pre_configure_target() {
  sed -i 's/"reicast"/"flycast"/g' $PKG_BUILD/shell/libretro/libretro_core_option_defines.h 
  PKG_CMAKE_OPTS_TARGET="-Wno-dev -DLIBRETRO=ON \
                         -DWITH_SYSTEM_ZLIB=ON \
                         -DUSE_OPENMP=ON \
                         -DUSE_VULKAN=OFF
                         -DUSE_GLES=ON"
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp flycast_libretro.so $INSTALL/usr/lib/libretro/
}

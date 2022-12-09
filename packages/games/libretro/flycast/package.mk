# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="flycast"
PKG_VERSION="98123b921582f13f73da36bab88381b4571758bb"
PKG_SITE="https://github.com/flyinghead/flycast"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain $OPENGLES libzip"
PKG_LONGDESC="Flycast is a multi-platform Sega Dreamcast, Naomi and Atomiswave emulator"
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
  sed -i 's/"reicast"/"flycast"/g' $PKG_BUILD/shell/libretro/libretro_core_option_defines.h 
  PKG_CMAKE_OPTS_TARGET="-Wno-dev \
                         -DCMAKE_RULE_MESSAGES=OFF \
                         -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
                         -DCMAKE_BUILD_TYPE="Release" \
                         -DCMAKE_CXXX_FLAGS_RELEASE="" \
                         -DLIBRETRO=ON \
                         -DWITH_SYSTEM_ZLIB=ON \
                         -DUSE_OPENMP=ON \
                         -DUSE_VULKAN=OFF \
                         -DUSE_GLES=ON"
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp flycast_libretro.so $INSTALL/usr/lib/libretro/
}

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="flycast"
PKG_VERSION="d46b181084f6abe3f31fa00740164ca8cf40751f"
PKG_SITE="https://github.com/flyinghead/flycast"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} libzip zlib"
PKG_LONGDESC="Flycast is a multi-platform Sega Dreamcast, Naomi and Atomiswave emulator"
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
  sed -i 's/"reicast"/"flycast"/g' ${PKG_BUILD}/shell/libretro/libretro_core_option_defines.h
  sed -i 's/RETRO_PIXEL_FORMAT_XRGB8888/RETRO_PIXEL_FORMAT_RGB565/g' ${PKG_BUILD}/shell/libretro/libretro.cpp 
  PKG_CMAKE_OPTS_TARGET="-DCMAKE_RULE_MESSAGES=OFF \
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
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp flycast_libretro.so ${INSTALL}/usr/lib/libretro/
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="tic-80"
PKG_VERSION="e7ebc15a05ede770c96eacd323bdf5e21c99bbda"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/nesbox/TIC-80"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain tic-80:host"
PKG_LONGDESC="TIC-80 is a fantasy computer for making, playing and sharing tiny games."
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_HOST="-DBUILD_PLAYER=OFF \
                     -DBUILD_SOKOL=OFF \
                     -DBUILD_SDL=OFF \
                     -DBUILD_DEMO_CARTS=OFF \
                     -DBUILD_TOUCH_INPUT=OFF \
                     -DBUILD_LIBRETRO=ON \
                     -DCMAKE_BUILD_TYPE=Release \
                     -DCMAKE_RULE_MESSAGES=OFF \
                     -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"

PKG_CMAKE_OPTS_TARGET="-DBUILD_PLAYER=OFF \
                       -DBUILD_SOKOL=OFF \
                       -DBUILD_SDL=OFF \
                       -DBUILD_DEMO_CARTS=OFF \
                       -DBUILD_TOUCH_INPUT=OFF \
                       -DBUILD_LIBRETRO=ON \
                       -DCMAKE_BUILD_TYPE=Release \
                       -DCMAKE_RULE_MESSAGES=OFF \
                       -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/.${TARGET_NAME}/bin/tic80_libretro.so ${INSTALL}/usr/lib/libretro/tic80_libretro.so
}

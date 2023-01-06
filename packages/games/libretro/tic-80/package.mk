# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="tic-80"
PKG_VERSION="6ef9fdabc8542c643c0434f80f72465e71ffc84d"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/nesbox/TIC-80"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="TIC-80 is a fantasy computer for making, playing and sharing tiny games."
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-DBUILD_PLAYER=OFF \
                       -DBUILD_SOKOL=OFF \
                       -DBUILD_SDL=OFF \
                       -DBUILD_DEMO_CARTS=OFF \
                       -DBUILD_TOUCH_INPUT=OFF \
                       -DBUILD_LIBRETRO=ON \
                       -DCMAKE_BUILD_TYPE=Release \
                       -DCMAKE_RULE_MESSAGES=OFF \
                       -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"

pre_build_target() {
  TARGET_CMAKE_OPTS="-DCMAKE_TOOLCHAIN_FILE=${CMAKE_CONF} \
                     -DCMAKE_INSTALL_PREFIX=/usr"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/.${TARGET_NAME}/lib/tic80_libretro.so $INSTALL/usr/lib/libretro/tic80_libretro.so
}
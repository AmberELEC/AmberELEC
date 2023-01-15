# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="duckstation"
PKG_VERSION="573c8370d75d38e922fa7b9f99d9c87c1f913c5d"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/stenzek/duckstation"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain nasm:host pulseaudio openssl curl libidn2 nghttp2 zlib SDL2 libevdev"
PKG_LONGDESC="Fast PlayStation 1 emulator for x86-64/AArch32/AArch64"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET+="-DBUILD_LIBRETRO_CORE=ON \
                        -DCMAKE_BUILD_TYPE="Release" \
                        -DCMAKE_RULE_MESSAGES=OFF \
                        -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
                        -DCMAKE_C_FLAGS_RELEASE="-DNDEBUG" \
                        -DCMAKE_CXX_FLAGS_RELEASE="-DNDEBUG" \
                        -DBUILD_SDL_FRONTEND=OFF \
                        -DBUILD_QT_FRONTEND=OFF \
                        -DENABLE_DISCORD_PRESENCE=OFF \
                        -DUSE_X11=OFF"

pre_configure_target() {
  sed -i 's/FS_OSPATH_SEPARATOR_STR "duckstation_cache"/FS_OSPATH_SEPARATOR_STR ".duckstation_cache"/g' ${PKG_BUILD}/src/duckstation-libretro/libretro_host_interface.cpp
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/.${TARGET_NAME}/duckstation_libretro.so ${INSTALL}/usr/lib/libretro
}

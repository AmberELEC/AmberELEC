# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="ppsspp"
PKG_VERSION="edcf6850379abe5e243c33890b34a8d930d3310f"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/hrydgard/ppsspp"
PKG_URL="https://github.com/hrydgard/ppsspp.git"
PKG_DEPENDS_TARGET="toolchain SDL2 ffmpeg libzip zstd"
PKG_LONGDESC="A PSP emulator for Android, Windows, Mac, Linux and Blackberry 10, written in C++."
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/CMakeLists.txt
  sed -i 's/\-O[23]//' ${PKG_BUILD}/libretro/Makefile
  PKG_CMAKE_OPTS_TARGET="-DLIBRETRO=ON \
                         -DCMAKE_BUILD_TYPE="Release" \
                         -DCMAKE_RULE_MESSAGES=OFF \
                         -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
                         -DCMAKE_C_FLAGS_RELEASE="-DNDEBUG" \
                         -DCMAKE_CXX_FLAGS_RELEASE="-DNDEBUG" \
                         -DUSE_SYSTEM_FFMPEG=ON \
                         -DUSE_SYSTEM_ZSTD=ON \
                         -DUSE_SYSTEM_LIBZIP=ON \
                         -DUSING_X11_VULKAN=OFF \
                         -DUSE_DISCORD=OFF"

  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DUSING_FBDEV=ON \
                             -DUSING_EGL=ON \
                             -DUSING_GLES2=ON"
  fi
}

pre_make_target() {
  # fix cross compiling
  find ${PKG_BUILD} -name flags.make -exec sed -i "s:isystem :I:g" \{} \;
  find ${PKG_BUILD} -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp lib/ppsspp_libretro.so ${INSTALL}/usr/lib/libretro/
}

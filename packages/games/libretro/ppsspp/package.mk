################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="ppsspp"
PKG_VERSION="03433c42ce35cd3bdd8800b74c9f4d1b92708a9e"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/hrydgard/ppsspp"
PKG_URL="https://github.com/hrydgard/ppsspp.git"
PKG_DEPENDS_TARGET="toolchain SDL2 ffmpeg libzip"
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
                         -DUSING_X11_VULKAN=OFF"

  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DUSING_FBDEV=ON \
                             -DUSING_EGL=ON \
                             -DUSING_GLES2=ON"
  fi
}

pre_make_target() {
  # fix cross compiling
  find $PKG_BUILD -name flags.make -exec sed -i "s:isystem :I:g" \{} \;
  find $PKG_BUILD -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp lib/ppsspp_libretro.so $INSTALL/usr/lib/libretro/
}

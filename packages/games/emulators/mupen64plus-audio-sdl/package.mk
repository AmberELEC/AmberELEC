# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mupen64plus-audio-sdl"
PKG_VERSION="af6af5b1fd4fdb435c836be15371dd047f395c4d"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_URL="https://github.com/mupen64plus/mupen64plus-audio-sdl/archive/${PKG_VERSION}.tar.gz"
PKG_SHA256="265ccdd56736f9cb4144196ad6673d2728a8ebd1e7b9c4280a632c3a343be261"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} libpng17 SDL2 SDL2_net zlib freetype nasm:host mupen64plus-core"
PKG_SHORTDESC="mupen64plus-audio-sdl"
PKG_LONGDESC="Mupen64Plus Standalone Audio SDL"
PKG_TOOLCHAIN="manual"

PKG_MAKE_OPTS_TARGET+="USE_GLES=1"

make_target() {
  export HOST_CPU=aarch64
  export APIDIR=$(get_build_dir mupen64plus-core)/.install_pkg/usr/local/include/mupen64plus
  export USE_GLES=1
  export SDL_CFLAGS="-I$SYSROOT_PREFIX/usr/include/SDL2 -D_REENTRANT"
  export SDL_LDLIBS="-lSDL_net -lSDL2"
  export CROSS_COMPILE="$TARGET_PREFIX"
  export V=1
  make -C projects/unix clean
  make -C projects/unix PREFIX=${INSTALL}/usr/local all ${PKG_MAKE_OPTS_TARGET}
}

makeinstall_target() {
  PREFIX=${INSTALL}/usr/local
  LIBDIR=${PREFIX}/lib
  PLUGINDIR=${LIBDIR}/mupen64plus
  mkdir -p ${PLUGINDIR}
  cp ${PKG_BUILD}/projects/unix/mupen64plus-audio-sdl.so ${PLUGINDIR}
  $STRIP ${PLUGINDIR}/mupen64plus-audio-sdl.so
  chmod 0644 ${PLUGINDIR}/mupen64plus-audio-sdl.so
}


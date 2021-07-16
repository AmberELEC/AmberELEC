# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mupen64plus-video-glide64mk2"
PKG_VERSION="f0c92d93a29633ca7d9bcbb93a79baaca1f3f353"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_URL="https://github.com/mupen64plus/mupen64plus-video-glide64mk2/archive/${PKG_VERSION}.tar.gz"
PKG_SHA256="cdfa70ae19ddbd5cdcf492d0bc7da947a60add9cd6ca2501558d04fc74007802"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} libpng17 SDL2 SDL2_net zlib freetype nasm:host mupen64plus-core"
PKG_SHORTDESC="mupen64plus-video-glide64mk2"
PKG_LONGDESC="Mupen64Plus Standalone Glide64 Video Driver"
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
  SHAREDIR=${PREFIX}/share/mupen64plus
  PLUGINDIR=${LIBDIR}/mupen64plus
  mkdir -p ${PLUGINDIR}
  cp ${PKG_BUILD}/projects/unix/mupen64plus-video-glide64mk2.so ${PLUGINDIR}
  $STRIP ${PLUGINDIR}/mupen64plus-video-glide64mk2.so
  chmod 0644 ${PLUGINDIR}/mupen64plus-video-glide64mk2.so
  mkdir -p ${SHAREDIR}
  cp ${PKG_BUILD}/data/Glide64mk2.ini ${SHAREDIR}
  chmod 0644 ${SHAREDIR}/Glide64mk2.ini
}


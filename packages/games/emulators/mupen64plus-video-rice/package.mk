# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mupen64plus-video-rice"
PKG_VERSION="8cd53f0272cd3cd44510a01fd0aedcb7e5df0790"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_URL="https://github.com/mupen64plus/mupen64plus-video-rice/archive/${PKG_VERSION}.tar.gz"
PKG_SHA256="3a7fa1da2a7b58862057d7e18910be611a11474ea82dfcc9a3e4b52c03b56007"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} libpng17 SDL2 SDL2_net zlib freetype nasm:host mupen64plus-core"
PKG_SHORTDESC="mupen64plus-video-rice"
PKG_LONGDESC="Mupen64Plus Standalone Rice Video Driver"
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
  cp ${PKG_BUILD}/projects/unix/mupen64plus-video-rice.so ${PLUGINDIR}
  $STRIP ${PLUGINDIR}/mupen64plus-video-rice.so
  chmod 0644 ${PLUGINDIR}/mupen64plus-video-rice.so
  mkdir -p ${SHAREDIR}
  cp ${PKG_BUILD}/data/RiceVideoLinux.ini ${SHAREDIR}
  chmod 0644 ${SHAREDIR}/RiceVideoLinux.ini
}


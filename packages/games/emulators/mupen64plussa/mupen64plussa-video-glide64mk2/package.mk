# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mupen64plussa-video-glide64mk2"
PKG_VERSION="992b5942078fe77987e8c40bcd396f44be19be2b"
PKG_SHA256="192ae40ac12c1dc38c336748e68679c4393ebc02caa1f0530ba21f1a7024ccdf"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/mupen64plus/mupen64plus-video-glide64mk2"
PKG_URL="https://github.com/mupen64plus/mupen64plus-video-glide64mk2/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} boost libpng SDL2 SDL2_net zlib freetype nasm:host mupen64plussa-core"
PKG_LONGDESC="Mupen64Plus Standalone Glide64 Video Driver"
PKG_TOOLCHAIN="manual"

PKG_MAKE_OPTS_TARGET+="USE_GLES=1"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/projects/unix/Makefile
}

make_target() {
  export HOST_CPU=aarch64
  export APIDIR=$(get_build_dir mupen64plussa-core)/.install_pkg/usr/local/include/mupen64plus
  export USE_GLES=1
  export SDL_CFLAGS="-I${SYSROOT_PREFIX}/usr/include/SDL2 -D_REENTRANT"
  export SDL_LDLIBS="-lSDL2_net -lSDL2"
  export CROSS_COMPILE="${TARGET_PREFIX}"
  export V=1
  export VC=0
  BINUTILS="$(get_build_dir binutils)/.aarch64-libreelec-linux-gnueabi"
  make -C projects/unix clean
  make -C projects/unix all ${PKG_MAKE_OPTS_TARGET}
}

makeinstall_target() {
  UPREFIX=${INSTALL}/usr/local
  ULIBDIR=${UPREFIX}/lib
  USHAREDIR=${UPREFIX}/share/mupen64plus
  UPLUGINDIR=${ULIBDIR}/mupen64plus
  mkdir -p ${UPLUGINDIR}
  cp ${PKG_BUILD}/projects/unix/mupen64plus-video-glide64mk2.so ${UPLUGINDIR}
  #${STRIP} ${UPLUGINDIR}/mupen64plus-video-glide64mk2.so
  chmod 0644 ${UPLUGINDIR}/mupen64plus-video-glide64mk2.so
  mkdir -p ${USHAREDIR}
  cp ${PKG_BUILD}/data/Glide64mk2.ini ${USHAREDIR}
  chmod 0644 ${USHAREDIR}/Glide64mk2.ini
}


# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mupen64plussa-input-sdl"
PKG_VERSION="fd7ffe63606b6cc4de7dab4e684c5aee68210681"
PKG_SHA256="f5cd57bd7262c037d5b27d07f0fea348db4d4426c607d2942d5933982aa27fdb"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/mupen64plus/mupen64plus-input-sdl"
PKG_URL="https://github.com/mupen64plus/mupen64plus-input-sdl/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} libpng SDL2 SDL2_net zlib freetype nasm:host mupen64plussa-core"
PKG_LONGDESC="Mupen64Plus Standalone Input SDL"
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
  cp ${PKG_BUILD}/projects/unix/mupen64plus-input-sdl.so ${UPLUGINDIR}
  #${STRIP} ${UPLUGINDIR}/mupen64plus-input-sdl.so
  chmod 0644 ${UPLUGINDIR}/mupen64plus-input-sdl.so
  mkdir -p ${USHAREDIR}
  cp ${PKG_DIR}/config/* ${USHAREDIR}
  chmod 644 ${USHAREDIR}/InputAutoCfg.ini
}


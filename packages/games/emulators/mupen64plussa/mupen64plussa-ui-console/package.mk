# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mupen64plussa-ui-console"
PKG_VERSION="3a5793ebc3c7e80972849e2d91f55500123a2cf4"
PKG_SHA256="c9f66cbae62abcf7222656ec3065c47ea2d7703ccec7e2344b78fa96615ab793"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/mupen64plus/mupen64plus-ui-console"
PKG_URL="https://github.com/mupen64plus/mupen64plus-ui-console/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} libpng SDL2 SDL2_net zlib freetype nasm:host mupen64plussa-core"
PKG_LONGDESC="Mupen64Plus Standalone Console"
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
  UBINDIR=${UPREFIX}/bin
  UMANDIR=${UPREFIX}/share/man
  UAPPSDIR=${UPREFIX}/share/applications
  UICONSDIR=${UPREFIX}/share/icons/hicolor
  mkdir -p ${UBINDIR}
  cp ${PKG_BUILD}/projects/unix/mupen64plus ${UBINDIR}
  #${STRIP} ${UBINDIR}/mupen64plus
  chmod 0755 ${UBINDIR}/mupen64plus
  mkdir -p ${UMANDIR}/man6
  cp ${PKG_BUILD}/doc/mupen64plus.6 ${UMANDIR}/man6
  chmod 0644 ${UMANDIR}/man6/mupen64plus.6
  mkdir -p ${UAPPSDIR}
  cp ${PKG_BUILD}/data/mupen64plus.desktop ${UAPPSDIR}
  chmod 0644 ${UAPPSDIR}/mupen64plus.desktop
  mkdir -p ${UICONSDIR}/48x48/apps
  cp ${PKG_BUILD}/data/icons/48x48/apps/mupen64plus.png ${UICONSDIR}/48x48/apps
  chmod 0644 ${UICONSDIR}/48x48/apps/mupen64plus.png
  mkdir -p ${UICONSDIR}/scalable/apps
  cp ${PKG_BUILD}/data/icons/scalable/apps/mupen64plus.svg ${UICONSDIR}/scalable/apps
  chmod 0644 ${UICONSDIR}/scalable/apps/mupen64plus.svg
}


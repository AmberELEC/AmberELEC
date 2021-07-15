# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mupen64plus-ui-console"
PKG_VERSION="32e27344214946f0dce3cd2b4fff152a3538bd8f"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_URL="https://github.com/mupen64plus/mupen64plus-ui-console/archive/${PKG_VERSION}.tar.gz"
PKG_SHA256="7d4a0a71545caec19d007f34038cffaee36b75d27de615cd4e175bb5ab2e227d"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} libpng17 SDL2 SDL2_net zlib freetype nasm:host mupen64plus-core"
PKG_SHORTDESC="mupen64plus-ui-console"
PKG_LONGDESC="Mupen64Plus Standalone Console"
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
  export NEW_DYNAREC=1
  make -C projects/unix clean
  make -C projects/unix PREFIX=${INSTALL}/usr/local all ${PKG_MAKE_OPTS_TARGET}
}

makeinstall_target() {
  PREFIX=${INSTALL}/usr/local
  LIBDIR=${PREFIX}/lib
  BINDIR=${PREFIX}/bin
  MANDIR=${PREFIX}/share/man
  APPSDIR=${PREFIX}/share/applications
  ICONSDIR=${PREFIX}/share/icons/hicolor
  mkdir -p ${BINDIR}
  cp ${PKG_BUILD}/projects/unix/mupen64plus ${BINDIR}
  $STRIP ${BINDIR}/mupen64plus
  chmod 0755 ${BINDIR}/mupen64plus
  mkdir -p ${MANDIR}/man6
  cp ${PKG_BUILD}/doc/mupen64plus.6 ${MANDIR}/man6
  chmod 0644 ${MANDIR}/man6/mupen64plus.6
  mkdir -p ${APPSDIR}
  cp ${PKG_BUILD}/data/mupen64plus.desktop ${APPSDIR}
  chmod 0644 ${APPSDIR}/mupen64plus.desktop
  mkdir -p ${ICONSDIR}/48x48/apps
  cp ${PKG_BUILD}/data/icons/48x48/apps/mupen64plus.png ${ICONSDIR}/48x48/apps
  chmod 0644 ${ICONSDIR}/48x48/apps/mupen64plus.png
  mkdir -p ${ICONSDIR}/scalable/apps
  cp ${PKG_BUILD}/data/icons/scalable/apps/mupen64plus.svg ${ICONSDIR}/scalable/apps
  chmod 0644 ${ICONSDIR}/scalable/apps/mupen64plus.svg
}


# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mupen64plussa-core"
PKG_VERSION="fe284b142e957e92a51726d6000e987753c0d4c8"
PKG_SHA256="36d98d957eca47b565652b0484631dde2e457d2973345444d469eb893451d487"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/mupen64plus/mupen64plus-core"
PKG_URL="https://github.com/mupen64plus/mupen64plus-core/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} boost libpng SDL2 SDL2_net zlib freetype nasm:host"
PKG_LONGDESC="Mupen64Plus Standalone"
PKG_TOOLCHAIN="manual"

PKG_MAKE_OPTS_TARGET+="USE_GLES=1"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/projects/unix/Makefile
}

make_target() {
  export HOST_CPU=aarch64
  export USE_GLES=1
  export SDL_CFLAGS="-I${SYSROOT_PREFIX}/usr/include/SDL2 -D_REENTRANT"
  export SDL_LDLIBS="-lSDL2_net -lSDL2"
  export CROSS_COMPILE="${TARGET_PREFIX}"
  export V=1
  export VC=0
  export VULKAN=0
  BINUTILS="$(get_build_dir binutils)/.aarch64-libreelec-linux-gnueabi"
  make -C projects/unix clean
  make -C projects/unix all ${PKG_MAKE_OPTS_TARGET}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/local/lib
  cp ${PKG_BUILD}/projects/unix/libmupen64plus.so.2.0.0 ${INSTALL}/usr/local/lib
  chmod 644 ${INSTALL}/usr/local/lib/libmupen64plus.so.2.0.0
  cp ${PKG_BUILD}/projects/unix/libmupen64plus.so.2 ${INSTALL}/usr/local/lib
  mkdir -p ${INSTALL}/usr/local/share/mupen64plus
  cp ${PKG_BUILD}/data/* ${INSTALL}/usr/local/share/mupen64plus
  chmod 0644 ${INSTALL}/usr/local/share/mupen64plus/*
  mkdir -p ${INSTALL}/usr/local/include/mupen64plus
  cp ${PKG_BUILD}/src/api/m64p_*.h ${INSTALL}/usr/local/include/mupen64plus
  chmod 0644 ${INSTALL}/usr/local/include/mupen64plus/*

  if [ "${DEVICE}" = "RG351P" ]; then
    cp ${PKG_DIR}/config/mupen64plus-RG351P.cfg ${INSTALL}/usr/local/share/mupen64plus/mupen64plus.cfg
  elif [ "${DEVICE}" = "RG351V" ]; then
    cp ${PKG_DIR}/config/mupen64plus-RG351V.cfg ${INSTALL}/usr/local/share/mupen64plus/mupen64plus.cfg
  elif [ "${DEVICE}" = "RG351MP" ]; then
    cp ${PKG_DIR}/config/mupen64plus-RG351MP.cfg ${INSTALL}/usr/local/share/mupen64plus/mupen64plus.cfg
  elif [ "${DEVICE}" = "RG552" ]; then
    cp ${PKG_DIR}/config/mupen64plus-RG552.cfg ${INSTALL}/usr/local/share/mupen64plus/mupen64plus.cfg
  fi
  chmod 644 ${INSTALL}/usr/local/share/mupen64plus/mupen64plus.cfg
  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_DIR}/m64p.sh ${INSTALL}/usr/bin
  chmod 755 ${INSTALL}/usr/bin/m64p.sh
}


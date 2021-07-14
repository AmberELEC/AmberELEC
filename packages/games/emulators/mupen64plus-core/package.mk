# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mupen64plus-core"
PKG_VERSION="1.0"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_URL="https://github.com/mupen64plus/mupen64plus-core/releases/download/2.5.9/mupen64plus-core-src-2.5.9.tar.gz"
PKG_SHA256="84244c77a93c0c198729da06d75628c5c5513ee56a5fc0a5785a92461071f34c"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} libpng17 SDL2 SDL2_net zlib freetype nasm:host"
PKG_SHORTDESC="mupen64plus"
PKG_LONGDESC="Mupen64Plus Standalone"
PKG_TOOLCHAIN="manual"

PKG_MAKE_OPTS_TARGET+="USE_GLES=1"

make_target() {
  export HOST_CPU=aarch64
  export USE_GLES=1
  export SDL_CFLAGS="-I$SYSROOT_PREFIX/usr/include/SDL2 -D_REENTRANT"
  export SDL_LDLIBS="-lSDL_net -lSDL2"
  export CROSS_COMPILE="$TARGET_PREFIX"
  export V=1
  export OPTFLAGS="--allow-multiple-definition"
  make -C projects/unix clean
  make -C projects/unix all ${PKG_MAKE_OPTS_TARGET}
}


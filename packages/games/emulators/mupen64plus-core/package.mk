# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mupen64plus-core"
PKG_VERSION="1.0"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_URL="https://github.com/mupen64plus/mupen64plus-core/releases/download/2.5.9/mupen64plus-core-src-2.5.9.tar.gz"
PKG_SHA256="84244c77a93c0c198729da06d75628c5c5513ee56a5fc0a5785a92461071f34c"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} libpng SDL2 zlib freetype"
PKG_SHORTDESC="mupen64plus"
PKG_LONGDESC="Mupen64Plus Standalone"
PKG_TOOLCHAIN="manual"

PKG_MAKE_OPTS_TARGET+="USE_GLES=1"

post_unpack() {
  mkdir -p ${PKG_UNPACK_DIR}
  mv ${PKG_BUILD} "${PKG_UNPACK_DIR}/.intermediate"
  mkdir -p "${PKG_BUILD}/source"
  mv ${PKG_UNPACK_DIR}/.intermediate ${PKG_BUILD}/source/mupen64plus-core
  rm -rf "${PKG_UNPACK_DIR}"
}

pre_make_target() {
  export CFLAGS=${CFLAGS}
  export CPPFLAGS=${CPPFLAGS}
}

make_target() {
  make -C source/mupen64plus-core/projects/unix all ${PKG_MAKE_OPTS_TARGET}
}


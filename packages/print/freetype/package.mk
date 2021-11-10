# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="freetype"
PKG_VERSION="2.11.0"
PKG_SHA256="8bee39bd3968c4804b70614a0a3ad597299ad0e824bc8aad5ce8aaf48067bde7"
PKG_LICENSE="GPL"
PKG_SITE="http://www.freetype.org"
PKG_URL="http://download.savannah.gnu.org/releases/freetype/freetype-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="toolchain:host"
PKG_DEPENDS_TARGET="toolchain zlib libpng"
PKG_LONGDESC="The FreeType engine is a free and portable TrueType font rendering engine."
PKG_TOOLCHAIN="configure"

# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="LIBPNG_CFLAGS=-I${SYSROOT_PREFIX}/usr/include \
                           LIBPNG_LDFLAGS=-L${SYSROOT_PREFIX}/usr/lib \
                           --with-zlib"

#pre_configure_target() {
#  # unset LIBTOOL because freetype uses its own
#    ( cd ..
#      unset LIBTOOL
#      sh autogen.sh
#    )
#}

post_makeinstall_target() {
  mkdir -p ${SYSROOT_PREFIX}/usr/bin
  sed -e "s#prefix=/usr#prefix=${SYSROOT_PREFIX}/usr#" -i "${SYSROOT_PREFIX}/usr/lib/pkgconfig/freetype2.pc"
  cp -P "freetype-config" "${SYSROOT_PREFIX}/usr/bin"
}

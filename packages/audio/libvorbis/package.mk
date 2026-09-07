# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libvorbis"
PKG_VERSION="1.3.7"
PKG_SHA256="0e982409a9c3fc82ee06e08205b1355e5c6aa4c36bca58146ef399621b0ce5ab"
PKG_LICENSE="BSD"
PKG_SITE="http://www.vorbis.com/"
PKG_URL="http://downloads.xiph.org/releases/vorbis/libvorbis-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libogg"
PKG_LONGDESC="Lossless audio compression tools using the ogg-vorbis algorithms."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --enable-shared \
                           --with-ogg=${SYSROOT_PREFIX}/usr \
                           --disable-docs \
                           --disable-examples \
                           --disable-oggtest"
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="pcre"
PKG_VERSION="8.45"
PKG_SHA256="4dae6fdcd2bb0bb6c37b5f97c33c2be954da743985369cddac3546e3218bffb8"
PKG_LICENSE="OSS"
PKG_SITE="http://www.pcre.org/"
PKG_URL="https://downloads.sourceforge.net/project/pcre/pcre/${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_HOST="toolchain:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A set of functions that implement regular expression pattern matching."
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_HOST="--prefix=${TOOLCHAIN} \
             --enable-static \
             --enable-utf8 \
             --enable-unicode-properties \
             --with-gnu-ld"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
             --enable-static \
             --enable-utf8 \
             --enable-pcre16 \
             --enable-unicode-properties \
             --with-gnu-ld"

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/bin
  sed -e "s:\(['= ]\)/usr:\\1${SYSROOT_PREFIX}/usr:g" -i ${SYSROOT_PREFIX}/usr/bin/${PKG_NAME}-config
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gnutls"
PKG_VERSION="3.8.13"
PKG_SHA256="ffed8ec1bf09c2426d4f14aae377de4753b53e537d685e604e99a8b16ca9c97e"
PKG_LICENSE="LGPL-2.1-or-later"
PKG_SITE="https://gnutls.org"
PKG_URL="https://www.gnupg.org/ftp/gcrypt/gnutls/v${PKG_VERSION:0:3}/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="autotools:host libidn2:host nettle:host gmp:host zlib:host"
PKG_DEPENDS_TARGET="autotools:host gcc:host libidn2 nettle gmp zlib"
PKG_LONGDESC="A library which provides a secure layer over a reliable transport layer."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_COMMON="--disable-doc \
                           --disable-full-test-suite \
                           --disable-libdane \
                           --disable-padlock \
                           --disable-rpath \
                           --disable-tests \
                           --disable-tools \
                           --disable-valgrind-tests \
                           --with-idn \
                           --with-included-libtasn1 \
                           --with-included-unistring \
                           --without-p11-kit \
                           --without-tpm"

PKG_CONFIGURE_OPTS_HOST="${PKG_CONFIGURE_OPTS_COMMON}"
PKG_CONFIGURE_OPTS_TARGET="${PKG_CONFIGURE_OPTS_COMMON}"

pre_configure_target() {
  export CFLAGS="${TARGET_CFLAGS} --sysroot=${SYSROOT_PREFIX} -I${SYSROOT_PREFIX}/usr/include"
  export LDFLAGS="${TARGET_LDFLAGS} --sysroot=${SYSROOT_PREFIX} -L${SYSROOT_PREFIX}/usr/lib -Wl,-rpath-link,${SYSROOT_PREFIX}/usr/lib"
  export HOGWEED_CFLAGS="-I${SYSROOT_PREFIX}/usr/include"
  export HOGWEED_LIBS="-L${SYSROOT_PREFIX}/usr/lib -lhogweed -lnettle -lgmp"
  export NETTLE_CFLAGS="-I${SYSROOT_PREFIX}/usr/include"
  export NETTLE_LIBS="-L${SYSROOT_PREFIX}/usr/lib -lnettle"
  export GMP_CFLAGS="-I${SYSROOT_PREFIX}/usr/include"
  export GMP_LIBS="-L${SYSROOT_PREFIX}/usr/lib -lgmp"
}

post_configure_target() {
  libtool_remove_rpath libtool
}
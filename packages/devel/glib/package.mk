# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="glib"
PKG_VER_MAJOR="2.70"
PKG_VERSION="${PKG_VER_MAJOR}.1"
PKG_SHA256="f9b7bce7f51753a1f43853bbcaca8bf09e15e994268e29cfd7a76f65636263c0"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.gtk.org/"
PKG_URL="https://download.gnome.org/sources/glib/${PKG_VER_MAJOR}/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="libffi:host pcre:host Python3:host meson:host ninja:host"
PKG_DEPENDS_TARGET="toolchain pcre zlib libffi Python3:host util-linux"
PKG_LONGDESC="A library which includes support routines for C such as lists, trees, hashes, memory allocation."
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_HOST="-Ddefault_library=static \
                     -Dinstalled_tests=false \
                     -Dlibmount=disabled \
                     -Dtests=false"

PKG_MESON_OPTS_TARGET="-Ddefault_library=shared \
                       -Dinstalled_tests=false \
                       -Dselinux=disabled \
                       -Dfam=false \
                       -Dxattr=true \
                       -Dgtk_doc=false \
                       -Dman=false \
                       -Ddtrace=false \
                       -Dsystemtap=false \
                       -Dbsymbolic_functions=true \
                       -Dforce_posix_threads=true \
                       -Dtests=false"

PKG_MESON_PROPERTIES_TARGET="
have_c99_vsnprintf=false
have_c99_snprintf=false
growing_stack=false
va_val_copy=false"

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/bin
  rm -rf ${INSTALL}/usr/lib/gdbus-2.0
  rm -rf ${INSTALL}/usr/lib/glib-2.0
  rm -rf ${INSTALL}/usr/lib/installed-tests
  rm -rf ${INSTALL}/usr/share
}

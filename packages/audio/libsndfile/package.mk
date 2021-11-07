# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="libsndfile"
PKG_VERSION="1.0.31"
PKG_SHA256="a8cfb1c09ea6e90eff4ca87322d4168cdbe5035cb48717b40bf77e751cc02163"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.mega-nerd.com/libsndfile/"
PKG_URL="https://github.com/libsndfile/libsndfile/releases/download/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain alsa-lib"
PKG_LONGDESC="A library for accessing various audio file formats."
PKG_SHORTDESC="A library for accessing various audio file formats."
PKG_TOOLCHAIN="configure"

# package specific configure options
PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-silent-rules \
                           --disable-sqlite \
                           --enable-alsa \
                           --disable-experimental \
                           --disable-test-coverage \
                           --enable-largefile \
                           --with-gnu-ld"

make_target() {
  make
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}

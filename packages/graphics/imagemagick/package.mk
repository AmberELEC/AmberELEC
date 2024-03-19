# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="imagemagick"
PKG_VERSION="7.1.1-29"
PKG_LICENSE="http://www.imagemagick.org/script/license.php"
PKG_SITE="http://www.imagemagick.org/"
PKG_URL="https://github.com/ImageMagick/ImageMagick/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libpng libjpeg-turbo fontconfig libraw lcms2 libtool libxml2 libzip libwebp"
PKG_LONGDESC="Software suite to create, edit, compose, or convert bitmap images"

pre_configure_target() {
  PKG_CONFIGURE_OPTS_TARGET="--disable-openmp \
                            --disable-static \
                             --enable-shared \
                             --with-pango=no \
                             --with-utilities=yes \
                             --with-x=no"
  export LDFLAGS+=" -lsharpyuv -lwebp"
}

makeinstall_target() {
  make install DESTDIR=${INSTALL} ${PKG_MAKEINSTALL_OPTS_TARGET}
  rm ${INSTALL}/usr/bin/*config
}

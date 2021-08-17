# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)
# Copyright (C) 2020-present Fewtarius

PKG_NAME="poppler"
PKG_VERSION="5d3e71c8215997a96d2ade7272217087f7e59fe2"
PKG_SHA256="01575e4c1510c657839e742cfeabdcbd8d99dd9e9cc3dff74748643a3e7ab7d9"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/freedesktop/poppler"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib libpng libjpeg-turbo boost"
PKG_LONGDESC="This is Poppler, a library for rendering PDF files, and examining or modifying their structure."
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET="-DENABLE_LIBOPENJPEG=none"

#pre_configure_target() {
#}

#post_makeinstall_target() {
#  rm -rf $INSTALL/usr/bin
#}

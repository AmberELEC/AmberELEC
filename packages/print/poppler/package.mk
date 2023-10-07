# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC

PKG_NAME="poppler"
PKG_VERSION="23.10.0"
PKG_LICENSE="GPL"
PKG_SITE="https://poppler.freedesktop.org/"
PKG_URL="${PKG_SITE}poppler-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib libpng libjpeg-turbo boost tiff"
PKG_LONGDESC="The poppler pdf rendering library "
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DENABLE_LIBOPENJPEG=none \
                       -DENABLE_GLIB=ON \
                       -DENABLE_QT5=OFF \
                       -DENABLE_QT6=OFF \
                       -DENABLE_NSS3=OFF \
                       -DENABLE_LCMS=OFF \
                       -DENABLE_GPGME=OFF \
                       -DENABLE_CPP=OFF"

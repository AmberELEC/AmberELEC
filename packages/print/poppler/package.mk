# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC

PKG_NAME="poppler"
PKG_VERSION="065dca3816db3979dfacdc2f8592abed2ff6859a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/freedesktop/poppler"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain zlib libpng libjpeg-turbo boost"
PKG_LONGDESC="The poppler pdf rendering library "
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET="-DENABLE_LIBOPENJPEG=none \
                       -DENABLE_GLIB=ON \
                       -DENABLE_QT5=OFF \
                       -DENABLE_CPP=OFF"
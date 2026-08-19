# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="minizip"
PKG_VERSION="4.0.10"
PKG_SHA256="c362e35ee973fa7be58cc5e38a4a6c23cc8f7e652555daf4f115a9eb2d3a6be7"
PKG_ARCH="any"
PKG_LICENSE="zlib"
PKG_SITE="https://github.com/zlib-ng/minizip-ng"
PKG_URL="https://github.com/zlib-ng/minizip-ng/archive/refs/tags/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib bzip2"
PKG_PRIORITY="optional"
PKG_SECTION="libs"
PKG_SHORTDESC="Zip file manipulation library written in C"
PKG_LONGDESC="minizip-ng is a zip manipulation library written in C that is compatible with zlib."
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET="-DBUILD_SHARED_LIBS=ON \
                       -DMINIZIP_BUILD_TESTS=OFF \
                       -DMINIZIP_BUILD_EXECUTABLES=ON \
                       -DMINIZIP_COMPAT=ON \
                       -DMINIZIP_ZLIB=ON \
                       -DMINIZIP_BZIP2=ON \
                       -DMINIZIP_LZMA=OFF"

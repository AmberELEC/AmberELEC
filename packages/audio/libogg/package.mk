# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libogg"
PKG_VERSION="1.3.5"
PKG_LICENSE="BSD"
PKG_SITE="https://www.xiph.org/ogg/"
PKG_URL="http://downloads.xiph.org/releases/ogg/libogg-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Libogg contains necessary functionality to create, decode, and work with Ogg bitstreams."
PKG_BUILD_FLAGS="+pic"

PKG_CMAKE_OPTS_TARGET="-DINSTALL_DOCS=OFF"
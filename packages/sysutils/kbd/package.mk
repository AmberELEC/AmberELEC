# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="kbd"
PKG_VERSION="2.4.0"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/legionus/kbd"
PKG_URL="https://github.com/legionus/kbd/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS="toolchain"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="configure"

pre_configure_target() {
  cd .
  ./autogen.sh
}

configure_target() {
  ./configure --disable-vlock --prefix=/usr --host=aarch64
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="libxmp-lite"
PKG_VERSION="4.5.0"
PKG_SITE="http://sourceforge.net/projects/xmp"
PKG_URL="${PKG_SITE}/files/libxmp/${PKG_VERSION}/libxmp-lite-${PKG_VERSION}.tar.gz"
PKG_LONGDESC="Libxmp is a library that renders module files to PCM data."
PKG_DEPENDS_TARGET="toolchain"

PKG_TOOLCHAIN="configure"

pre_configure_target() {
  cd ${PKG_BUILD}
}



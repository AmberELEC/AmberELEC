# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="glsl-shaders"
PKG_VERSION="6d5c3fe803d2ebe2b44ef42d2b421f5b6df3e045"
PKG_SHA256="e4fdc2f563e72b6f728cebbe52b72a264fc40524c3bf3ba54bed0cc35617cad2"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/glsl-shaders"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain common-shaders"
PKG_LONGDESC="Common GSLS shaders for RetroArch"
PKG_TOOLCHAIN="make"

configure_target() {
  cd ${PKG_BUILD}
}

makeinstall_target() {
  make install INSTALLDIR="${INSTALL}/usr/share/common-shaders"
  cp -rf ${PKG_DIR}/shaders/* ${INSTALL}/usr/share/common-shaders
}

post_makeinstall_target() {
  cp -f ${PKG_DIR}/removeshaders.sh .
  chmod 755 removeshaders.sh
  /bin/sh removeshaders.sh ${INSTALL}
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="glsl-shaders"
PKG_VERSION="799aa9e4d567db0874111d2aed9c9b9058a19641"
PKG_SHA256="42825da89f65368c786f8dce1ddaf7d2c03cf817d1e5070b4b9a615550cdd9d8"
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

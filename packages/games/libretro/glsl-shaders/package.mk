# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="glsl-shaders"
PKG_VERSION="66cd3917c3cde8c96b5492bca00c95e3e17b44b9"
PKG_SHA256="cb24da2427c643e2cc3e1562235680f74dffd7c9adddf098ea4deeb9158fa20a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/glsl-shaders"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Common GSLS shaders for RetroArch"
PKG_TOOLCHAIN="make"

configure_target() {
  cd ${PKG_BUILD}
}

makeinstall_target() {
  make install INSTALLDIR="${INSTALL}/usr/share/common-shaders"
  cp -r ${PKG_DIR}/shaders/* ${INSTALL}/usr/share/common-shaders
}

post_makeinstall_target() {
  cp ${PKG_DIR}/removeshaders.sh .
  chmod 755 removeshaders.sh
  /bin/sh removeshaders.sh ${INSTALL}
}

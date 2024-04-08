# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="fbgrab"
PKG_VERSION="b781b05d2dd12fd2a35705c0fc6cb3667fddee35"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/jwilk/fbcat"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="FBGrab is a framebuffer screenshot program"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_BUILD}/fbgrab ${INSTALL}/usr/bin
  cp ${PKG_BUILD}/fbcat ${INSTALL}/usr/bin
}

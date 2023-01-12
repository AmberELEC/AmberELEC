# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="exfat"
PKG_VERSION="66747e2df0771b23ea30cbef3767f2b72488e914"
PKG_SHA256="c83fedc3deaefde0d9549deb73ffc4b610d29ff23d39e5628114f67d267d0e82"
PKG_LICENSE="GPLv2+"
PKG_SITE="https://github.com/relan/exfat"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_DEPENDS_INIT="toolchain exfat"
PKG_LONGDESC="This project aims to provide a full-featured exFAT file system implementation for GNU/Linux other Unix-like systems as a FUSE module."
PKG_TOOLCHAIN="autotools"

make_init() {
  : # reuse make_target()
}

makeinstall_init() {
  mkdir -p ${INSTALL}/usr/sbin
  cp ../.install_pkg/usr/sbin/exfatfsck ${INSTALL}/usr/sbin
  ln -sf exfatfsck ${INSTALL}/usr/sbin/fsck.exfat
}

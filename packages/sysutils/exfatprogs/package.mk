# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="exfatprogs"
PKG_VERSION="7c3b61769bb04eaafedf245db396813bbcfb2b0a"
PKG_SHA256="17f8ca2b3729a82b2afa8e6f50f3506e61d691763365d0da477c88642787e5cf"
PKG_LICENSE="GPLv2+"
PKG_SITE="https://github.com/exfatprogs/exfatprogs"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_LONGDESC="Userspace utilities for exfat"
PKG_TOOLCHAIN="autotools"

# 'mkfs.exfat' exists in the 'exfat' package and that is what ends up in the final AmberELEC image
# In some cases, there is an error condition copying this file over the symlink from the 'exfat' package
# Removing the mkfs.exfat file just avoids that entirely
post_makeinstall_target() {
  rm -rf "${INSTALL}/usr/sbin/mkfs.exfat"
}
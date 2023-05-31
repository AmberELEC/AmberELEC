# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="lib32"
PKG_VERSION="2eea882f48681c8a9cc401bbb020c05b4f7edaa4"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/AmberELEC/lib32"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="ARM 32bit bundles for aarch64"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib32
  cd ${PKG_BUILD}
  tar xvfz lib32_${DEVICE}.tar.gz
  cp -rfv usr/lib32/* ${INSTALL}/usr/lib32
}

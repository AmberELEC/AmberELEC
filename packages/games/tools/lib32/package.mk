# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="lib32"
PKG_VERSION="42f9d8d98e576edbc88499bf5bf5fa1bbe736101"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/AmberELEC/lib32"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="ARM 32bit bundles for aarch64"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib32
  cd ${PKG_BUILD}
  tar xvfz lib32_${DEVICE}.tar.gz
  cp -rfv usr/lib32/* ${INSTALL}/usr/lib32
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="lib32"
PKG_VERSION="b385a6f6b5f40e7b1fd083a2f8addb4146d087a4"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/AmberELEC/lib32"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="ARM 32bit bundles for aarch64"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib32
  cd ${PKG_BUILD}
  local bundle="${DEVICE}"
  if [ "${DEVICE}" = "RG503" ]; then
    bundle="RG353"
  fi
  tar xvfz lib32_${bundle}.tar.gz
  cp -rfv usr/lib32/* ${INSTALL}/usr/lib32
}

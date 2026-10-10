# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present AmberELEC

PKG_NAME="odroidgoa-utils"
PKG_VERSION=""
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Support scripts for the RG353"
PKG_TOOLCHAIN="manual"
PKG_NEED_UNPACK="${PROJECT_DIR}/${PROJECT}/devices/RG351MP/packages/odroidgoa-utils/sources/adckeys.py"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp odroidgoa_utils.sh volume_sense.sh ${INSTALL}/usr/bin
  cp ${PROJECT_DIR}/${PROJECT}/devices/RG351MP/packages/odroidgoa-utils/sources/adckeys.py ${INSTALL}/usr/bin
  chmod 0755 ${INSTALL}/usr/bin/*
}

post_install() {
  enable_service volume.service
}

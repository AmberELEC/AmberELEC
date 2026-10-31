# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021-present Fewtarius

PKG_NAME="odroidgoa-utils"
PKG_VERSION=""
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_DEPENDS_TARGET="toolchain"
PKG_SITE=""
PKG_URL=""
PKG_LONGDESC="Audio and volume key support for the MLP1"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp odroidgoa_utils.sh volume_sense.sh poweroff-charge.sh ${INSTALL}/usr/bin
  chmod 0755 ${INSTALL}/usr/bin/*
}

post_install() {
  enable_service volume.service
}

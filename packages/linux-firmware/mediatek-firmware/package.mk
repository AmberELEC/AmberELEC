# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Fewtarius

PKG_NAME="mediatek-firmware"
PKG_VERSION="firmware"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_DEPENDS_TARGET="rkbin rfkill"
PKG_LONGDESC="mediatek firmware"
PKG_TOOLCHAIN="manual"

makeinstall_target() {

  mkdir -p $INSTALL/usr/etc.modprobe.d
    cp -v mt7601u.conf $INSTALL/usr/etc.modprobe.d/

}

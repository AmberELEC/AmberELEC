# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team CoreELEC (https://coreelec.org)
# Copyright (C) 2021-present Xargon (https://github.com/XargonWan)

PKG_NAME="rclone"
PKG_VERSION="1.0"
PKG_ARCH="aarch64"
PKG_URL="https://downloads.rclone.org/rclone-current-linux-arm64.zip"
PKG_SECTION="tools"
PKG_SHORTDESC="rsync for cloud storage"
PKG_TOOLCHAIN="manual"

pre_unpack() {
  wget $PKG_URL
  unzip sources/rclone/rclone*.zip -d $PKG_BUILD/
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin/
  mkdir -p $INSTALL/usr/config/
  cp $PKG_BUILD/rclone*/rclone $INSTALL/usr/bin/
  cp $PKG_DIR/cloud-sync-rules.conf $INSTALL/usr/config/
  chmod 755 $INSTALL/usr/bin/rclone
}
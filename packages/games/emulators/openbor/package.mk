# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present RedWolfTech
# Copyright (C) 2020-present Fewtarius

PKG_NAME="openbor"
PKG_VERSION="v6391"
PKG_SHA256="b5c5edb0fdd0dc882a25156cf7fea734a9136ed8b347db446b3efc84a9f599ce"
PKG_ARCH="any"
PKG_SITE="https://github.com/DCurrent/openbor/releases"
PKG_URL="$PKG_SITE/download/$PKG_VERSION/OpenBOR.v3.0.Build.6391.tar.7z"
PKG_DEPENDS_TARGET="toolchain p7zip:host"
PKG_SHORTDESC="OpenBOR is the ultimate 2D side scrolling engine for beat em' ups, shooters, and more! "
PKG_LONGDESC="OpenBOR is the ultimate 2D side scrolling engine for beat em' ups, shooters, and more! "
PKG_TOOLCHAIN="manual"

#
# This is a (maybe temporary) solution that integrates the PSP version
# of OpenBOR via RetroArch until the native controls are corrected.
# 

make_target() {
  cd $PKG_BUILD
  7zr x $SOURCES/${PKG_NAME}/${PKG_NAME}-${PKG_VERSION}.7z
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/config/openbor
  cp -rf $PKG_BUILD/"OpenBOR v3.0 Build 6391"/PSP/OpenBOR/* $INSTALL/usr/config/openbor
  mkdir -p $INSTALL/usr/config/openbor/Saves
  cp -rf $PKG_DIR/config/Saves/* $INSTALL/usr/config/openbor/Saves
  mkdir -p $INSTALL/usr/bin
  cp $PKG_DIR/scripts/*.sh $INSTALL/usr/bin
}

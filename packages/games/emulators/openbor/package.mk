# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present RedWolfTech
# Copyright (C) 2020-present Fewtarius

PKG_NAME="openbor"
PKG_VERSION=""
PKG_SHA256="1c9a8a93584a9e0abda7aa11340d9b794a32b95d7b10c078460d13d68cc317d5"
PKG_ARCH="any"
PKG_SITE="http://downloads.sf.net/sourceforge/$PKG_NAME"
PKG_URL="$PKG_SITE/OpenBOR_v3.0_Build_4432.rar"
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
  unrar x $SOURCES/${PKG_NAME}/${PKG_NAME}-${PKG_VERSION}.rar
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/config/openbor
  cp -rf $PKG_BUILD/PSP/OpenBOR/* $INSTALL/usr/config/openbor
  mkdir -p $INSTALL/usr/config/openbor/Saves
  cp -rf $PKG_DIR/config/Saves/* $INSTALL/usr/config/openbor/Saves
  mkdir -p $INSTALL/usr/bin
  cp $PKG_DIR/scripts/*.sh $INSTALL/usr/bin
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="opentyrian"
PKG_VERSION="74245dbebb8f280f4229c32b65de0854e5f843d2"
PKG_SHA256="478560a3fd25070f39b9ebbda059589feb8b1a471d62a26b2fd39cabd9b7af08"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/opentyrian/opentyrian"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2"
PKG_LONGDESC="An open-source port of the DOS shoot-em-up Tyrian."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  cd $PKG_BUILD
  rm -f tyrian21.zip
  rm -rf tyrian21
  wget -O tyrian21.zip https://www.camanis.net/tyrian/tyrian21.zip
  unzip $PKG_BUILD/tyrian21.zip

  mkdir -p $INSTALL/usr/local/bin
  cp opentyrian $INSTALL/usr/local/bin
  
  mkdir -p $INSTALL/usr/config/opentyrian
  cp -r $PKG_DIR/config/* $INSTALL/usr/config/opentyrian

  mkdir -p $INSTALL/usr/config/ports/opentyrian
  cp -rf $PKG_BUILD/tyrian21/* $INSTALL/usr/config/ports/opentyrian
}

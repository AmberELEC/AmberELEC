# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="opentyrian"
PKG_VERSION="e60885b7069d6723b103abbb2e3f09c227fc8d86"
PKG_SHA256="943df0331412821bdb66609599f32256b9d21546b3c52a0124897c79c0d8da8c"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/opentyrian/opentyrian"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_net"
PKG_LONGDESC="An open-source port of the DOS shoot-em-up Tyrian."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  CFLAGS+=" -I$(get_build_dir SDL2)/include"
  CFLAGS+=" -I$(get_build_dir SDL2_net)"
  export LDFLAGS="${LDFLAGS} -lSDL2 -lSDL2_net"
}

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

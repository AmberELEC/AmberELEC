# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="gptokeyb"
PKG_VERSION="c643c0c063b04ff2f8a317b64d42dea47c315063"
PKG_ARCH="aarch64"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/EmuELEC/gptokeyb"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain libevdev SDL2"
PKG_TOOLCHAIN="make"
GET_HANDLER_SUPPORT="git"

pre_make_target() {
  cp -f $PKG_DIR/Makefile $PKG_BUILD
  CFLAGS+=" -I$(get_build_dir SDL2)/include -D_REENTRANT"
  CFLAGS+=" -I$(get_build_dir libevdev)"
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp $PKG_BUILD/gptokeyb $INSTALL/usr/bin
}


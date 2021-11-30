# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021-present 351ELEC (https://github.com/351ELEC)

PKG_NAME="box64"
PKG_VERSION="06bbf93bf876c107ff41593a75fe6fa8a6d6a779"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/ptitSeb/box64"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain gl4es"
PKG_LONGDESC="Box64 - Linux Userspace x86_64 Emulator with a twist, targeted at ARM64 Linux devices"
PKG_TOOLCHAIN="cmake"
GET_HANDLER_SUPPORT="git"

PKG_CMAKE_OPTS_TARGET=" -DRK3326=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo"

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/box64/lib
  cp $PKG_BUILD/x64lib/* $INSTALL/usr/share/box64/lib
  cp $PKG_BUILD/.${TARGET_NAME}/box64 $INSTALL/usr/share/box64/
}

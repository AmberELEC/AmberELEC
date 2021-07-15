# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present 351ELEC (https://github.com/351ELEC)

PKG_NAME="box86"
PKG_VERSION="e9cc8d43a9ac922795ad02fd06b3d492e700c3ce"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/ptitSeb/box86"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain gl4es"
PKG_LONGDESC="Box86 - Linux Userspace x86 Emulator with a twist, targeted at ARM Linux devices"
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET=" -DRK3326=1 -DCMAKE_BUILD_TYPE=Release"

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/box86/lib
  cp $PKG_BUILD/x86lib/* $INSTALL/usr/share/box86/lib
  cp $PKG_BUILD/.${TARGET_NAME}/box86 $INSTALL/usr/share/box86/
}

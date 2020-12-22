# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="libgo2"
PKG_VERSION="0b9a90dada632ccbf600a7f40c6e9982580da7ea"
PKG_SHA256="3d480b58a9cc12d9cd0d1cc1512582a76ae1c333646d34ccdced7b786316638b"
PKG_ARCH="arm aarch64"
PKG_LICENSE="LGPL"
PKG_DEPENDS_TARGET="toolchain libevdev librga"
PKG_SITE="https://github.com/OtherCrashOverride/libgo2"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_LONGDESC="Support library for the ODROID-GO Advance "
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET=" config=release ARCH= INCLUDES=-I$SYSROOT_PREFIX/usr/include/libdrm -I$SYSROOT_PREFIX/usr/include "

makeinstall_target() {
mkdir -p $INSTALL/usr/lib
cp libgo2.so $INSTALL/usr/lib

mkdir -p $SYSROOT_PREFIX/usr/include/go2
cp src/*.h $SYSROOT_PREFIX/usr/include/go2

mkdir -p $SYSROOT_PREFIX/usr/lib
cp libgo2.so $SYSROOT_PREFIX/usr/lib
}


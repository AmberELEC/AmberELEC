# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="libgo2"
PKG_VERSION="5878bedaf6f1ec0726cf9a6c6e2577134a5a1245"
PKG_SHA256="89ad1cf229d581fa8e4498f4f4c526215176e79885e935bd7dc48c5872655f92"
PKG_ARCH="arm aarch64"
PKG_LICENSE="LGPL"
PKG_DEPENDS_TARGET="toolchain libevdev librga"
PKG_SITE="https://github.com/navy1978/libgo2"
PKG_URL="$PKG_SITE.git"
PKG_LONGDESC="Support library for the ODROID-GO Advance "
PKG_TOOLCHAIN="make"
GET_HANDLER_SUPPORT="git"



if [ "${DEVICE}" = "RG351P" ]
then
  PKG_PATCH_DIRS="RG351P"
else
  PKG_PATCH_DIRS="RG351V"
fi

PKG_MAKE_OPTS_TARGET=" config=release ARCH= INCLUDES=-I$SYSROOT_PREFIX/usr/include/libdrm -I$SYSROOT_PREFIX/usr/include "

makeinstall_target() {
mkdir -p $INSTALL/usr/lib
cp libgo2.so $INSTALL/usr/lib

mkdir -p $SYSROOT_PREFIX/usr/include/go2
cp src/*.h $SYSROOT_PREFIX/usr/include/go2

mkdir -p $SYSROOT_PREFIX/usr/lib
cp libgo2.so $SYSROOT_PREFIX/usr/lib
}


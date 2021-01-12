# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

PKG_NAME="mali-bifrost"
PKG_VERSION="43b24f4a2c7cda2144210e6ca6c62eaaf8a29497"
PKG_SHA256="1b6b81d29d352595c2f2ace495c311bd0189d55352b5c4bc6d5a2022eafb9a39"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/rockchip-linux/libmali"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libdrm"
PKG_LONGDESC="The Mali GPU library used in Rockchip Platform for Odroidgo Advance"

if [ $ARCH == "aarch64" ]
then
  ARCHDIR="aarch64-linux-gnu"
else
  ARCHDIR="arm-linux-gnueabihf"
fi

post_makeinstall_target() {

	for lib in $INSTALL/usr/lib/libmali.so.1 \
		   $INSTALL/usr/lib/libmali.so \
		   $INSTALL/usr/lib/libmali.so.1.9.0 \
		   $SYSROOT_PREFIX/usr/lib/libmali.so.1 \
		   $SYSROOT_PREFIX/usr/lib/libmali.so \
		   $SYSROOT_PREFIX/usr/lib/libmali.so.1.9.0
	do
		rm -f ${lib}
	done

	cp -f $PKG_BUILD/lib/$ARCHDIR/libmali-bifrost-g31-rxp0-gbm.so $INSTALL/usr/lib/libmali.so.1.9.0
	cp -f $PKG_BUILD/lib/$ARCHDIR/libmali-bifrost-g31-rxp0-gbm.so $SYSROOT_PREFIX/usr/lib/libmali.so.1.9.0
	ln -sf $SYSROOT_PREFIX/usr/include/KHR/mali_khrplatform.h $SYSROOT_PREFIX/usr/include/KHR/khrplatform.h

	ln -sf libmali.so.1.9.0 $SYSROOT_PREFIX/usr/lib/libmali.so.1
	ln -sf libmali.so.1.9.0 $INSTALL/usr/lib/libmali.so.1
	ln -sf libmali.so.1 $SYSROOT_PREFIX/usr/lib/libmali.so
	ln -sf libmali.so.1 $INSTALL/usr/lib/libmali.so

	for lib in libmali-bifrost-g31-rxp0-gbm.so \
	  	   libGLESv1_CM.so.1 \
		   libGLESv1_CM.so \
		   libGLESv2.so.2 \
		   libGLESv2.so \
		   libGLESv3.so.3 \
		   libGLESv3.so \
		   libMaliOpenCL.so.1 \
		   libMaliOpenCL.so 
	do
		rm -f $INSTALL/usr/lib/${lib}
		ln -sf libmali.so $INSTALL/usr/lib/${lib}
		rm -f $SYSROOT_PREFIX/usr/lib/${lib}
		ln -sf libmali.so $SYSROOT_PREFIX/usr/lib/${lib}
	done
}

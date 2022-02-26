# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2021-present 351ELEC (https://github.com/351ELEC)

PKG_NAME="mali-midgard"
PKG_VERSION="ad4c28932c3d07c75fc41dd4a3333f9013a25e7f"
PKG_SHA256="8b7bd1f969e778459d79a51e5f58c26eda0b818580966daba16ee2fc08f4c151"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/351ELEC/libmali"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libdrm"
PKG_LONGDESC="The Mali GPU library used in Rockchip Platform for RK3399"

if [ $ARCH == "aarch64" ]
then
  ARCHDIR="aarch64-linux-gnu"
else
  ARCHDIR="arm-linux-gnueabihf"
fi

post_makeinstall_target() {

  cp -f $PKG_BUILD/lib/$ARCHDIR/libmali-midgard-t86x-r18p0-gbm.so $INSTALL/usr/lib/libmali.so.1.9.0
  cp -f $PKG_BUILD/lib/$ARCHDIR/libmali-midgard-t86x-r18p0-gbm.so $SYSROOT_PREFIX/usr/lib/libmali.so.1.9.0

  ln -sf $SYSROOT_PREFIX/usr/include/KHR/mali_khrplatform.h $SYSROOT_PREFIX/usr/include/KHR/khrplatform.h

  ln -sf libmali.so.1.9.0 $SYSROOT_PREFIX/usr/lib/libvulkan.so.1
  ln -sf libmali.so.1.9.0 $INSTALL/usr/lib/libvulkan.so.1
  ln -sf libvulkan.so.1 $SYSROOT_PREFIX/usr/lib/libvulkan.so
  ln -sf libvulkan.so.1 $INSTALL/usr/lib/libvulkan.so

  ln -sf libmali.so.1.9.0 $SYSROOT_PREFIX/usr/lib/libmali.so.1
  ln -sf libmali.so.1.9.0 $INSTALL/usr/lib/libmali.so.1
  ln -sf libmali.so.1 $SYSROOT_PREFIX/usr/lib/libmali.so
  ln -sf libmali.so.1 $INSTALL/usr/lib/libmali.so

  ln -sf libmali.so.1 $SYSROOT_PREFIX/usr/lib/libgbm.so.1
  ln -sf libgbm.so.1 $SYSROOT_PREFIX/usr/lib/libgbm.so
  ln -sf libmali.so.1 $INSTALL/usr/lib/libgbm.so.1
  ln -sf libgbm.so.1 $INSTALL/usr/lib/libgbm.so

  for lib in libmali-midgard-t86x-r18p0-gbm.so \
  	   libGLESv1_CM.so.1 \
	   libGLESv1_CM.so \
	   libGLESv2.so.2 \
	   libGLESv2.so \
	   libGLESv3.so.3 \
	   libGLESv3.so \
	   libEGL.so.1 \
	   libEGL.so \
	   libMaliOpenCL.so.1 \
	   libMaliOpenCL.so 
  do
	rm -f $INSTALL/usr/lib/${lib}
	ln -sf libmali.so $INSTALL/usr/lib/${lib}
	rm -f $SYSROOT_PREFIX/usr/lib/${lib}
	ln -sf libmali.so $SYSROOT_PREFIX/usr/lib/${lib}
  done
}

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

PKG_NAME="mali-bifrost"
PKG_VERSION="ad4c28932c3d07c75fc41dd4a3333f9013a25e7f"
PKG_SHA256="8b7bd1f969e778459d79a51e5f58c26eda0b818580966daba16ee2fc08f4c151"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/rockchip-linux/libmali"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libdrm"
PKG_LONGDESC="The Mali GPU library used in Rockchip Platform for Odroidgo Advance"

if [ $ARCH == "aarch64" ]
then
  ARCHDIR="aarch64-linux-gnu"
  VULKAN_SO="libmali.so_rk3326_gbm_arm64_r13p0_with_vulkan_and_cl"
else
  ARCHDIR="arm-linux-gnueabihf"
  VULKAN_SO="libmali.so_rk3326_gbm_arm32_r13p0_with_vulkan_and_cl"
fi

# This is gross, but it's what we have for now.
VULKAN_PKG="rk3326_r13p0_gbm_with_vulkan_and_cl.zip"
VULKAN_SUM="ef1a18fabf270d0a6029917d6b0e6237d328613c2f8be4d420ea23e022288dd9"

post_makeinstall_target() {

  if [ ! -e "${SOURCES}/${PKG_NAME}/${VULKAN_PKG}" ]
  then
    curl -Lo "${SOURCES}/${PKG_NAME}/${VULKAN_PKG}" "https://dn.odroid.com/RK3326/ODROID-GO-Advance/${VULKAN_PKG}"
  fi
  DLD_SUM=$(sha256sum "${SOURCES}/${PKG_NAME}/${VULKAN_PKG}" | awk '{printf $1}')
  if [ ! "${DLD_SUM}" == "${VULKAN_SUM}" ]
  then
    echo "Vulkan package mismatch, exiting."
    exit 1
  fi

  CWD=$(pwd)
  cd ${SOURCES}/${PKG_NAME}
  unzip -o "${SOURCES}/${PKG_NAME}/${VULKAN_PKG}"
  cd "${CWD}"

  for lib in $INSTALL/usr/lib/libmali.so* \
	   $INSTALL/usr/lib/libgbm.so* \
           $INSTALL/usr/lib/libvulkan.so* \
	   $SYSROOT_PREFIX/usr/lib/libmali.so* \
	   $SYSROOT_PREFIX/usr/lib/libgbm.so* \
           $SYSROOT_PREFIX/usr/lib/libvulkan.so*
  do
	rm -f ${lib}
  done

  #cp -f $PKG_BUILD/lib/$ARCHDIR/libmali-bifrost-g31-rxp0-gbm.so $INSTALL/usr/lib/libmali.so.1.9.0
  #cp -f $PKG_BUILD/lib/$ARCHDIR/libmali-bifrost-g31-rxp0-gbm.so $SYSROOT_PREFIX/usr/lib/libmali.so.1.9.0
  cp -f "${SOURCES}/${PKG_NAME}/${VULKAN_SO}" $INSTALL/usr/lib/libmali.so.1.9.0
  cp -f "${SOURCES}/${PKG_NAME}/${VULKAN_SO}" $SYSROOT_PREFIX/usr/lib/libmali.so.1.9.0

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

  for lib in libmali-bifrost-g31-rxp0-gbm.so \
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

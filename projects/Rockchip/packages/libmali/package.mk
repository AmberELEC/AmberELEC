# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="libmali"
PKG_VERSION="9b1375cfb1e54f89f4f5ae574d809cca486970f5"
PKG_SHA256="8075c69f7c1123c91fb0021931651a3948859421a47d03762e76310bce38d45c"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/AmberELEC/libmali"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libdrm"
PKG_LONGDESC="The Mali GPU library used in Rockchip Platform"

PKG_PATCH_DIRS="${MALI_FAMILY}"

post_makeinstall_target() {
	# remove all the extra blobs, we only need one
	rm -rf ${INSTALL}/usr

	if [ ${ARCH} == "arm" ]
	then
	  ARCHDIR="lib/arm-linux-gnueabihf"
	else
	  ARCHDIR="lib/aarch64-linux-gnu"
	fi

	if [ "${MALI_FAMILY}" == "g31" ]; then
		BLOB="libmali-bifrost-g31-r13p0-gbm.so"
	elif [ "${MALI_FAMILY}" == "t86x" ]; then
		BLOB="libmali-midgard-t86x-r18p0-gbm.so"
	fi

	mkdir -p ${INSTALL}/usr/lib/
	cp ${PKG_BUILD}/${ARCHDIR}/${BLOB} ${INSTALL}/usr/lib/libmali.so.1
	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libmali.so

	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libEGL.so
	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libEGL.so.1
	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libgbm.so
	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libgbm.so.1
	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libGLESv2.so
	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libGLESv2.so.2
	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libGLESv3.so
	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libGLESv3.so.3
	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libGLESv1_CM.so
	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libGLESv1_CM.so.1
	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libGLES_CM.so
	ln -sf libmali.so.1 ${INSTALL}/usr/lib/libGLES_CM.so.1

	mkdir -p ${SYSROOT_PREFIX}/usr/lib
	cp ${PKG_BUILD}/${ARCHDIR}/${BLOB} ${SYSROOT_PREFIX}/usr/lib/libmali.so.1
	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libmali.so

	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libEGL.so
	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libEGL.so.1
	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libgbm.so
	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libgbm.so.1
	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libGLESv2.so
	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libGLESv2.so.2
	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libGLESv3.so
	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libGLESv3.so.3
	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libGLESv1_CM.so
	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libGLESv1_CM.so.1
	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libGLES_CM.so
	ln -sf libmali.so.1 ${SYSROOT_PREFIX}/usr/lib/libGLES_CM.so.1
}
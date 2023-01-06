# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC team
PKG_NAME="linux-pam"
PKG_VERSION="1.5.2"
PKG_SHA256="e4ec7131a91da44512574268f493c6d8ca105c87091691b8e9b56ca685d4f94d"
PKG_URL="https://github.com/linux-pam/linux-pam/releases/download/v${PKG_VERSION}/Linux-PAM-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-prelude \
	--disable-isadir \
  --disable-selinux \
  --disable-cracklib \
  --disable-audit \
	--disable-nis \
	--disable-db \
	--disable-regenerate-docu \
	--enable-securedir=/lib/security \
	--libdir=/lib"


makeinstall_target() {
  mkdir -p ${INSTALL}/etc/pam.d
  cp ${PKG_DIR}/pam.d/* ${INSTALL}/etc/pam.d
  
  mkdir -p ${INSTALL}/usr/lib
  cp -P ${PKG_BUILD}/.${TARGET_NAME}/libpam/.libs/*.so* ${INSTALL}/usr/lib
  cp -P ${PKG_BUILD}/.${TARGET_NAME}/libpam_misc/.libs/*.so* ${INSTALL}/usr/lib
  rm -rf ${INSTALL}/usr/lib/libpam_misc.so*T
  cp -P ${PKG_BUILD}/.${TARGET_NAME}/libpamc/.libs/*.so* ${INSTALL}/usr/lib

  mkdir -p ${INSTALL}/usr/lib/security
  cp -P ${PKG_BUILD}/.${TARGET_NAME}/modules/*/.libs/*.so ${INSTALL}/usr/lib/security

  mkdir -p ${INSTALL}/usr/lib/security/pam_filter
  cp -P ${PKG_BUILD}/.${TARGET_NAME}/modules/pam_filter/upperLOWER/.libs/upperLOWER ${INSTALL}/usr/lib/security/pam_filter
}



# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="iw"
PKG_VERSION="6.17"
PKG_SHA256="7d182e498289ab39b257da6780d562e415377107f50358ee5b55b8cfe40b1e33"
PKG_LICENSE="ISC"
PKG_SITE="https://wireless.docs.kernel.org/en/latest/en/users/documentation/iw.html"
PKG_URL="https://www.kernel.org/pub/software/network/${PKG_NAME}/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libnl"
PKG_LONGDESC="A new nl80211 based CLI configuration utility for wireless devices."
PKG_BUILD_FLAGS="-lto"

pre_configure_target() {
  export CFLAGS="${TARGET_CFLAGS} --sysroot=${SYSROOT_PREFIX} -I${SYSROOT_PREFIX}/usr/include"
  export LDFLAGS="${TARGET_LDFLAGS} --sysroot=${SYSROOT_PREFIX} -L${SYSROOT_PREFIX}/usr/lib -pthread"
}

make_target() {
  make CC="${CC}" \
       PKG_CONFIG="${PKG_CONFIG}" \
       CFLAGS="${CFLAGS}" \
       LDFLAGS="${LDFLAGS}" \
       V=1
}

makeinstall_target() {
  make install DESTDIR="${INSTALL}" PREFIX="/usr" SBINDIR="/usr/sbin"
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/iw
  cp ${PKG_DIR}/scripts/setregdomain ${INSTALL}/usr/lib/iw
}
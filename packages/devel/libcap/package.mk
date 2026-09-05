# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2010-2011 Roman Weber (roman@openelec.tv)
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libcap"
PKG_VERSION="2.78"
PKG_SHA256="0d621e562fd932ccf67b9660fb018e468a683d7b827541df27813228c996bb11"
PKG_LICENSE="GPL-2.0-only OR BSD-3-Clause"
PKG_SITE="https://git.kernel.org/pub/scm/libs/libcap/libcap.git/log/"
PKG_URL="https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="make:host gcc:host"
PKG_LONGDESC="A library for getting and setting POSIX.1e capabilities."
PKG_BUILD_FLAGS="+pic"

post_unpack() {
  mkdir -p "${PKG_BUILD}/.${HOST_NAME}"
  find "${PKG_BUILD}" -mindepth 1 -maxdepth 1 ! -name ".*" -exec cp -r {} "${PKG_BUILD}/.${HOST_NAME}/" \;
  mkdir -p "${PKG_BUILD}/.${TARGET_NAME}"
  find "${PKG_BUILD}" -mindepth 1 -maxdepth 1 ! -name ".*" -exec cp -r {} "${PKG_BUILD}/.${TARGET_NAME}/" \;
}

make_host() {
  cd "${PKG_BUILD}/.${HOST_NAME}"

  local clean_host_cflags="${HOST_CFLAGS//-I${TOOLCHAIN}\/include/}"

  make CC="${CC}" \
       AR="${AR}" \
       RANLIB="${RANLIB}" \
       CFLAGS="${clean_host_cflags} -I${PKG_BUILD}/.${HOST_NAME}/libcap/include" \
       BUILD_CFLAGS="${clean_host_cflags} -I${PKG_BUILD}/.${HOST_NAME}/libcap/include" \
       BUILD_LDFLAGS="${HOST_LDFLAGS}" \
       PAM_CAP=no \
       lib=/lib \
       USE_GPERF=no \
       -C libcap libcap.pc libcap.a
}

make_target() {
  cd "${PKG_BUILD}/.${TARGET_NAME}"
  make CC="${CC}" \
       AR="${AR}" \
       RANLIB="${RANLIB}" \
       CFLAGS="${TARGET_CFLAGS} -I${PKG_BUILD}/.${TARGET_NAME}/libcap/include" \
       BUILD_CC="${HOST_CC}" \
       BUILD_CFLAGS="${HOST_CFLAGS} -I${PKG_BUILD}/.${TARGET_NAME}/libcap/include" \
       BUILD_LDFLAGS="${HOST_LDFLAGS}" \
       PAM_CAP=no \
       lib=/lib \
       USE_GPERF=no \
       -C libcap libcap.pc libcap.a
}

makeinstall_host() {
  cd "${PKG_BUILD}/.${HOST_NAME}"

  mkdir -p "${TOOLCHAIN}/lib"
  cp -f libcap/libcap.a "${TOOLCHAIN}/lib/"

  mkdir -p "${TOOLCHAIN}/lib/pkgconfig"
  cp -f libcap/libcap.pc "${TOOLCHAIN}/lib/pkgconfig/"

  mkdir -p "${TOOLCHAIN}/include/sys"
  cp -f libcap/include/sys/capability.h "${TOOLCHAIN}/include/sys/"
}

makeinstall_target() {
  cd "${PKG_BUILD}/.${TARGET_NAME}"

  mkdir -p "${SYSROOT_PREFIX}/usr/lib"
  cp -f libcap/libcap.a "${SYSROOT_PREFIX}/usr/lib/"

  mkdir -p "${SYSROOT_PREFIX}/usr/lib/pkgconfig"
  cp -f libcap/libcap.pc "${SYSROOT_PREFIX}/usr/lib/pkgconfig/"

  mkdir -p "${SYSROOT_PREFIX}/usr/include/sys"
  cp -f libcap/include/sys/capability.h "${SYSROOT_PREFIX}/usr/include/sys/"
}
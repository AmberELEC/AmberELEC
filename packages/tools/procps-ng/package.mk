# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="procps-ng"
PKG_VERSION="4.0.7"
PKG_SHA256="707d4d43c78b1ff9d0286a4839465e78fa1a82896ec97d3508765b31a808b4b2"
PKG_LICENSE="GPL-2.0-or-later AND LGPL-2.1-or-later"
PKG_SITE="https://gitlab.com/procps-ng/procps"
PKG_URL="https://gitlab.com/procps-ng/procps/-/archive/v${PKG_VERSION}/procps-v${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_LONGDESC="Command line and full screen utilities for browsing procfs."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_func_malloc_0_nonnull=yes \
                           ac_cv_func_realloc_0_nonnull=yes \
                           --disable-shared \
                           --disable-modern-top \
                           --enable-static \
                           --without-systemd \
                           --disable-nls \
                           --with-ncurses"

PKG_MAKE_OPTS_TARGET="src/free src/top/top library/libproc2.la library/libproc2.pc"

PKG_MAKEINSTALL_OPTS_TARGET="install-libLTLIBRARIES install-pkgconfigDATA install-library_libproc2_la_includeHEADERS"

pre_configure_target() {
  export CFLAGS="${TARGET_CFLAGS} --sysroot=${SYSROOT_PREFIX} -I${SYSROOT_PREFIX}/usr/include -I${SYSROOT_PREFIX}/usr/include/ncurses -I${SYSROOT_PREFIX}/usr/include/ncursesw"
  export LDFLAGS="${TARGET_LDFLAGS} --sysroot=${SYSROOT_PREFIX} -L${SYSROOT_PREFIX}/usr/lib"
  
  # Ensure terminfo is included alongside ncurses
  local ncurses_libs="-L${SYSROOT_PREFIX}/usr/lib -lncursesw -ltinfow"
  if [ ! -f "${SYSROOT_PREFIX}/usr/lib/libtinfow.so" ] && [ ! -f "${SYSROOT_PREFIX}/usr/lib/libtinfow.a" ]; then
    ncurses_libs="-L${SYSROOT_PREFIX}/usr/lib -lncurses -ltinfo"
  fi

  export NCURSES_CFLAGS="-I${SYSROOT_PREFIX}/usr/include -I${SYSROOT_PREFIX}/usr/include/ncurses"
  export NCURSES_LIBS="${ncurses_libs}"
  export NCURSESW_CFLAGS="-I${SYSROOT_PREFIX}/usr/include -I${SYSROOT_PREFIX}/usr/include/ncursesw"
  export NCURSESW_LIBS="${ncurses_libs}"
  export WATCH_NCURSES_LIBS="${ncurses_libs}"

  if [ -f "${PKG_BUILD}/configure" ]; then
    sed -i -e "s/UNKNOWN/${PKG_VERSION}/" "${PKG_BUILD}/configure"
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp -P ${PKG_BUILD}/.${TARGET_NAME}/src/free ${INSTALL}/usr/bin/
  cp -P ${PKG_BUILD}/.${TARGET_NAME}/src/top/top ${INSTALL}/usr/bin/

  make DESTDIR=${SYSROOT_PREFIX} -j1 ${PKG_MAKEINSTALL_OPTS_TARGET}

  if [ -f "${PKG_BUILD}/library/include/readproc.h" ]; then
    mkdir -p ${SYSROOT_PREFIX}/usr/include/libproc2
    sed 's@proc/misc.h@procps/misc.h@' \
      ${PKG_BUILD}/library/include/readproc.h \
      >${SYSROOT_PREFIX}/usr/include/libproc2/readproc.h
  fi
}
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="nano"
PKG_VERSION="7.1"
PKG_SHA256="57ba751e9b7519f0f6ddee505202e387c75dde440c1f7aa1b9310cc381406836"
PKG_LICENSE="GPL"
PKG_SITE="https://www.nano-editor.org/"
PKG_URL="https://www.nano-editor.org/dist/v${PKG_VERSION%%.*}/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_LONGDESC="Nano is an enhanced clone of the Pico text editor."

PKG_CONFIGURE_OPTS_TARGET="--enable-utf8 \
                           --disable-nls \
                           --disable-libmagic \
                           --disable-wrapping \
                           NCURSESW_CONFIG=none"

pre_configure_target() {
  local ncurses_libs="-L${SYSROOT_PREFIX}/usr/lib -lncursesw -ltinfow"
  if [ ! -f "${SYSROOT_PREFIX}/usr/lib/libtinfow.so" ] && [ ! -f "${SYSROOT_PREFIX}/usr/lib/libtinfow.a" ]; then
    ncurses_libs="-L${SYSROOT_PREFIX}/usr/lib -lncurses -ltinfo"
  fi

  export CFLAGS="${TARGET_CFLAGS} --sysroot=${SYSROOT_PREFIX} -I${SYSROOT_PREFIX}/usr/include -I${SYSROOT_PREFIX}/usr/include/ncursesw -I${SYSROOT_PREFIX}/usr/include/ncurses"
  export CPPFLAGS="${TARGET_CPPFLAGS} -I${SYSROOT_PREFIX}/usr/include -I${SYSROOT_PREFIX}/usr/include/ncursesw -I${SYSROOT_PREFIX}/usr/include/ncurses"
  export LDFLAGS="${TARGET_LDFLAGS} --sysroot=${SYSROOT_PREFIX} -L${SYSROOT_PREFIX}/usr/lib"
  export LIBS="${ncurses_libs}"
  export NCURSESW_CFLAGS="-I${SYSROOT_PREFIX}/usr/include -I${SYSROOT_PREFIX}/usr/include/ncursesw"
  export NCURSESW_LIBS="${ncurses_libs}"
  export CURSES_LIB="${ncurses_libs}"
}

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/share/nano

  mkdir -p ${INSTALL}/etc
  cp -a ${PKG_DIR}/config/* ${INSTALL}/etc/

  mkdir -p ${INSTALL}/usr/share/nano
  for FILE_TYPES in \
    css \
    html \
    java \
    javascript \
    json \
    php \
    python \
    sh \
    xml
  do
    cp -a ${PKG_BUILD}/syntax/${FILE_TYPES}.nanorc ${INSTALL}/usr/share/nano/
  done
}
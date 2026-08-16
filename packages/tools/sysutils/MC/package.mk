# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011-present AlexELEC (http://alexelec.in.ua)

PKG_NAME="MC"
PKG_VERSION="4.8.33"
PKG_SHA256="cae149d42f844e5185d8c81d7db3913a8fa214c65f852200a9d896b468af164c"
PKG_LICENSE="GPL"
PKG_SITE="http://www.midnight-commander.org/"
PKG_URL="http://ftp.midnight-commander.org/mc-${PKG_VERSION}.tar.xz"
PKG_SOURCE_NAME="${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain libtool:host gettext:host glib libssh2 pcre slang"
PKG_LONGDESC="Midnight Commander is a visual file manager"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET=" \
  --prefix=/usr \
  --sysconfdir=/etc \
  --with-screen=slang \
  --with-sysroot=${SYSROOT_PREFIX} \
  --disable-aspell \
  --without-diff-viewer \
  --disable-doxygen-doc \
  --disable-doxygen-dot \
  --disable-doxygen-html \
  --with-gnu-ld \
  --without-libiconv-prefix \
  --without-libintl-prefix \
  --without-gpm-mouse \
  --disable-mclib \
  --with-subshell \
  --with-edit \
  --with-internal-edit \
  --enable-vfs-extfs \
  --enable-vfs-ftp \
  --enable-vfs-sftp \
  --enable-vfs-tar \
  --without-x \
  --with-slang-includes=${SYSROOT_PREFIX}/usr/include"

pre_configure_target() {
  export LIBS="${LIBS} -lcrypto -lssl"
}

post_install() {
  rm -rf ${INSTALL}/etc/mc
  mkdir -p  ${INSTALL}/usr/config/mc
    cp -a ${PKG_DIR}/etc/* ${INSTALL}/usr/config/mc
    ln -sf /storage/.config/mc ${INSTALL}/etc/mc
}

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-2020 Team LibreELEC
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)
# Copyright (C) 2022-present Fewtarius

PKG_NAME="bash"
PKG_VERSION="5.1.16"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/bash/"
PKG_URL="http://ftpmirror.gnu.org/bash/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses readline"
PKG_LONGDESC="The GNU Bourne Again shell."

PKG_CONFIGURE_OPTS_TARGET="--with-curses \
                           --enable-readline \
                           --without-bash-malloc \
                           --with-installed-readline"

post_install() {
  ln -sf bash ${INSTALL}/usr/bin/sh
  mkdir -p ${INSTALL}/etc
  cat <<EOF >${INSTALL}/etc/shells
/usr/bin/bash
/usr/bin/sh
EOF
  chmod 4755 ${INSTALL}/usr/bin/bash
}
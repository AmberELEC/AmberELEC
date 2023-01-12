# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

PKG_NAME="socat"
PKG_VERSION="1.7.3.4"
PKG_SHA256="972374ca86f65498e23e3259c2ee1b8f9dbeb04d12c2a78c0c9b5d1cb97dfdfc"
PKG_LICENSE="GPLv2+"
PKG_SITE="http://www.dest-unreach.org/socat/download"
PKG_URL="${PKG_SITE}/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A multipurpose relay (SOcket CAT)"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET+="	--disable-libwrap \
				--disable-readline \
				--enable-termios"


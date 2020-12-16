# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020-present Fewtarius

PKG_NAME="socat"
PKG_VERSION="1.7.3.4"
#PKG_SHA256=""
PKG_LICENSE="GPLv2+"
PKG_SITE="http://www.dest-unreach.org/socat/download"
PKG_URL="$PKG_SITE/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A multipurpose relay (SOcket CAT)"
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET+="	--disable-libwrap \
				--disable-readline \
				--enable-termios"

#makeinstall_target() { 
#  mkdir -p $INSTALL/usr/bin
#  cp -rf $PKG_BUILD/socat $INSTALL/usr/bin
#  cp -rf $PKG_BUILD/procan $INSTALL/usr/bin
#  cp -rf $PKG_BUILD/filan $INSTALL/usr/bin
#}

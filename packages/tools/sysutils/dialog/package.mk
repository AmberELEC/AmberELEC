# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="dialog"
PKG_VERSION="1.3-20221229"
PKG_SHA256="d5663d016003e5260fa485f5e9c2ddffb386508f3bd0687d4fa3635ea9942b8e"
PKG_LICENSE="GNU-2.1"
PKG_SITE="https://invisible-mirror.net/archives/dialog"
PKG_URL="${PKG_SITE}/dialog-${PKG_VERSION}.tgz"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_LONGDESC="This version of dialog, formerly known as cdialog is based on the Debian package for dialog 0.9a"
PKG_TOOLCHAIN="auto"

PKG_CONFIGURE_OPTS_TARGET="--with-ncurses --disable-rpath-hack"



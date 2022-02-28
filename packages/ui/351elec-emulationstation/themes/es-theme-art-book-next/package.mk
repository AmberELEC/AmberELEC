# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021 351ELEC team (https://github.com/351ELEC/351ELEC)

PKG_NAME="es-theme-art-book-next"
PKG_REV="1"
PKG_VERSION="d294393eb0836613e53727388617a9a6401ae874"
PKG_ARCH="any"
PKG_LICENSE="CUSTOM"
PKG_SITE="https://github.com/anthonycaccese/es-theme-art-book-next"
PKG_URL="$PKG_SITE.git"
GET_HANDLER_SUPPORT="git"
PKG_SHORTDESC="ArtBook Next"
PKG_LONGDESC="Art Book Next - 351ELEC default theme"
PKG_TOOLCHAIN="manual"

if [ "${DEVICE}" = "RG552" ]; then
	makeinstall_target() {
		mkdir -p $INSTALL/usr/config/emulationstation/themes/$PKG_NAME
		cp -rf * $INSTALL/usr/config/emulationstation/themes/$PKG_NAME
	}
fi

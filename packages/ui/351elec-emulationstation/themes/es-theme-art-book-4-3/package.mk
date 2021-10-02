# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020 351ELEC team (https://github.com/fewtarius/351ELEC)

PKG_NAME="es-theme-art-book-4-3"
PKG_REV="1"
PKG_VERSION="29f8112c0bd947a6798d2f4531ba2744a747d48a"
PKG_ARCH="any"
PKG_LICENSE="CUSTOM"
PKG_SITE="https://github.com/szalik-rg351/es-theme-art-book-4-3"
PKG_URL="$PKG_SITE.git"
GET_HANDLER_SUPPORT="git"
PKG_SHORTDESC="ArtBook"
PKG_LONGDESC="Art Book - 351ELEC default theme for the RG351V/MP"
PKG_TOOLCHAIN="manual"


if [ "${DEVICE}" = "RG351V" ] || [ "${DEVICE}" = "RG351MP" ]; then
	makeinstall_target() {
		mkdir -p $INSTALL/usr/config/emulationstation/themes/$PKG_NAME
		cp -rf * $INSTALL/usr/config/emulationstation/themes/$PKG_NAME
	}
fi

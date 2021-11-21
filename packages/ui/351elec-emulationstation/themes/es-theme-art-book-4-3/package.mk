# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021 351ELEC team (https://github.com/351ELEC/351ELEC)

PKG_NAME="es-theme-art-book-4-3"
PKG_REV="1"
PKG_VERSION="b619b52eb97a24b166b97bd23e1c47e9c0c5b63a"
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

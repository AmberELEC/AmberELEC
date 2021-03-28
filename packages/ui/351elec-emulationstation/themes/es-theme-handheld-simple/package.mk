# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020 351ELEC team (https://github.com/fewtarius/351ELEC)

PKG_NAME="es-theme-handheld-simple"
PKG_REV="1"
PKG_ARCH="any"
PKG_VERSION="006281da9212ff2c79954b8b3937398062b53ecb"
PKG_LICENSE="CUSTOM"
PKG_SITE="https://github.com/Rican7/es-theme-handheld-simple"
PKG_URL="$PKG_SITE.git"
GET_HANDLER_SUPPORT="git"
PKG_SHORTDESC="Handheld Simple"
PKG_LONGDESC="Handheld Simple theme"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p $INSTALL/usr/config/emulationstation/themes/$PKG_NAME
  cp -rf * $INSTALL/usr/config/emulationstation/themes/$PKG_NAME
}

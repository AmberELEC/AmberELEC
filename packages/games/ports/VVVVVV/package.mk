# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020 351ELEC team (https://github.com/fewtarius/351ELEC)

PKG_NAME="VVVVVV"
PKG_VERSION="9f5f697dda4a5eb26eecfffed92fb8445905b746"
PKG_SHA256="d6128dc1fee43aef47719990e3cf9c306c97caa2df409f70215b0be8b9fc4c65"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="CUSTOM"
PKG_SITE="https://github.com/TerryCavanagh/VVVVVV"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2"
PKG_SHORTDESC="VVVVVV License: https://github.com/TerryCavanagh/VVVVVV/blob/master/LICENSE.md"
PKG_LONGDESC="VVVVVV is a platform game all about exploring one simple mechanical idea - what if you reversed gravity instead of jumping?"
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET=" desktop_version"

makeinstall_target() {
  mkdir -p $INSTALL/usr/local/bin
  cp VVVVVV $INSTALL/usr/local/bin
}

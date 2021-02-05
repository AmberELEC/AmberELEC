# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="rs97-commander-sdl2"
PKG_VERSION="ba0e7f96b7e4c2bc1d7f9e809590f0cf3007488b"
PKG_SHA256="55a0c2c57af0443eb0f258405772a81651353ef2bcefde993a40ed1992e52b83"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/zulhailmie/rs97-commander-sdl2"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2-git SDL2_image SDL2_gfx SDL2_ttf"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="Two-pane commander for RetroFW and RG-350 (fork of Dingux Commander)"

pre_configure_target() {
sed -i "s|sdl2-config|${SYSROOT_PREFIX}/usr/bin/sdl2-config|" Makefile
sed -i "s|CC=g++|CC=${CXX}|" Makefile

[[ "$DEVICE" == "OdroidGoAdvance" ]] &&	OGA=1 || OGA=0
[[ "$DEVICE" == "RG351P" ]] && OGA=1 || OGA=0

PKG_MAKE_OPTS_TARGET=" ODROIDGO=${OGA} CC=$CXX"
	
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/config/emuelec/configs/fm
  cp DinguxCommander $INSTALL/usr/bin/
  cp -rf res $INSTALL/usr/config/emuelec/configs/fm/
}

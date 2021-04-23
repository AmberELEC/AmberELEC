# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mupen64plus-nx"
PKG_VERSION="a6a6bfd56c8a8d6077182c280bf9eb33c7fba0e8"
PKG_SHA256="1c6cef039f6ad872d8cea332810fe5ba783ab59384580dfe200180b87e00aa49"
if [ $PROJECT = "Amlogic" ]; then
PKG_VERSION="b785150465048fa88f812e23462f318e66af0be0"
PKG_SHA256=""
fi
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mupen64plus-libretro-nx"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain nasm:host $OPENGLES"
PKG_SECTION="libretro"
PKG_SHORTDESC="mupen64plus + RSP-HLE + GLideN64 + libretro"
PKG_LONGDESC="mupen64plus + RSP-HLE + GLideN64 + libretro"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-lto"

pre_configure_target() {
  sed -e "s|^GIT_VERSION ?.*$|GIT_VERSION := \" ${PKG_VERSION:0:7}\"|" -i Makefile

if [ $ARCH == "arm" ]; then
if [ ${PROJECT} = "Amlogic-ng" ]; then
	PKG_MAKE_OPTS_TARGET+=" platform=AMLG12B"
	sed -i "s|GLES = 1|GLES3 = 1|g" Makefile
	sed -i "s|-lGLESv2|-lGLESv3|g" Makefile
elif [ "${PROJECT}" = "Amlogic" ]; then
	PKG_MAKE_OPTS_TARGET+=" platform=amlogic"
elif [[ "${DEVICE}" =~ RG351 ]]; then
	sed -i "s|GLES = 1|GLES3 = 1|g" Makefile
	sed -i "s|-lGLESv2|-lGLESv3|g" Makefile
	sed -i "s|cortex-a53|cortex-a35|g" Makefile
	PKG_MAKE_OPTS_TARGET+=" platform=odroidgoa"
	fi
else
	if [ ${PROJECT} = "Amlogic-ng" ]; then
		PKG_MAKE_OPTS_TARGET+=" platform=odroid64 BOARD=N2"
		sed -i "s|GLES = 1|GLES3 = 1|g" Makefile
		sed -i "s|-lGLESv2|-lGLESv3|g" Makefile
	elif [ "${PROJECT}" = "Amlogic" ]; then 
		sed -i "s|GLES = 1|GLES = 1|g" Makefile
		sed -i "s|-lGLESv2|-lGLESv2|g" Makefile
		PKG_MAKE_OPTS_TARGET+=" platform=amlogic64"
	elif [[ "${DEVICE}" =~ RG351 ]]; then
		sed -i "s|GLES = 1|GLES3 = 1|g" Makefile
		sed -i "s|-lGLESv2|-lGLESv3|g" Makefile
		PKG_MAKE_OPTS_TARGET+=" platform=amlogic64"
	fi
fi
}


makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp mupen64plus_next_libretro.so $INSTALL/usr/lib/libretro/
}

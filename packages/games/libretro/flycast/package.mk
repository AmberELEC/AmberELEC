################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="flycast"
PKG_VERSION="ae670ea28fdbb9f08149cb598312a71a0970ca67"
PKG_SHA256="661b9871d100aa910ec3440377b7ef905df9a4f6f5ee01ec7e3a364524436c6f"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/flycast"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain $OPENGLES"
PKG_LONGDESC="Flycast is a multiplatform Sega Dreamcast emulator "
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-gold"

pre_configure_target() {
sed -i 's/define CORE_OPTION_NAME "reicast"/define CORE_OPTION_NAME "flycast"/g' core/libretro/libretro_core_option_defines.h 
# Flycast defaults to -O3 but then CHD v5 do not seem to work on EmuELEC so we change it to -O2 to fix the issue
#PKG_MAKE_OPTS_TARGET="ARCH=arm HAVE_OPENMP=1 GIT_VERSION=${PKG_VERSION:0:7} FORCE_GLES=1 SET_OPTIM=-O2 HAVE_LTCG=0"
PKG_MAKE_OPTS_TARGET="ARCH=arm HAVE_OPENMP=1 GIT_VERSION=${PKG_VERSION:0:7} FORCE_GLES=1 HAVE_LTCG=0"

if [ "${ARCH}" == "aarch64" ]; then
PKG_MAKE_OPTS_TARGET+=" WITH_DYNAREC=arm64"
fi
}

pre_make_target() {
   export BUILD_SYSROOT=$SYSROOT_PREFIX

  if [ "$OPENGLES_SUPPORT" = "yes" ]; then
    PKG_MAKE_OPTS_TARGET+=" FORCE_GLES=1 LDFLAGS=-lrt"
  fi

if [ "${ARCH}" == "aarch64" ]; then
  case $PROJECT in
    Amlogic-ng)
      PKG_MAKE_OPTS_TARGET+=" platform=odroid-n2"
      ;;
    Amlogic)
      PKG_MAKE_OPTS_TARGET+=" platform=arm64"
    ;;  
  esac
else
   case $PROJECT in
    Amlogic-ng)
      PKG_MAKE_OPTS_TARGET+=" platform=AMLG12B"
      ;;
    Amlogic)
      PKG_MAKE_OPTS_TARGET+=" platform=AMLGX"
    ;;  
  esac
fi
  
 if [[ "$DEVICE" =~ RG351 ]] || [[ "$DEVICE" =~ RG552 ]]; then
	if [ "$ARCH" == "arm" ]; then
	PKG_MAKE_OPTS_TARGET+=" platform=classic_armv8_a35"
	else
	PKG_MAKE_OPTS_TARGET+=" platform=arm64"
	fi
 fi 
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp flycast_libretro.so $INSTALL/usr/lib/libretro/
}

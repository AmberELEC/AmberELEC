################################################################################
#      This file is part of LibreELEC - http://www.libreelec.tv
#      Copyright (C) 2016 Team LibreELEC
#      Copyright (C) 2020-present 351ELEC (https://github.com/351ELEC)
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="mame2015"
PKG_VERSION="e6a7aa4d53726e61498f68d6b8e2c092a2169fa2"
PKG_SHA256="ae4683b6f95b6d14abcf91a1d7a8649c527a222ad17a70fe5ad5d3d48e959974"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mame2015-libretro"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="libretro"
PKG_SHORTDESC="Late 2014/Early 2015 version of MAME (0.160-ish) for libretro. Compatible with MAME 0.160 romsets."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-lto"

pre_make_target() {
  export REALCC=$CC
  export CC=$CXX
  export LD=$CXX
}

pre_configure_target() {
  if [ "$DEVICE" == "OdroidGoAdvance" ] || [[ "$DEVICE" =~ RG351 ]]; then
	PKG_MAKE_OPTS_TARGET=" platform=armv8-neon-hardfloat-cortex-a35"
	sed -i 's/CCOMFLAGS += -mstructure-size-boundary=32//g' Makefile
	sed -i 's/-DSDLMAME_NO64BITIO//g' Makefile
	sed -i 's/LDFLAGS += -Wl,--fix-cortex-a8 -Wl,--no-as-needed//g' Makefile
  fi
}

makeinstall_target() {
  aarch64-linux-gnu-strip -s *.so
  mkdir -p $INSTALL/usr/lib/libretro
  cp mame*_libretro.so $INSTALL/usr/lib/libretro/
}

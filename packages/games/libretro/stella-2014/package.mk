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

PKG_NAME="stella-2014"
PKG_VERSION="f843da44b1828110f697bbc13142cf3b782e2f04"
PKG_SHA256="dc42991208a18a1940ca5ba7464cec4f8c96ddb06cefa1977e87a52b58087c20"
PKG_REV="1"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/libretro/stella2014-libretro"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="Port of Stella to libretro."
PKG_LONGDESC="Stella is a multi-platform Atari 2600 VCS emulator released under the GNU General Public License (GPL)."
PKG_TOOLCHAIN="make"

pre_configure_target() {
PKG_MAKE_OPTS_TARGET=" -C $PKG_BUILD/ -f Makefile platform=emuelec-arm64"
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/stella2014_libretro.so $INSTALL/usr/lib/libretro/
}

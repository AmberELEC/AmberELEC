################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)
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

PKG_NAME="gpsp"
PKG_VERSION="f0f0b31f9ab95946965b75fed8d31e19290f3d43"
PKG_SHA256="724d293719887657bbba1fd73960d9fd9d399fb7ba61ffb14151929983e272fd"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/gpsp"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="gpSP for libretro."
PKG_LONGDESC="gameplaySP is a Gameboy Advance emulator for Playstation Portable"

PKG_IS_ADDON="no"
PKG_TOOLCHAIN="make"
PKG_AUTORECONF="no"

make_target() {
  if [ "$ARCH" == "arm" ]; then
    make CC=$CC platform=unix
  else
    make CC=$CC platform=arm64
  fi  
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp gpsp_libretro.so $INSTALL/usr/lib/libretro/
}

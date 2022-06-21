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

PKG_NAME="pokemini"
PKG_VERSION="b8b56e3bb094f0bb81d2ae44530a8981ab4819e5"
PKG_SHA256="a46a42509c4bc249002d9d91f42a4dd9664ebc7555490b8d074039615e297f8a"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/pokemini"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="Obscure nintendo handheld emulator (functional,no color files or savestates currently)"
PKG_LONGDESC="Obscure nintendo handheld emulator (functional,no color files or savestates currently)"

PKG_IS_ADDON="no"
PKG_TOOLCHAIN="make"
PKG_AUTORECONF="no"

if [[ "$DEVICE" == RG351P ]] || [[ "$DEVICE" == RG351V ]]; then
  PKG_PATCH_DIRS="rumble"
fi

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp pokemini_libretro.so $INSTALL/usr/lib/libretro/
}

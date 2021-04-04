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

PKG_NAME="stella"
PKG_VERSION="31260facef5380ac49886f1f7aed578fee74bc51"
PKG_SHA256="230aae0be28c671c71f75baa2f62707e8dcc7d1b61b50c36ec968a4e0c5b1e0f"
PKG_REV="1"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/stella-emu/stella"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="Port of Stella to libretro."
PKG_LONGDESC="Stella is a multi-platform Atari 2600 VCS emulator released under the GNU General Public License (GPL)."
PKG_TOOLCHAIN="make"

pre_configure_target() {
if [ "$ARCH" == "arm" ]; then
PKG_MAKE_OPTS_TARGET=" -C $PKG_BUILD/src/libretro -f Makefile platform=emuelec"
else
PKG_MAKE_OPTS_TARGET=" -C $PKG_BUILD/src/libretro -f Makefile platform=emuelec-arm64"
fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/src/libretro/stella_libretro.so $INSTALL/usr/lib/libretro/
}

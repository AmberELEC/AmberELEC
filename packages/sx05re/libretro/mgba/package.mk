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

PKG_NAME="mgba"
PKG_VERSION="43bc47742f5c642559d259d461cd16278f89e604"
#PKG_SHA256="bcb0370625ecc85d906ed5e267abba2ea35c8ba8b6b5b68839e95709131b00a9"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MPLv2.0"
PKG_SITE="https://github.com/mgba-emu/mgba"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="mGBA Game Boy Advance Emulator"
PKG_LONGDESC="mGBA is a new emulator for running Game Boy Advance games. It aims to be faster and more accurate than many existing Game Boy Advance emulators, as well as adding features that other emulators lack."

PKG_IS_ADDON="no"
#PKG_TOOLCHAIN="make"
PKG_AUTORECONF="no"
#PKG_USE_CMAKE="no"

PKG_CMAKE_OPTS_TARGET="-DBUILD_LIBRETRO=ON \
		       -DSKIP_LIBRARY=ON \
		       -DBUILD_QT=OFF \
		       -DBUILD_SDL=ON \
		       -DUSE_DISCORD_RPC=OFF \
		       -DUSE_GDB_STUB=OFF \
		       -DUSE_FFMPEG=ON \
		       -DUSE_LZMA=OFF \
		       -DUSE_SQLITE3=OFF \
		       -DUSE_DEBUGGERS=OFF \
		       -DUSE_EDITLINE=OFF \
		       -DUSE_ELF=OFF \
		       -DBUILD_GL=OFF \
		       -DBUILD_GLES2=ON \
		       -DBUILD_GLES3=ON \
		       -DUSE_EPOXY=OFF \
		       -DCMAKE_BUILD_TYPE=Release"

  if [[ "$ARCH" =~ "arm" ]]; then
    PKG_CMAKE_OPTS_TARGET+="-DHAVE_NEON=ON"
  fi

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp mgba_libretro.so $INSTALL/usr/lib/libretro/
}

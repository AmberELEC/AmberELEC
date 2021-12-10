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

PKG_NAME="piemu"
PKG_VERSION="0785214f13746bdfd709b1909f007e213b470ba1"
PKG_ARCH="any"
PKG_LICENSE="ZLIB"
PKG_SITE="https://github.com/yonkuma/piemu"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2"
PKG_PRIORITY="optional"
PKG_SHORTDESC="piemu"
PKG_LONGDESC="Piemu Standalone"
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET=" -DUSE_SDL2=ON -DSDL2_INCLUDE_DIRS=$SYSROOT_PREFIX/usr/include/SDL2 -DSDL2_LIBRARIES=$SYSROOT_PREFIX/usr/lib"
    LDFLAGS="$LDFLAGS -lSDL2"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/local/bin
  cp ${PKG_BUILD}/.aarch64-libreelec-linux-gnueabi/piemu ${INSTALL}/usr/local/bin
  chmod 755 ${INSTALL}/usr/local/bin/piemu
  cp ${PKG_BUILD}/.aarch64-libreelec-linux-gnueabi/tools/mkpfi ${INSTALL}/usr/local/bin
  chmod 755 ${INSTALL}/usr/local/bin/mkpfi
  cp ${PKG_BUILD}/.aarch64-libreelec-linux-gnueabi/tools/pfar ${INSTALL}/usr/local/bin
  chmod 755 ${INSTALL}/usr/local/bin/pfar
  cp ${PKG_DIR}/bin/piemu.sh ${INSTALL}/usr/local/bin
  chmod 755 ${INSTALL}/usr/local/bin/piemu.sh
}

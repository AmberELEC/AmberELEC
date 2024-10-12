# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="fceumm"
PKG_VERSION="e226068f979cd8fbfc3be9780d16cfb1405095b0"
PKG_SHA256="9c7b6dc78bb15ba0f8fd07391bb78acd62af1106a5741f5088cbee320cb29cee"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/libretro-fceumm"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="FCEUX is a Nintendo Entertainment System (NES), Famicom, and Famicom Disk System (FDS) emulator."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/Makefile.libretro
}

make_target() {
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp fceumm_libretro.so ${INSTALL}/usr/lib/libretro/
}

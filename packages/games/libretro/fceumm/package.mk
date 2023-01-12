# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="fceumm"
PKG_VERSION="159f27a1f16e74f4e1f7f424477d3bb098302ea0"
PKG_SHA256="ef7e654b6110538bce66f175f89fb7b74ddbf131c815ad0cf0063992dec07869"
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

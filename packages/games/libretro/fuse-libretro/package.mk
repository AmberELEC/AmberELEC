# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="fuse-libretro"
PKG_VERSION="6fd07d90acc38a1b8835bf16539b833f21aaa38f"
PKG_SHA256="3cd16935036913c97fcd3ee0a21867da3f7c4e851d17ecf39064b4444d2837ef"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/fuse-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A port of the Fuse Unix Spectrum Emulator to libretro "
PKG_TOOLCHAIN="make"

make_target() {
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp fuse_libretro.so ${INSTALL}/usr/lib/libretro/
}

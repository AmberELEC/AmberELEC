# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="dosbox-pure"
PKG_VERSION="5d6ab819db61eaef63c9eba25ae16bc22566ab9b"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/schellingb/dosbox-pure"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A port of DOSBox to libretro"
PKG_TOOLCHAIN="make"

pre_patch() {
  find $(echo "${PKG_BUILD}" | cut -f1 -d\ ) -type f -exec dos2unix -q {} \;
}

make_target() {
  make platform=emuelec-hh
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp dosbox_pure_libretro.so ${INSTALL}/usr/lib/libretro/
}

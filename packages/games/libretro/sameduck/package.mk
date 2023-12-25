# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="sameduck"
PKG_VERSION="5619abdb01cee6bedb47599cdb5532c318443b52"
PKG_SHA256="101bd2876c0b6c63abc91b3971fa1c203c955d4a86a5c54ce6172ee5ab729456"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/LIJI32/SameBoy"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_GIT_CLONE_BRANCH="SameDuck"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Mega Duck/Cougar Boy emulator written in C"
PKG_TOOLCHAIN="make"

make_target() {
  make -C libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp build/bin/sameduck_libretro.so ${INSTALL}/usr/lib/libretro/
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="sameboy"
PKG_VERSION="09138330990da32362246c7034cf4de2ea0a2a2b"
PKG_SHA256="9ef470c7c6bee83bbeb1e861a1c76b722d78de5e5a3849e7132d03d40fa8828d"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/libretro/sameboy"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_GIT_CLONE_BRANCH="buildbot"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Gameboy and Gameboy Color emulator written in C"
PKG_TOOLCHAIN="make"

make_target() {
  make -C libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp libretro/sameboy_libretro.so ${INSTALL}/usr/lib/libretro/
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="fbalpha2012"
PKG_VERSION="7f8860543a81ba79c0e1ce1aa219af44568c628a"
PKG_SHA256="8de890151718424518b30bdef563a5922d1aa2442fd23a8453503cb7c42e65a7"
PKG_LICENSE="Non-commercial"
PKG_SITE="https://github.com/libretro/fbalpha2012"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Port of Final Burn Alpha 2012 to Libretro"
PKG_TOOLCHAIN="make"

make_target() {
  cd svn-current/trunk
  make -f makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp fbalpha2012_libretro.so ${INSTALL}/usr/lib/libretro/
}

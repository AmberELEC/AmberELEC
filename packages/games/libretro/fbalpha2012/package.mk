# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="fbalpha2012"
PKG_VERSION="b7ac554c53561d41640372f23dab15cd6fc4f0c4"
PKG_SHA256="f75997a46d1b55d5bf8f3b612ea38bdca2293621e5ea03e24b33406238e86e3c"
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

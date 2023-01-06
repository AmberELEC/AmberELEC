# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="fbalpha2019"
PKG_VERSION="0581797db6fdffd826086b053ced4b6b29bb6678"
PKG_SHA256="96812000a349e413d63bc5ef04ab7a330bb0b4194047c048ed6ec549b8274936"
PKG_LICENSE="Non-commercial"
PKG_SITE="https://github.com/libretro/fbalpha"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Currently, FB Alpha supports games on Capcom CPS-1 and CPS-2 hardware, SNK Neo-Geo hardware, Toaplan hardware, Cave hardware, and various games on miscellaneous hardware."
PKG_TOOLCHAIN="make"

make_target() {
  sed -i 's/"FB Alpha"/"FB Alpha 2019"/g' src/burner/libretro/libretro.cpp
  make -f makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_DIR}/fbalpha2019_libretro.info ${INSTALL}/usr/lib/libretro/
  cp fbalpha_libretro.so ${INSTALL}/usr/lib/libretro/fbalpha2019_libretro.so
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mgba"
PKG_VERSION="88b22735dbdbc4d6236ed872ef21ea1b4d2fc492"
PKG_SHA256="03275ff79f966543ee9bf03b8b0c3198df219815691ad196da5a16e46eae1ca7"
PKG_LICENSE="MPLv2.0"
PKG_SITE="https://github.com/libretro/mgba"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="mGBA is a new emulator for running Game Boy Advance games. It aims to be faster and more accurate than many existing Game Boy Advance emulators, as well as adding features that other emulators lack."
PKG_TOOLCHAIN="make"

if [[ "${DEVICE}" == RG351P ]] || [[ "${DEVICE}" == RG351V ]]; then
  PKG_PATCH_DIRS="rumble"
fi

make_target() {
  cd ${PKG_BUILD}
  if [[ "${ARCH}" =~ "arm" ]]; then
    make -f Makefile.libretro platform=unix-armv HAVE_NEON=1
  else
    make -f Makefile.libretro platform=goadvance
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mgba_libretro.so ${INSTALL}/usr/lib/libretro/
}

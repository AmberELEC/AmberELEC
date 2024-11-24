# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mgba"
PKG_VERSION="747362c02d2e71ee7c363e8dcb240925be8af906"
PKG_SHA256="9a49e66b28296f11e04161dacf8cfc89f113504b87f40f5857a884d513c394a8"
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

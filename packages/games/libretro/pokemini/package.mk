# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="pokemini"
PKG_VERSION="a62d157d2fc10a1400ffa435b4beb08f7a7d8e09"
PKG_SHA256="fef1e2323c97da67bfa097beb3bb81aed63fccc877041d0f78f7e78942a27554"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/pokemini"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Obscure nintendo handheld emulator (functional,no color files or savestates currently)"
PKG_TOOLCHAIN="make"

if [[ "${DEVICE}" == RG351P ]] || [[ "${DEVICE}" == RG351V ]]; then
  PKG_PATCH_DIRS="rumble"
fi

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp pokemini_libretro.so ${INSTALL}/usr/lib/libretro/
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="px68k"
PKG_VERSION="a50c2498ae3c85fd466a8f1085a07b9857f5d79d"
PKG_SHA256="f9f0fd4202916f797df310108dec355c75c285195abe1155644142ce3c6328d9"
PKG_LICENSE="Unknown"
PKG_SITE="https://github.com/libretro/px68k-libretro"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Portable SHARP X68000 Emulator for PSP, Android and other platforms"
PKG_TOOLCHAIN="make"

if [[ "${DEVICE}" == RG351P ]] || [[ "${DEVICE}" == RG351V ]]; then
  PKG_PATCH_DIRS="rumble"
fi

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp px68k_libretro.so ${INSTALL}/usr/lib/libretro/
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="handy"
PKG_VERSION="63db085af671bad2929078c55434623b7d4632a1"
PKG_SHA256="3e95202814d7dd16a0bf1277aa4dcc82acd82a5fcee9965db103133f274383b8"
PKG_LICENSE="Zlib"
PKG_SITE="https://github.com/libretro/libretro-handy"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Handy is an Atari Lynx Emulator for Windows 95/98/NT/2000. Handy was the original name of the Lynx project that was started at Epyx and then finished by Atari."
PKG_TOOLCHAIN="make"

if [ ${ARCH} = "aarch64" ]; then
  PKG_MAKE_OPTS_TARGET=" platform=emuelec"
else
  PKG_MAKE_OPTS_TARGET=" platform=classic_armv8_a35"
fi

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp handy_libretro.so ${INSTALL}/usr/lib/libretro/
}

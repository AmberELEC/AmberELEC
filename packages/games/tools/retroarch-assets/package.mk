# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="retroarch-assets"
PKG_VERSION="923b711dc6772a168d83dc8915e9260730fcf3a1"
PKG_SHA256="50e2628a09fef042981ad0efc1be9c5ebcf1a3b61c209b78b3cf1ac78e2cdc10"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/retroarch-assets"
PKG_URL="https://github.com/libretro/retroarch-assets/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="RetroArch assets. Background and icon themes for the menu drivers."
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  cd ../
  rm -rf .${TARGET_NAME}
}

makeinstall_target() {
  make install INSTALLDIR="${INSTALL}/usr/share/retroarch-assets"
}

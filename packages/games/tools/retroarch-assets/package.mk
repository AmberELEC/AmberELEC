# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="retroarch-assets"
PKG_VERSION="4ec80faf1b5439d1654f407805bb66141b880826"
PKG_SHA256="1a5dfb3acb864bacd3f3fd0121c4904438ae52703187fc61d46f0d43500562aa"
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

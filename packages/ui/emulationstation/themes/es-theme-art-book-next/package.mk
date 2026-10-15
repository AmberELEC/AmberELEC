# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024 AmberELEC (https://github.com/AmberELEC)

PKG_NAME="es-theme-art-book-next"
PKG_VERSION="4ea9b03dba68ad4bc49e43315e1173901d282ceb"
PKG_ARCH="any"
PKG_LICENSE="CUSTOM"
PKG_SITE="https://github.com/AmberELEC/art-book-next-amberelec"
PKG_URL="${PKG_SITE}.git"
PKG_SHORTDESC="ArtBook Next"
PKG_LONGDESC="Art Book Next - AmberELEC default theme"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
    mkdir -p ${INSTALL}/usr/config/emulationstation/themes/${PKG_NAME}
    cp -rf * ${INSTALL}/usr/config/emulationstation/themes/${PKG_NAME}
}

if [ "${DEVICE}" = "RG503" ]; then
  PKG_VERSION="61e62c418e4e253ad8f466b1a4c1beb24c70c1d6"
  PKG_GIT_CLONE_BRANCH="rg503"
  PKG_SITE="https://github.com/navy1978/art-book-next-amberelec"
  PKG_URL="${PKG_SITE}.git"
fi

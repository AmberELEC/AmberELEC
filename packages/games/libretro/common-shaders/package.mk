# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present AmberELEC (https://github.com/AmberELEC)

### Don't update, newer commits have issues.
PKG_NAME="common-shaders"
PKG_VERSION="b7cdc50258908e8f1906f8fc13a2fac4a9796dc6"
PKG_SHA256="9cf8ac14e3f971b29421d556cf65b4234468f350d15b466abc635b7cec9ab6fa"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/RetroPie/common-shaders"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="emuelec"
PKG_LONGDESC="Manually converted libretro/common-shaders for arm devices treebranch pi"
PKG_GIT_CLONE_BRANCH="rpi"
PKG_TOOLCHAIN="make"

make_target() {
  : not
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/common-shaders/rpi
  cp -rf ${BUILD}/${PKG_NAME}-${PKG_VERSION}/* ${INSTALL}/usr/share/common-shaders/rpi
}


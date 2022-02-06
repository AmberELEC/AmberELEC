# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="klbi"
PKG_VERSION="c1de59df5fd7ac64fba9401906d5823e6995bbea"
PKG_GIT_CLONE_BRANCH="main"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/konsumschaf/klbi"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_TOOLCHAIN="manual"
PKG_SHORTDESC="LaunchBox Importer"
PKG_LONGDESC="Tool to import ROMs from a LaunchBox folder in /roms created by the Android Exporter from LaunchBox"

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp -a $PKG_BUILD/${PKG_NAME}.py $INSTALL/usr/bin
    chmod +x $INSTALL/usr/bin/${PKG_NAME}.py
}



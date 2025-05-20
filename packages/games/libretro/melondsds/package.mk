# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="melondsds"
PKG_VERSION="6dd9ae14e351b9fd5d6f43ea72a0957a93e52b89"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/JesseTG/melonds-ds"
PKG_URL="${PKG_SITE}.git"
PKG_GIT_CLONE_BRANCH="dev"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="MelonDS - Nintendo DS emulator for libretro"
PKG_TOOLCHAIN="cmake-make"

PKG_CMAKE_OPTS_TARGET=" -DCMAKE_BUILD_TYPE=Release \
                        -DCMAKE_RULE_MESSAGES=OFF \
                        -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
                        -DENABLE_OPENGL=OFF"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/.${TARGET_NAME}/src/libretro/melondsds_libretro.so ${INSTALL}/usr/lib/libretro/
}

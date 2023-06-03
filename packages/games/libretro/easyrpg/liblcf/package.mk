# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="liblcf"
PKG_VERSION="9c09529e3de0a4106470082ef48a00d4c3593c33"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/EasyRPG/liblcf"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain expat icu"
PKG_LONGDESC="Library to handle RPG Maker 2000/2003 and EasyRPG projects"
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_BUILD_TYPE=Release"

pre_make_target() {
  find ${PKG_BUILD} -name flags.make -exec sed -i "s:isystem :I:g" \{} \;
  find ${PKG_BUILD} -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
}

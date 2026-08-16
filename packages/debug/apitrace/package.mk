# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Fewtarius

PKG_NAME="apitrace"
PKG_VERSION="45a005875d348b055d5b88dca285c109dee90457"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/apitrace/apitrace"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A set of tools to trace, replay, and inspect OpenGL calls"

PKG_CMAKE_OPTS_TARGET="-DENABLE_GUI=false -DENABLE_X11=false"

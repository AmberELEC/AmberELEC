# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Fewtarius

PKG_NAME="apitrace"
PKG_VERSION="2a83ddd4f67014e2aacf99c6b203fd3f6b13c4f3"
PKG_SHA256="1bd282e4784725258f99fd8a1147502ceb7db3d7315a4e7a37d8d14ed33d5881"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/apitrace/apitrace"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A set of tools to trace, replay, and inspect OpenGL calls"

PKG_CMAKE_OPTS_TARGET="-DENABLE_GUI=false -DENABLE_X11=false"

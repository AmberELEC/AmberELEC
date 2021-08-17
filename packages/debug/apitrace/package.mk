# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Fewtarius

PKG_NAME="apitrace"
PKG_VERSION="d77e180d117f4667c18d2dad1109c7a04ae8f04f"
PKG_SHA256="64307523e6db10f928e34f758198fdd0971f1b578e9ca86fe4f309fb92a2c4dc"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/apitrace/apitrace"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A set of tools to trace, replay, and inspect OpenGL calls"

PKG_CMAKE_OPTS_TARGET="-DENABLE_GUI=false -DENABLE_X11=false"

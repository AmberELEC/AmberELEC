# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="librga"
PKG_VERSION="1fc02d56d97041c86f01bc1284b7971c6098c5fb"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GNU"
PKG_DEPENDS_TARGET="toolchain libdrm"
PKG_SITE="https://github.com/AmberELEC/linux-rga"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="The RGA driver userspace "
PKG_TOOLCHAIN="auto"

pre_make_target() {
  sed -i 's|fprintf(stderr, "librga:RGA_GET_VERSION|//fprintf(stderr, "librga:RGA_GET_VERSION|' ${PKG_BUILD}/normal/NormalRga.cpp
  sed -i 's|fprintf(stderr, "ctx=|//fprintf(stderr, "ctx=|' ${PKG_BUILD}/normal/NormalRga.cpp
  sed -i 's|printf("Rga built version|//printf("Rga built version|' ${PKG_BUILD}/RockchipRga.cpp
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="opusfile"
PKG_VERSION="58b229a"
PKG_SITE="https://github.com/xiph/opusfile"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain opus libogg openssl"
PKG_LONGDESC="Stand-alone decoder library for .opus streams"
PKG_TOOLCHAIN="configure"

pre_configure_target() {
  ${PKG_BUILD}/autogen.sh
}

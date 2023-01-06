# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

PKG_NAME="gzip"
PKG_VERSION="1.10"
PKG_SHA256="8425ccac99872d544d4310305f915f5ea81e04d0f437ef1a230dc9d1c819d7c0"
PKG_LICENSE="GPL"
PKG_SITE="https://ftp.gnu.org/gnu/gzip"
PKG_URL="https://ftp.gnu.org/gnu/gzip/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="gcc:host"
PKG_LONGDESC="GNU Gzip is a popular data compression program originally written by Jean-loup Gailly for the GNU project."


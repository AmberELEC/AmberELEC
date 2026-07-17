# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="waf"
PKG_VERSION="2.0.24"
PKG_SHA256="599ab1903b6f12f0683878d2cd4f73546e0ce26031efd05f3fbe5178e4ef8cda"
PKG_LICENSE="MIT"
PKG_SITE="https://waf.io"
PKG_URL="https://gitlab.com/ita1024/waf/-/archive/waf-${PKG_VERSION}/waf-waf-${PKG_VERSION}.tar.bz2"
PKG_SOURCE_DIR="waf-waf-${PKG_VERSION}"
PKG_LONGDESC="The Waf build system"
PKG_TOOLCHAIN="manual"

makeinstall_host() {
  (cd ${PKG_BUILD} && /usr/bin/python3 ./waf-light --make-waf --python=/usr/bin/python3 --interpreter='#!/usr/bin/python3')
  cp -pf ${PKG_BUILD}/waf ${TOOLCHAIN}/bin/
}

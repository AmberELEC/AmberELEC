# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="fakeroot"
PKG_VERSION="1.36.2"
PKG_SHA256="92ee28cd75ef17a178bb06d9b9f57fb54b068b6a72d4710cccfe8453701c734f"
PKG_LICENSE="GPL3"
PKG_SITE="https://tracker.debian.org/pkg/fakeroot"
PKG_URL="http://ftp.debian.org/debian/pool/main/f/fakeroot/${PKG_NAME}_${PKG_VERSION}.orig.tar.gz"
PKG_DEPENDS_HOST="ccache:host libcap:host autoconf:host libtool:host"
PKG_LONGDESC="fakeroot provides a fake root environment by means of LD_PRELOAD and SYSV IPC (or TCP) trickery."
PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_HOST="--with-gnu-ld"

pre_configure_host() {
  cd ${PKG_BUILD}
  ./bootstrap
}

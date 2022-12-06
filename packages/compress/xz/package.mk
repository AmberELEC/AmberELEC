# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xz"
PKG_VERSION="5.2.8"
PKG_SHA256="1f8a43d9fcf325d049a31fe4514dc8c44a6d00ce8860d48c4212d1e349d2a3ed"
PKG_LICENSE="GPL"
PKG_SITE="http://tukaani.org/xz/"
PKG_URL="http://tukaani.org/xz/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A free general-purpose data compression software with high compression ratio."
PKG_BUILD_FLAGS="+pic +pic:host"

# never build shared or k0p happens when building
# on fedora due to host selinux/liblzma
PKG_CONFIGURE_OPTS_HOST="--disable-shared --enable-static \
                         --disable-lzmadec \
                         --disable-lzmainfo \
                         --enable-lzma-links \
                         --disable-scripts \
                         --disable-nls"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared --enable-static"

post_makeinstall_target() {
  rm -rf ${INSTALL}
}

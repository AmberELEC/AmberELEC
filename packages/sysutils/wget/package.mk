# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="wget"
PKG_VERSION="1.21.2"
PKG_SHA256="e6d4c76be82c676dd7e8c61a29b2ac8510ae108a810b5d1d18fc9a1d2c9a2497"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/wget/"
PKG_URL="http://ftpmirror.gnu.org/wget/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="ccache:host gnutls:host"
PKG_LONGDESC="GNU Wget is a free software package for retrieving files using HTTP, HTTPS, FTP and FTPS"

PKG_CONFIGURE_OPTS_HOST="--disable-nls --disable-acl --without-selinux"

post_install() {
  echo -e "\nca_directory = /usr/lib/ssl" >> ${INSTALL}/etc/wgetrc
}

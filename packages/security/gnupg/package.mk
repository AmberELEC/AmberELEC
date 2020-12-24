# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

PKG_NAME="gnupg"
PKG_VERSION="1.4.21"
PKG_SHA256="6b47a3100c857dcab3c60e6152e56a997f2c7862c1b8b2b25adf3884a1ae2276"
PKG_LICENSE="GPL"
PKG_SITE="https://gnupg.org/ftp/gcrypt/gnupg"
PKG_URL="$PKG_SITE/gnupg-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib libgpg-error libgcrypt"
PKG_LONGDESC="The GNU Privacy Guard (GnuPG, GPG) is a complete and free implementation
of the OpenPGP and S/MIME standards."

PKG_CONFIGURE_OPTS_TARGET="	--disable-rpath  \
				--enable-minimal \
				--disable-regex  \
				--disable-asm    \
				--enable-bzip2   \
				--enable-aes     \
				--enable-rsa"
#makeinstall_target() {
#  make install DESTDIR="$INSTALL/../.INSTALL_PKG"
#}

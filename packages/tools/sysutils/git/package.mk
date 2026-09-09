# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="git"
PKG_VERSION="2.55.0"
PKG_SHA256="0842dc384a23ac33ba3e570c4f3a8ded85963ee4713b1cd21153c3db41813d1e"
PKG_LICENSE="GPLv2"
PKG_SITE="https://git-scm.com/"
PKG_URL="https://mirrors.edge.kernel.org/pub/software/scm/git/git-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl pcre curl libiconv zlib"
PKG_LONGDESC="Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency. "
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="ac_cv_fread_reads_directories=yes \
                           ac_cv_snprintf_returns_bogus=yes \
                           ac_cv_iconv_omits_bom=yes"

pre_configure_target() {
  export CFLAGS="${CFLAGS} -std=gnu17"
}

make_target() {
  cd ${PKG_BUILD}
  make CC="${CC}" AR="${AR}" CFLAGS="${CFLAGS}" NO_RUST=YesPlease git
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp git ${INSTALL}/usr/bin
}
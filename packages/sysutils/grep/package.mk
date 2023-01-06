# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="grep"
PKG_VERSION="3.7"
PKG_SHA256="5c10da312460aec721984d5d83246d24520ec438dd48d7ab5a05dbc0d6d6823c"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/grep/"
PKG_URL="http://ftpmirror.gnu.org/grep/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_LONGDESC="Grep searches one or more input files for lines containing a match to a specified pattern. By default, Grep outputs the matching lines."

PKG_CONFIGURE_OPTS_HOST="--disable-nls --disable-acl --without-selinux"

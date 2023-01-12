# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius
# Sodium License: https://libsodium.gitbook.io/doc/#license

PKG_NAME="libsodium"
PKG_VERSION="d1580db1b34b7c73abb960e5f464a87ce8b7ed7d"
PKG_SHA256="75902b344f2a2279698266dc53fb48dfa394d2f507ae81c8f935264bbed49588"
PKG_LICENSE="ISC"
PKG_SITE="https://github.com/jedisct1/libsodium"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_GIT_CLONE_BRANCH="stable"
PKG_DEPENDS_HOST="toolchain"
PKG_LONGDESC="A modern, easy-to-use software library for encryption, decryption, signatures, password hashing and more."
PKG_TOOLCHAIN="autotools"

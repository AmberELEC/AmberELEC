# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2010-2011 Roman Weber (roman@openelec.tv)
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="json-c"
PKG_VERSION="0.18"
PKG_SHA256="876ab046479166b869afc6896d288183bbc0e5843f141200c677b3e8dfb11724"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/json-c/json-c"
PKG_URL="https://s3.amazonaws.com/json-c_releases/releases/json-c-${PKG_VERSION%-*}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Implements a reference counting object model that allows you to easily construct JSON objects in C."

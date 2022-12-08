# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="setuptools"
PKG_VERSION="51.3.3" # don't change this, this will break webui install
PKG_SHA256="8e45c6cb18f81842421560f788521842572a91a0e64419e338a6a15828ccf076"
PKG_LICENSE="OSS"
PKG_SITE="https://pypi.org/project/setuptools"
PKG_URL="https://github.com/pypa/setuptools/archive/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="Python3:host"
PKG_LONGDESC="Replaces Setuptools as the standard method for working with Python module distributions."
PKG_TOOLCHAIN="manual"

make_host() {
  python3 bootstrap.py
}

makeinstall_host() {
  exec_thread_safe python3 setup.py install --prefix=${TOOLCHAIN}
}

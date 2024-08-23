# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="webui"
PKG_VERSION="8699e1d43349c7a89ec837e10016736a6b32b835"
PKG_GIT_CLONE_BRANCH="main"
PKG_ARCH="any"
PKG_LICENSE="GPL"

PKG_URL="https://github.com/AmberELEC/webui.git"

# NOTE:
# - linux-pam needed for login
# - binutils needed by pam-linux as it uses pythons 'ctypes.find_library' which uses 'objdump' to find system libraries (libpam.so)
PKG_DEPENDS_TARGET="Python3 setuptools:host linux-pam binutils"
PKG_SHORTDESC="AmberELEC Web Interface"
PKG_TOOLCHAIN="manual"

##########################################################################################################
#  LOCAL DEV - if you would like to make changes to webui locally - uncomment the following param PKG_URL
#  and build as follows.  If you don't use docker and DOCKER_WORK_DIR=/work, update PKG_URL to match your system
# ------------------------
# To ensure the source gets updated , you must remove source before each build or it will not get rebuilt.
# So build similar to this:
#   rm -rf ./sources/webui/ && DOCKER_WORK_DIR=/work DEVICE=RG552 ARCH=aarch64 PACKAGE=webui make docker-package-clean docker-package
##########################################################################################################
#PKG_URL="file:///work/webui"

makeinstall_target() {
  WEB_UI_DIR="${INSTALL}/usr/share/webui"
  EGGS_DIR=${WEB_UI_DIR}/eggs
  
  rm -rf "${WEB_UI_DIR}"
  mkdir -p "${EGGS_DIR}/.."
  
  # Use easy_install instead of pip as pip isn't in build I can't get setup.py to create the `.pth` file to make eggs work in PYTHONPATH
  #  - easy_install requires PYTHONPATH to be set during build
  #  - easy_install will copy dependencies directly into ${WEB_UI_DIR} so PYTHONPATH must include WEB_UI_DIR (/usr/share/webui) when run
  export PYTHONPATH="${EGGS_DIR}"
  python3 -m easy_install --install-dir ${EGGS_DIR}/ --always-copy ./

  #If we decide to make webui a python module - we could lean into that and not copy all this stuff manually
  cp -r *.py *.sh assets views "${WEB_UI_DIR}"

  cp -r ${PKG_DIR}/scripts/* ${WEB_UI_DIR}

}

post_install() {
  enable_service webui.service
}

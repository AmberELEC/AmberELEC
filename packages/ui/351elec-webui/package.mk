# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present 351ELEC Team

PKG_NAME="351elec-webui"
PKG_VERSION="adeb12b2da552f05d1b225531e329e5c6e03e1f6"
PKG_GIT_CLONE_BRANCH="main"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"

PKG_URL="https://github.com/351ELEC/351ELEC-webui.git"

PKG_DEPENDS_TARGET="Python3"
PKG_SHORTDESC="351ELEC Web Interface"
PKG_TOOLCHAIN="manual"

##########################################################################################################
#  LOCAL DEV - if you would like to make changes to 351elec-webui locally - uncomment the following param PKG_URL
#  and build as follows.  If you don't use docker and DOCKER_WORK_DIR=/work, update PKG_URL to match your system
# ------------------------
# To ensure the source gets updated , you must remove source before each build or it will not get rebuilt.
# So build similar to this:
#   rm -rf ./sources/351elec-webui/ && DOCKER_WORK_DIR=/work DEVICE=RG552 ARCH=aarch64 PACKAGE=351elec-webui make docker-package-clean docker-package
##########################################################################################################
#PKG_URL="file:///work/351elec-webui"

makeinstall_target() {
  WEB_UI_DIR="${INSTALL}/usr/share/351elec-webui"
  
  rm -rf "${WEB_UI_DIR}"
  mkdir -p "${WEB_UI_DIR}/.."
  
  # Use easy_install instead of pip as pip isn't in build I can't get setup.py to create the `.pth` file to make eggs work in PYTHONPATH
  #  - easy_install requires PYTHONPATH to be set during build
  #  - easy_install will copy dependencies directly into $WEB_UI_DIR so PYTHONPATH must include WEB_UI_DIR (/usr/share/351elec-webui) when run
  export PYTHONPATH="$WEB_UI_DIR"
  python3 -m easy_install --install-dir ${WEB_UI_DIR}/ --always-copy ./

  #If we decide to make webui a python module - we could lean into that and not copy all this stuff manually
  cp -r *.py *.sh assets views "${WEB_UI_DIR}"
}

post_install() {
  enable_service webui.service
}

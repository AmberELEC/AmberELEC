# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="solarus"
PKG_VERSION="3aec70b0556a8d7aed7903d1a3e4d9a18c5d1649"
PKG_ARCH="aarch64"
PKG_LICENSE="GPLv3"
PKG_SITE="https://gitlab.com/solarus-games/solarus"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain luajit glm libmodplug physfs"
PKG_LONGDESC="Action-RPG/Adventure 2D game engine"
PKG_TOOLCHAIN="cmake-make"
PKG_GIT_CLONE_BRANCH="master"

pre_configure_target() {
export LDFLAGS+=" -ldl"
PKG_CMAKE_OPTS_TARGET="-DSOLARUS_GL_ES=ON -DSOLARUS_GUI=OFF -DSOLARUS_USE_LUAJIT=ON -DSOLARUS_TESTS=OFF"
}

pre_makeinstall_target() {
mkdir -p ${INSTALL}/usr/bin
cp ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin

mkdir -p ${INSTALL}/usr/config/solarus
if [[ "${DEVICE}" == RG351MP ]] || [[ "${DEVICE}" == RG552 ]]; then
  cp ${PKG_DIR}/config/RG351MP/* ${INSTALL}/usr/config/solarus
else
  cp ${PKG_DIR}/config/RG351P/* ${INSTALL}/usr/config/solarus
fi
}

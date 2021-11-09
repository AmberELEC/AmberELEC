# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="librga"
PKG_VERSION="06fc7c40a087809abb9402ca257f7a481f58031b"
PKG_SHA256="c763ca979fd7afaefc6c1f3628fbedef778849b2d152719230904c8ba2a457aa"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GNU"
PKG_DEPENDS_TARGET="toolchain libdrm"
PKG_SITE="https://github.com/rockchip-linux/linux-rga"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_LONGDESC="The RGA driver userspace "
PKG_TOOLCHAIN="auto"
PKG_GIT_CLONE_BRANCH="master"

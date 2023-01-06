# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

PKG_NAME="vulkan-loader"
PKG_VERSION="6fcd515be5b305d9a68ba94b911f84c76a30887e"
#PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="apache-2.0"
PKG_DEPENDS_TARGET="toolchain vulkan-headers"
PKG_SITE="https://github.com/KhronosGroup/Vulkan-Loader"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="Khronos official Vulkan ICD desktop loader for Windows, Linux, and MacOS."

PKG_CMAKE_OPTS_TARGET="-DBUILD_WSI_XCB_SUPPORT=OFF \
			-DBUILD_WSI_XLIB_SUPPORT=OFF \
			-DBUILD_WSI_WAYLAND_SUPPORT=OFF"


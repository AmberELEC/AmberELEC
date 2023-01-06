# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

PKG_NAME="vulkan-tools"
PKG_VERSION="a03938051ff67dac3e13dd011238fccc529e1fa5"
#PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="apache-2.0"
PKG_DEPENDS_TARGET="toolchain vulkan-headers"
PKG_SITE="https://github.com/KhronosGroup/Vulkan-Tools"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="Khronos official Vulkan Tools and Utilities for Windows, Linux, Android, and MacOS."

PKG_CMAKE_OPTS_TARGET="-DBUILD_WSI_XCB_SUPPORT=OFF \
                        -DBUILD_WSI_XLIB_SUPPORT=OFF \
                        -DBUILD_WSI_WAYLAND_SUPPORT=OFF \
                        -DBUILD_CUBE=OFF"


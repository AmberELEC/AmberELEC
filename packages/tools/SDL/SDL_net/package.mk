# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="SDL_net"
PKG_VERSION="1.2.8"
PKG_SHA256="5f4a7a8bb884f793c278ac3f3713be41980c5eedccecff0260411347714facb4"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://www.libsdl.org/"
PKG_URL="https://www.libsdl.org/projects/SDL_net/release/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain yasm:host alsa-lib systemd dbus SDL"
PKG_SECTION="multimedia"
PKG_SHORTDESC="This is a small sample cross-platform networking library, with a sample chat client and server application."
PKG_LONGDESC="This is a small sample cross-platform networking library, with a sample chat client and server application."

PKG_IS_ADDON="no"
PKG_USE_CMAKE="no"
PKG_AUTORECONF="no"

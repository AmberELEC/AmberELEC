# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="rs97-commander-sdl2"
PKG_VERSION="7907698c7ea950e393499947d6f9fd240fc0976a"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/dhwz/rs97-commander-sdl2"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_image SDL2_gfx SDL2_ttf"
PKG_LONGDESC="Two-pane commander for RetroFW and RG-350 (fork of Dingux Commander)"

pre_configure_target() {
  if [ "${DEVICE}" = "RG351V" ] || [ "${DEVICE}" = "RG351P" ]
  then
    sed -i 's|std::ifstream cFile ("/tmp/joypads/"+gamepad+".cfg");|std::ifstream cFile ("/tmp/joypads/"+gamepad+"_SDL.cfg");|g' window.cpp
  fi
  sed -i "s|sdl2-config|${SYSROOT_PREFIX}/usr/bin/sdl2-config|" Makefile

  if [ "${DEVICE}" = "RG351V" ] || [ "${DEVICE}" = "RG351MP" ]; then
    PKG_MAKE_OPTS_TARGET=" RG351V=1 CC=${CXX}"
  elif [ "${DEVICE}" = "RG552" ]; then
    PKG_MAKE_OPTS_TARGET=" RG552=1 CC=${CXX}"
  else
    PKG_MAKE_OPTS_TARGET=" RG351P=1 CC=${CXX}"
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/share/DinguxCommander/
  cp DinguxCommander ${INSTALL}/usr/bin/
  cp -rf res ${INSTALL}/usr/share/DinguxCommander/
}

# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2022-present Team AmberELEC (https://amberelec.org)

PKG_NAME="evdev-joystick"
PKG_VERSION="0"
PKG_LICENSE="GPL2"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="stella"
PKG_LONGDESC="evdev-joystick is used to set the deadzone for Linux 'evdev' joystick devices."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  cd "$(get_build_dir stella)/src/tools/evdev-joystick"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp evdev-joystick ${INSTALL}/usr/bin
}

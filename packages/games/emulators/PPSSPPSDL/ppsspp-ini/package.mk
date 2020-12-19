# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020 Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2020 351ELEC team (https://github.com/fewtarius/351ELEC)

PKG_NAME="ppsspp-ini"
PKG_VERSION="main"
#PKG_SHA256=""
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="CUSTOM"
PKG_SITE="https://github.com/jserodio/rg351p-ppsspp-settings"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="PPSSPPSDL"
PKG_SHORTDESC="PPSSPP INIs"
PKG_LONGDESC="A collection of PPSSPP INIs."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p $INSTALL/usr/config/ppsspp/PSP/SYSTEM
  ### Remove control mapping from the INIs
  for ini in inis/351ELEC/*ini
  do
    sed -i '/ControlMapping\|^Up\|^Down\|^Left\|^Right\|^Circle\|^Cross\|^Square\|^Triangle\|^L\ \|^R\ \|^An.\|^RightAn\|^SpeedToggle\|^Select\|^Start/d' $ini
  cat <<EOF >>$ini
[ControlMapping]
Up = 1-19,10-19
Down = 1-20,10-20
Left = 1-21,10-21
Right = 1-22,10-22
Circle = 1-52,10-190,10-4004
Cross = 1-54,10-189,10-4006
Square = 1-29,10-191,10-4005
Triangle = 1-47,10-188,10-4007
Start = 1-62,10-197
Select = 1-66,10-196
L = 1-45,10-192
R = 1-51,10-193
An.Up = 1-37,10-4002
An.Down = 1-39,10-4003
An.Left = 1-38,10-4001
An.Right = 1-40,10-4000
Analog limiter = 1-60
RapidFire = 1-59
Unthrottle = 1-61
SpeedToggle = 1-68
Rewind = 1-67
Pause = 1-111
EOF
  done
  cp inis/351ELEC/*ini $INSTALL/usr/config/ppsspp/PSP/SYSTEM
}

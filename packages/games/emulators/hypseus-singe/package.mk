# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="hypseus-singe"
PKG_VERSION="89cfe865bd9008d395d1de71e5ee0efbced63c3a"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL3"
PKG_SITE="https://github.com/DirtBagXon/hypseus-singe"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain SDL2 libvorbis"
PKG_LONGDESC="Hypseus is a fork of Daphne. A program that lets one play the original versions of many laserdisc arcade games on one's PC."
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET=" ./src"

pre_configure_target() {
  mkdir -p $INSTALL/usr/config/distribution/configs/hypseus
  ln -fs /storage/roms/laserdisc/roms $INSTALL/usr/config/distribution/configs/hypseus/roms
  ln -fs /storage/roms/laserdisc/roms $INSTALL/usr/config/distribution/configs/hypseus/singe
  ln -fs /usr/share/daphne/sound $INSTALL/usr/config/distribution/configs/hypseus/sound
  ln -fs /usr/share/daphne/fonts $INSTALL/usr/config/distribution/configs/hypseus/fonts
  ln -fs /usr/share/daphne/pics $INSTALL/usr/config/distribution/configs/hypseus/pics
}

post_makeinstall_target() {
  cp -rf $PKG_BUILD/doc/hypinput.ini $INSTALL/usr/config/distribution/configs/hypseus/
  ln -fs /storage/.config/distribution/configs/hypseus/hypinput.ini $INSTALL/usr/share/daphne/hypinput.ini
  mkdir -p $INSTALL/usr/bin
  cp $PKG_DIR/hypseus.sh $INSTALL/usr/bin/
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="hypseus"
PKG_VERSION="9ba6530805c9236655d023cfa3e31b3db2e09b39"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL3"
PKG_SITE="https://github.com/btolab/hypseus"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_ttf SDL2_image zlib libogg libvorbis libmpeg2"
PKG_LONGDESC="Hypseus is a fork of Daphne. A program that lets one play the original versions of many laserdisc arcade games on one's PC."
PKG_TOOLCHAIN="cmake"
GET_HANDLER_SUPPORT="git"

PKG_CMAKE_OPTS_TARGET=" ./src"

pre_configure_target() {
  mkdir -p $INSTALL/usr/config/distribution/configs/hypseus
  ln -fs /storage/roms/daphne/roms $INSTALL/usr/config/distribution/configs/hypseus/roms
  ln -fs /storage/roms/daphne/sound $INSTALL/usr/config/distribution/configs/hypseus/sound
  ln -fs /usr/share/daphne/fonts $INSTALL/usr/config/distribution/configs/hypseus/fonts
  ln -fs /usr/share/daphne/pics $INSTALL/usr/config/distribution/configs/hypseus/pics
  cp -a ${PKG_DIR}/config/*           ${INSTALL}/usr/config/hypseus
  cp $PKG_BUILD/doc/hypinput.ini $INSTALL/usr/config/distribution/configs/hypseus/
}

post_makeinstall_target() {
  ln -fs /storage/.config/distribution/configs/hypseus/hypinput.ini $INSTALL/usr/share/daphne/hypinput.ini
}

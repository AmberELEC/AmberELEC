# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="advancemame"
PKG_VERSION="1ac78eb12cf69dc5c01df4195d58f333530a4d87"
PKG_SHA256="60d65d02d1363af9a15917bab4f02cfbea4954c2b504f10fb377ade77a2120ad"
PKG_LICENSE="MAME"
PKG_SITE="https://github.com/amadvance/advancemame"
PKG_URL="https://github.com/amadvance/advancemame/archive/${PKG_VERSION}.tar.gz"
PKG_SOURCE_DIR="advancemame-${PKG_VERSION}*"
PKG_DEPENDS_TARGET="toolchain freetype slang alsa SDL2"
PKG_LONGDESC="A MAME and MESS port with an advanced video support for Arcade Monitors, TVs, and PC Monitors "
PKG_TOOLCHAIN="make"

pre_configure_target() {
  export CFLAGS="${CFLAGS} -fcommon"
  sed -i "s|#include <slang.h>|#include <${SYSROOT_PREFIX}/usr/include/slang.h>|" ${PKG_BUILD}/configure.ac
}

pre_make_target() {
  VERSION="${PKG_VERSION:0:7}"
  echo ${VERSION} > ${PKG_BUILD}/.version
}

make_target() {
  cd ${PKG_BUILD}
  ./autogen.sh
  ./configure --prefix=/usr --datadir=/usr/share/ --datarootdir=/usr/share/ --host=armv8a-libreelec-linux --enable-sdl2 --enable-freetype --with-freetype-prefix=${SYSROOT_PREFIX}/usr/ --enable-slang --enable-pthread --enable-alsa
  make mame
}

makeinstall_target() {
 : not
}

post_make_target() {
  mkdir -p ${INSTALL}/usr/share/advance
  if [ "${DEVICE}" = "RG351MP" ] || [ "${DEVICE}" = "RG552" ]; then
    cp -r ${PKG_DIR}/config/RG351MP/advmame.rc ${INSTALL}/usr/share/advance/advmame.rc
  else
    cp -r ${PKG_DIR}/config/RG351P/advmame.rc ${INSTALL}/usr/share/advance/advmame.rc
  fi
  mkdir -p ${INSTALL}/usr/bin
  cp -r ${PKG_DIR}/bin/* ${INSTALL}/usr/bin
  chmod +x ${INSTALL}/usr/bin/advmame.sh
  cp -r ${PKG_BUILD}/obj/mame/linux/blend/advmame ${INSTALL}/usr/bin
  cp -r ${PKG_BUILD}/support/category.ini ${INSTALL}/usr/share/advance
  cp -r ${PKG_BUILD}/support/sysinfo.dat ${INSTALL}/usr/share/advance
  cp -r ${PKG_BUILD}/support/history.dat ${INSTALL}/usr/share/advance
  cp -r ${PKG_BUILD}/support/hiscore.dat ${INSTALL}/usr/share/advance
  cp -r ${PKG_BUILD}/support/event.dat ${INSTALL}/usr/share/advance
}

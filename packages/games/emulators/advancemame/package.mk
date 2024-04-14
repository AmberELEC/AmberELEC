# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="advancemame"
PKG_VERSION="ec652766e6c48483b30acff78876f696b8cf76a3"
PKG_SHA256="5d0e416cbf80d24e0462832adb55ab82f946aa7ea80dbc79f3976ae5a32a4add"
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

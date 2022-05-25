# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="freej2me"
PKG_VERSION="5d24705cc48413b00dd9f579166c917f65b1c44d"
PKG_SHA256="e86aacd5b0908ad7210e53e4eb09fc0e2d0c07db784996b12bf1a92fe0564a6e"
PKG_REV="1"
PKG_ARCH="any"
PKG_SITE="https://github.com/hex007/freej2me"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain apache-ant:host"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="A free J2ME emulator with libretro, awt and sdl2 frontends."
PKG_LONGDESC="A free J2ME emulator with libretro, awt and sdl2 frontends."
PKG_TOOLCHAIN="make"

pre_configure_target() {
  ${TOOLCHAIN}/bin/ant
}

make_target() {
  make -C ${PKG_BUILD}/src/libretro
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp ${PKG_BUILD}/src/libretro/freej2me_libretro.so $INSTALL/usr/lib/libretro/

  mkdir -p $INSTALL/usr/config/distribution/freej2me
  cp ${PKG_BUILD}/build/freej2me-lr.jar $INSTALL/usr/config/distribution/freej2me

  mkdir -p $INSTALL/usr/bin
  cp ${PKG_DIR}/freej2me.sh $INSTALL/usr/bin
}

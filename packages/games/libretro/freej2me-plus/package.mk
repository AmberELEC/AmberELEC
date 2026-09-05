# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2025-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="freej2me-plus"
PKG_VERSION="44883792f350889d297fe4fef82737f041ca1704"
PKG_SHA256="fe452c0feac2c3debdeaf0d246234d37ee9dac42d754d40fe6f766b041a3b1a6"
PKG_SITE="https://github.com/TASEmulators/freej2me-plus"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain apache-ant:host"
PKG_LONGDESC="A free J2ME emulator with libretro, awt and sdl2 frontends."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-mold"

pre_configure_target() {
  sed -i 's/freej2me-lr.jar/freej2me-plus-lr.jar/g' ${PKG_BUILD}/build.xml
  sed -i 's/freej2me-lr\.jar/freej2me-plus-lr.jar/g' \
    ${PKG_BUILD}/src/libretro/freej2me_libretro.c \
    ${PKG_BUILD}/src/libretro/freej2me_libretro.h \
    ${PKG_BUILD}/src/libretro/freej2me_libretro.info

  ${TOOLCHAIN}/bin/ant
}

make_target() {
  make -C ${PKG_BUILD}/src/libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/src/libretro/freej2me-plus_libretro.so ${INSTALL}/usr/lib/libretro/
  cp ${PKG_BUILD}/src/libretro/freej2me_libretro.info ${INSTALL}/usr/lib/libretro/freej2me-plus_libretro.info

  mkdir -p ${INSTALL}/usr/config/distribution/freej2me
  cp ${PKG_BUILD}/build/freej2me-plus-lr.jar ${INSTALL}/usr/config/distribution/freej2me

  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_DIR}/freej2me-plus.sh ${INSTALL}/usr/bin
}

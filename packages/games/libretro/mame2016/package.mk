# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mame2016"
PKG_VERSION="01058613a0109424c4e7211e49ed83ac950d3993"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mame2016-libretro"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain linux glibc alsa-lib"
PKG_LONGDESC="Late 2016 version of MAME (0.174) for libretro. Compatible with MAME 0.174 romsets."
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="REGENIE=1 \
                      VERBOSE=1 \
                      NOWERROR=1 \
                      OPENMP=1 \
                      CROSS_BUILD=1 \
                      TOOLS=0 \
                      RETRO=1 \
                      PTR64=0 \
                      NOASM=1 \
                      OPTIMIZE=fast \
                      PYTHON_EXECUTABLE=python3 \
                      CONFIG=libretro \
                      LIBRETRO_OS=unix \
                      LIBRETRO_CPU=arm64 \
                      PLATFORM=arm64 \
                      ARCH= \
                      TARGET=mame \
                      SUBTARGET=arcade \
                      OSD=retro \
                      USE_SYSTEM_LIB_EXPAT=1 \
                      USE_SYSTEM_LIB_ZLIB=1 \
                      USE_SYSTEM_LIB_FLAC=1 \
                      USE_SYSTEM_LIB_SQLITE3=1"

pre_configure_target() {
  sed -i "s/BARE_BUILD_VERSION \"0.174\"/BARE_BUILD_VERSION \"0.174 ${PKG_VERSION:0:7}\"/g" src/version.cpp 
}

make_target() {
  unset ARCH
  unset DISTRO
  unset PROJECT
  export ARCHOPTS="-D__aarch64__ -DASMJIT_BUILD_X86"
  make ${PKG_MAKE_OPTS_TARGET} OVERRIDE_CC=${CC} OVERRIDE_CXX=${CXX} OVERRIDE_LD=${LD} AR=${AR} ${MAKEFLAGS}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mamearcade2016_libretro.so ${INSTALL}/usr/lib/libretro/mame2016_libretro.so
  mkdir -p ${INSTALL}/usr/config/retroarch/savefiles/mame2016/hi
  cp -f plugins/hiscore/hiscore.dat ${INSTALL}/usr/config/retroarch/savefiles/mame2016/hi
}

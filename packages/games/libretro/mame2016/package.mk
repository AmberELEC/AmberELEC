# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mame2016"
PKG_VERSION="3529f4e2cb8e74c88d83bc9fc9d695f78dc9a975"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mame2016-libretro"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain linux glibc alsa-lib expat zlib flac sqlite"
PKG_LONGDESC="Late 2016 version of MAME (0.174) for libretro. Compatible with MAME 0.174 romsets."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+pic"

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

  (
    unset ARCH
    unset TARGET_ARCH
    unset CFLAGS
    unset CXXFLAGS
    unset CPPFLAGS
    unset LDFLAGS
    make -C 3rdparty/genie/build/gmake.linux -f genie.make \
         CC="${HOST_CC:-gcc}" \
         CXX="${HOST_CXX:-g++}" \
         ARCH="" \
         CFLAGS="" \
         LDFLAGS=""
  )

  sed -i "s/-static-libstdc++//g" scripts/genie.lua 2>/dev/null || true

  if [ -f scripts/src/osd/retro.lua ]; then
    sed -i 's|linkoptions {|linkoptions { "-shared", "-fuse-ld=mold",|g' scripts/src/osd/retro.lua
  else
    find scripts/ -type f -name "*.lua" -exec sed -i 's|linkoptions {|linkoptions { "-shared", "-fuse-ld=mold",|g' {} +
  fi

  find scripts -type f -name "*.lua" -exec sed -i 's|MAME_DIR \.\. "src/osd/retro/retroprefix.h"|"../../../../../src/osd/retro/retroprefix.h"|g' {} +
  find scripts -type f -name "*.lua" -exec sed -i 's|_OPTIONS\["targetos"\] \.\. "/retroprefix.h"|"../../../../../src/osd/retro/retroprefix.h"|g' {} +
}

make_target() {
  unset ARCH
  unset DISTRO
  unset PROJECT
  export ARCHOPTS="-D__aarch64__ -DASMJIT_BUILD_X86"

  local my_cc="${CC}"
  local my_cxx="${CXX}"

  if [ -n "${CCACHE_DIR}" ] && [ -x "${TOOLCHAIN}/bin/ccache" ]; then
    my_cc="${TOOLCHAIN}/bin/ccache ${CC}"
    my_cxx="${TOOLCHAIN}/bin/ccache ${CXX}"
  fi

  make ${PKG_MAKE_OPTS_TARGET} \
       OVERRIDE_CC="${my_cc}" \
       OVERRIDE_CXX="${my_cxx}" \
       AR="${AR}" \
       LDFLAGS="${LDFLAGS} -fuse-ld=mold" \
       ${MAKEFLAGS}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp mamearcade2016_libretro.so ${INSTALL}/usr/lib/libretro/mame2016_libretro.so
  mkdir -p ${INSTALL}/usr/config/retroarch/savefiles/mame2016/hi
  cp -f plugins/hiscore/hiscore.dat ${INSTALL}/usr/config/retroarch/savefiles/mame2016/hi
}

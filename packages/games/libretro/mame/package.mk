# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019 Trond Haugland (trondah@gmail.com)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="mame"
PKG_VERSION="eb342748c828421bd15a1791162c885bfde61907"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/mame"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain zlib flac sqlite expat"
PKG_LONGDESC="MAME - Multiple Arcade Machine Emulator"
PKG_TOOLCHAIN="make"

PKG_MAKE_OPTS_TARGET="REGENIE=1 \
                      VERBOSE=1 \
                      NOWERROR=1 \
                      OPENMP=1 \
                      CROSS_BUILD=1 \
                      TOOLS=0 \
                      RETRO=1 \
                      PTR64=0 \
                      NOASM=0 \
                      NO_USE_BGFX=1 \
                      OPTIMIZE=fast \
                      PYTHON_EXECUTABLE=python3 \
                      CONFIG=libretro \
                      LIBRETRO_OS=unix \
                      LIBRETRO_CPU=arm64 \
                      PLATFORM=arm64 \
                      ARCH= \
                      TARGET=mame \
                      SUBTARGET=mame \
                      OSD=retro \
                      USE_SYSTEM_LIB_EXPAT=1 \
                      USE_SYSTEM_LIB_ZLIB=1 \
                      USE_SYSTEM_LIB_FLAC=1 \
                      USE_SYSTEM_LIB_SQLITE3=1"

pre_configure_target() {
  export CFLAGS="${CFLAGS} -Wno-deprecated-declarations"
  sed -i "s/-static-libstdc++//g" scripts/genie.lua
  find scripts/ -type f -name "*.lua" -exec sed -i 's|MAME_DIR\s*\.\.\s*"src/osd/libretro/retroprefix.h"|path.getrelative(path.getabsolute("build/projects/retro/mame/gmake-linux"), path.getabsolute("src/osd/libretro/retroprefix.h"))|g' {} +
#  sed -i 's/BARE_VCS_REVISION "$(NEW_GIT_VERSION)"/BARE_VCS_REVISION ""/g' makefile
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
       OVERRIDE_LD="${LD}" \
       AR="${AR}" \
       LDFLAGS="${LDFLAGS} -fuse-ld=mold" \
       ${MAKEFLAGS}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp *.so ${INSTALL}/usr/lib/libretro/mame_libretro.so
  mkdir -p ${INSTALL}/usr/config/retroarch/savefiles/mame/hi
  cp -f plugins/hiscore/hiscore.dat ${INSTALL}/usr/config/retroarch/savefiles/mame/hi
  mkdir -p ${INSTALL}/usr/config/mame
  cp ${PKG_DIR}/config/*.cfg ${INSTALL}/usr/config/mame
}

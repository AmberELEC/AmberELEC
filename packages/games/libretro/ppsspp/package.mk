# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="ppsspp"
PKG_VERSION="fa50bb1976065c4f8b1b47af227d367fe9771555"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/hrydgard/ppsspp"
PKG_URL="https://github.com/hrydgard/ppsspp.git"
PKG_DEPENDS_TARGET="toolchain SDL2 ffmpeg libzip zstd"
PKG_LONGDESC="A PSP emulator for Android, Windows, Mac, Linux and Blackberry 10, written in C++."
PKG_TOOLCHAIN="cmake-make"

pre_configure_target() {
  sed -i 's/\-O[23]//' ${PKG_BUILD}/CMakeLists.txt
  sed -i 's/\-O[23]//' ${PKG_BUILD}/libretro/Makefile

  if ! grep -q "__aarch64_cas8_acq_rel" ${PKG_BUILD}/libretro/libretro.cpp; then
cat << 'EOF' >> ${PKG_BUILD}/libretro/libretro.cpp

extern "C" {
__attribute__((visibility("default")))
unsigned long long __aarch64_cas8_acq_rel(unsigned long long oldval, unsigned long long newval, unsigned long long *ptr) {
	unsigned long long oldval_out;
	unsigned int tmp;
	__asm__ __volatile__(
		"0: ldaxr %0, [%2]\n"
		"   cmp %0, %3\n"
		"   b.ne 1f\n"
		"   stlxr %w1, %4, [%2]\n"
		"   cbnz %w1, 0b\n"
		"1:"
		: "=&r" (oldval_out), "=&r" (tmp)
		: "r" (ptr), "r" (oldval), "r" (newval)
		: "memory", "cc"
	);
	return oldval_out;
}
}
EOF
  fi

  PKG_CMAKE_OPTS_TARGET="-DLIBRETRO=ON \
                         -DCMAKE_BUILD_TYPE=Release \
                         -DCMAKE_RULE_MESSAGES=OFF \
                         -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
                         -DCMAKE_C_FLAGS_RELEASE=-DNDEBUG \
                         -DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG \
                         -DUSE_SYSTEM_FFMPEG=OFF \
                         -DUSE_SYSTEM_ZSTD=ON \
                         -DUSE_SYSTEM_LIBZIP=ON \
                         -DUSING_X11_VULKAN=OFF \
                         -DUSE_DISCORD=OFF"

  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_CMAKE_OPTS_TARGET+=" -DUSING_FBDEV=ON \
                             -DUSING_EGL=ON \
                             -DUSING_GLES2=ON"
  fi
}

pre_make_target() {
  find ${PKG_BUILD} -name flags.make -exec sed -i "s:isystem :I:g" {} \;
  find ${PKG_BUILD} -name build.ninja -exec sed -i "s:isystem :I:g" {} \;
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp lib/ppsspp_libretro.so ${INSTALL}/usr/lib/libretro/
}

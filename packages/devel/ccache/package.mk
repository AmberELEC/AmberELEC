# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="ccache"
PKG_VERSION="4.8.2"
PKG_SHA256="3d3fb3f888a5b16c4fa7ee5214cca76348afd6130e8443de5f6f2424f2076a49"
PKG_LICENSE="GPL"
PKG_SITE="https://ccache.dev/download.html"
PKG_URL="https://github.com/ccache/ccache/releases/download/v${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_LONGDESC="A compiler cache to speed up re-compilation of C/C++ code by caching."
PKG_TOOLCHAIN="cmake"

pre_configure_host() {
  export CC=${LOCAL_CC}
  export CXX=${LOCAL_CXX}
  mkdir -p ${TOOLCHAIN}/bin
  rm -f ${TOOLCHAIN}/bin/host-gcc
  rm -f ${TOOLCHAIN}/bin/host-g++
  ln -s ${LOCAL_CC} ${TOOLCHAIN}/bin/host-gcc
  ln -s ${LOCAL_CXX} ${TOOLCHAIN}/bin/host-g++
  PKG_CMAKE_OPTS_HOST="-DREDIS_STORAGE_BACKEND=OFF -DENABLE_DOCUMENTATION=OFF -DENABLE_TESTING=OFF -DZSTD_FROM_INTERNET=ON"
}

pre_configure_init() {
  PKG_CMAKE_OPTS_INIT="-DREDIS_STORAGE_BACKEND=OFF -DENABLE_DOCUMENTATION=OFF -DENABLE_TESTING=OFF -DZSTD_FROM_INTERNET=ON"
}

post_makeinstall_host() {
  rm -f ${TOOLCHAIN}/bin/host-gcc
  rm -f ${TOOLCHAIN}/bin/host-g++

# setup ccache
  if [ -z "${CCACHE_DISABLE}" ]; then
    ${TOOLCHAIN}/bin/ccache --max-size=${CCACHE_CACHE_SIZE}
  fi

  cat > ${TOOLCHAIN}/bin/host-gcc <<EOF
#!/bin/sh
${TOOLCHAIN}/bin/ccache ${CC} "\$@"
EOF

  chmod +x ${TOOLCHAIN}/bin/host-gcc

  cat > ${TOOLCHAIN}/bin/host-g++ <<EOF
#!/bin/sh
${TOOLCHAIN}/bin/ccache ${CXX} "\$@"
EOF

  chmod +x ${TOOLCHAIN}/bin/host-g++
}

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="boost"
PKG_VERSION="1.76.0"
PKG_SHA256="f0397ba6e982c4450f27bf32a2a83292aba035b827a5623a14636ea583318c41"
PKG_LICENSE="OSS"
PKG_SITE="http://www.boost.org/"
PKG_URL="https://boostorg.jfrog.io/artifactory/main/release/${PKG_VERSION}/source/${PKG_NAME}_${PKG_VERSION//./_}.tar.bz2"
PKG_DEPENDS_HOST="toolchain:host"
PKG_DEPENDS_TARGET="toolchain boost:host Python3 zlib bzip2"
PKG_LONGDESC="boost: Peer-reviewed STL style libraries for C++"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+pic"

make_host() {
  cd tools/build/src/engine
    sh build.sh
}

makeinstall_host() {
  mkdir -p ${TOOLCHAIN}/bin
    cp bjam ${TOOLCHAIN}/bin
}

pre_configure_target() {
  export CFLAGS="${CFLAGS} -I${TOOLCHAIN}/include/${PKG_PYTHON_VERSION}"
  export CXXFLAGS="${CXXFLAGS} -I${TOOLCHAIN}/include/${PKG_PYTHON_VERSION}"
}

configure_target() {
  sh bootstrap.sh --prefix=/usr \
                  --with-bjam=${TOOLCHAIN}/bin/bjam \
                  --with-python=${TOOLCHAIN}/bin/python \
                  --with-python-root=${SYSROOT_PREFIX}/usr

  echo "using gcc : $(${CC} -v 2>&1  | tail -n 1 |awk '{print $3}') : ${CC}  : <compileflags>\"${CFLAGS}\" <linkflags>\"${LDFLAGS}\" ;" \
    > tools/build/src/user-config.jam
  echo "using python : ${PKG_PYTHON_VERSION/#python} : ${TOOLCHAIN} : ${SYSROOT_PREFIX}/usr/include : ${SYSROOT_PREFIX}/usr/lib ;" \
    >> tools/build/src/user-config.jam
}

makeinstall_target() {
  ${TOOLCHAIN}/bin/bjam -d2 --ignore-site-config \
                          --layout=system \
                          --prefix=${SYSROOT_PREFIX}/usr \
                          --toolset=gcc link=static \
                          --with-chrono \
                          --with-date_time \
                          --with-filesystem \
                          --with-iostreams \
                          --with-python \
                          --with-random \
                          --with-regex -sICU_PATH="${SYSROOT_PREFIX}/usr" \
                          --with-serialization \
                          --with-system \
                          --with-thread \
                          install
}

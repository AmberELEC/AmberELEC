# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="boost"
PKG_VERSION="1.82.0"
PKG_SHA256="a6e1ab9b0860e6a2881dd7b21fe9f737a095e5f33a3a874afc6a345228597ee6"
PKG_LICENSE="OSS"
PKG_SITE="https://www.boost.org/"
PKG_URL="https://archives.boost.io/release/${PKG_VERSION}/source/${PKG_NAME}_${PKG_VERSION//./_}.tar.bz2"
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
    cp b2 ${TOOLCHAIN}/bin
}

pre_configure_target() {
  export CFLAGS="${CFLAGS} -I${TOOLCHAIN}/include/${PKG_PYTHON_VERSION}"
  export CXXFLAGS="${CXXFLAGS} -I${TOOLCHAIN}/include/${PKG_PYTHON_VERSION}"
}

configure_target() {
  sh bootstrap.sh --prefix=/usr \
                  --with-bjam=${TOOLCHAIN}/bin/b2 \
                  --with-python=${TOOLCHAIN}/bin/python \
                  --with-python-root=${SYSROOT_PREFIX}/usr

  echo "using gcc : $(${CC} -v 2>&1  | tail -n 1 |awk '{print $3}') : ${CC}  : <compileflags>\"${CFLAGS}\" <linkflags>\"${LDFLAGS}\" ;" \
    > tools/build/src/user-config.jam
  echo "using python : ${PKG_PYTHON_VERSION/#python} : ${TOOLCHAIN} : ${SYSROOT_PREFIX}/usr/include : ${SYSROOT_PREFIX}/usr/lib ;" \
    >> tools/build/src/user-config.jam
}

makeinstall_target() {
  ${TOOLCHAIN}/bin/b2 -d2 --ignore-site-config \
                      --layout=system \
                      --prefix=${SYSROOT_PREFIX}/usr \
                      --toolset=gcc link=static \
                      --with-chrono \
                      --with-date_time \
                      --with-filesystem \
                      --with-iostreams \
                      --with-program_options \
                      --with-python \
                      --with-locale \
                      --with-random \
                      --with-regex -sICU_PATH="${SYSROOT_PREFIX}/usr" \
                      --with-serialization \
                      --with-system \
                      --with-thread \
                      --with-nowide \
                      --with-context \
                      install
}

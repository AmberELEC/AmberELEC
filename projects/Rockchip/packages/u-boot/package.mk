# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="u-boot"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://www.denx.de/wiki/U-Boot"
PKG_DEPENDS_TARGET="toolchain swig:host rkbin pyelftools:host"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems."
PKG_IS_KERNEL_PKG="yes"
PKG_STAMP="${UBOOT_SYSTEM}"

PKG_NEED_UNPACK="${PROJECT_DIR}/${PROJECT}/bootloader"
[ -n "${DEVICE}" ] && PKG_NEED_UNPACK+=" ${PROJECT_DIR}/${PROJECT}/devices/${DEVICE}/bootloader"

if [[ "${DEVICE}" =~ RG351 ]]; then
  PKG_VERSION="d8ad98256d4913bf39153a404f5e26e94cfe8b14"
  PKG_GIT_CLONE_SINGLE="yes"
  PKG_GIT_CLONE_DEPTH="1"
  PKG_URL="https://github.com/AmberELEC/uboot_rg351.git"
elif [[ "${DEVICE}" =~ RG552 ]]; then
  PKG_VERSION="866ca972d6c3cabeaf6dbac431e8e08bb30b3c8e"
  PKG_GIT_CLONE_BRANCH=v2024.01
  PKG_GIT_CLONE_SINGLE="yes"
  PKG_GIT_CLONE_DEPTH="1"
  PKG_URL="https://github.com/u-boot/u-boot.git"
  PKG_DEPENDS_TARGET+=" atf"
  ATF_PLATFORM="rk3399"
fi

post_patch() {
  if [ -n "${UBOOT_SYSTEM}" ] && find_file_path bootloader/config; then
    PKG_CONFIG_FILE="${PKG_BUILD}/configs/$(${ROOT}/${SCRIPTS}/uboot_helper ${PROJECT} ${DEVICE} ${UBOOT_SYSTEM} config)"
    if [ -f "${PKG_CONFIG_FILE}" ]; then
      cat ${FOUND_PATH} >> "${PKG_CONFIG_FILE}"
    fi
  fi
}

make_target() {
  sed -i -e '/	kwbimage.o..*$/d' tools/Makefile
  if [ -z "${UBOOT_SYSTEM}" ]; then
    echo "UBOOT_SYSTEM must be set to build an image"
    echo "see './scripts/uboot_helper' for more information"
  else
    [ "${BUILD_WITH_DEBUG}" = "yes" ] && PKG_DEBUG=1 || PKG_DEBUG=0
    if [[ "${ATF_PLATFORM}" == "rk3399" ]]; then
      if [ -f "$(get_build_dir atf)/.install_pkg/usr/share/bootloader/bl31.elf" ]; then
        export BL31="$(get_build_dir atf)/.install_pkg/usr/share/bootloader/bl31.elf"
      fi
    fi
    DEBUG=${PKG_DEBUG} CROSS_COMPILE="${TARGET_KERNEL_PREFIX}" LDFLAGS="" ARCH=arm make mrproper
    DEBUG=${PKG_DEBUG} CROSS_COMPILE="${TARGET_KERNEL_PREFIX}" LDFLAGS="" ARCH=arm make $(${ROOT}/${SCRIPTS}/uboot_helper ${PROJECT} ${DEVICE} ${UBOOT_SYSTEM} config)
    DEBUG=${PKG_DEBUG} CROSS_COMPILE="${TARGET_KERNEL_PREFIX}" LDFLAGS="" ARCH=arm _python_sysroot="${TOOLCHAIN}" _python_prefix=/ _python_exec_prefix=/ make HOSTCC="${HOST_CC}" HOSTLDFLAGS="-L${TOOLCHAIN}/lib" HOSTSTRIP="true" CONFIG_MKIMAGE_DTC_PATH="scripts/dtc/dtc"
  fi
}

makeinstall_target() {
    mkdir -p ${INSTALL}/usr/share/bootloader
    # Only install u-boot.img et al when building a board specific image
    if [ -n "${UBOOT_SYSTEM}" ]; then
      find_file_path bootloader/install && . ${FOUND_PATH}
    fi

    # Always install the update script
    find_file_path bootloader/update.sh && cp -av ${FOUND_PATH} ${INSTALL}/usr/share/bootloader

    # Always install the canupdate script
    if find_file_path bootloader/canupdate.sh; then
      cp -av ${FOUND_PATH} ${INSTALL}/usr/share/bootloader
      sed -e "s/@PROJECT@/${DEVICE:-${PROJECT}}/g" \
          -i ${INSTALL}/usr/share/bootloader/canupdate.sh
    fi
    if [ "${DEVICE}" == "RG351P" ]; then
      cp -f ${PKG_BUILD}/arch/arm/dts/rg351p-uboot.dtb ${INSTALL}/usr/share/bootloader
    elif [ "${DEVICE}" == "RG351V" ]; then
      cp -f ${PKG_BUILD}/arch/arm/dts/rg351v-uboot.dtb ${INSTALL}/usr/share/bootloader
    elif [ "${DEVICE}" == "RG351MP" ]; then
      cp -f ${PKG_BUILD}/arch/arm/dts/rg351mp-uboot.dtb ${INSTALL}/usr/share/bootloader
    fi
}
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="RTL8852BU"
PKG_VERSION="38fc5a3" # short hash else build fails: "Argument list too long"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/morrownr/rtl8852bu-20250826"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="${LINUX_DEPENDS}"
PKG_LONGDESC="Realtek RTL8852BU/RTL8832BU Linux 4.4-5.x driver"
PKG_IS_KERNEL_PKG="yes"

# On an AArch64 build host, Kbuild expands every object pathname for this
# large driver on one link command. Use a short module path to stay below the
# host ARG_MAX limit while preserving the original x86_64 build command.
RTL8852BU_SHORT_BUILD="/tmp/amberelec-${DEVICE}-rtl8852bu"

pre_make_target() {
  unset LDFLAGS

  if [ "${HOST_NAME%%-*}" = "aarch64" ]; then
    rm -f "${RTL8852BU_SHORT_BUILD}"
    ln -s "${PKG_BUILD}" "${RTL8852BU_SHORT_BUILD}"
  fi
}

make_target() {
  local module_path_args=()

  if [ "${HOST_NAME%%-*}" = "aarch64" ]; then
    module_path_args=(
      M="${RTL8852BU_SHORT_BUILD}"
      OUT_DIR="${RTL8852BU_SHORT_BUILD}"
      TopDIR="${RTL8852BU_SHORT_BUILD}"
    )
  fi

  make V=1 \
       ARCH=${TARGET_KERNEL_ARCH} \
       KSRC=$(kernel_path) \
       "${module_path_args[@]}" \
       CROSS_COMPILE=${TARGET_KERNEL_PREFIX} \
       CONFIG_POWER_SAVING=n
}

post_make_target() {
  if [ "${HOST_NAME%%-*}" = "aarch64" ]; then
    rm -f "${RTL8852BU_SHORT_BUILD}"
  fi
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_module_dir)/${PKG_NAME}
  cp *.ko ${INSTALL}/$(get_full_module_dir)/${PKG_NAME}
}

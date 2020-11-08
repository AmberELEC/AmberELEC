#!/bin/bash

###
### Simple script to build 351ELEC using the Anbernic kernel or the lualiliu kernel.
###

export DISTRO=351ELEC
export PROJECT=Rockchip
export DEVICE=RG351P
export ARCH=arm

if [ ! "$1" ]; then
  BUILD="${DEVICE}-LI"
else
  BUILD=$(echo ${BUILD} | sed 's#^.*-##')
  BUILD="${DEVICE}-${1^^}"
fi

echo "Staging ${BUILD}"

if [ "${BUILD}" == "RG351P-LI" ]
then
  echo "Checking out the latest Linux kernel packages for building."
  git checkout packages/linux
  git checkout packages/linux-driver-addons
  git checkout packages/linux-drivers
  git checkout packages/linux-firmware
  git checkout packages/virtual/linux-drivers
  git checkout packages/virtual/linux-firmware
else
  echo "Removing Linux kernel packages for Anbernic injection"
  rm -rf packages/linux
  rm -rf packages/linux-driver-addons
  rm -rf packages/linux-drivers
  rm -rf packages/linux-firmware
  rm -rf packages/virtual/linux-drivers
  rm -rf packages/virtual/linux-firmware
fi

echo "Setting build device directory to ${BUILD}"
rm -rf projects/Rockchip/devices/RG351P
cp -rf projects/Rockchip/devices/${BUILD} projects/Rockchip/devices/RG351P

echo "Building.."
make release

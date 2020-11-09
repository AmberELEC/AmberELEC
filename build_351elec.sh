#!/bin/bash

###
### Simple script to build 351ELEC using the Anbernic kernel or the lualiliu kernel.
###

export DISTRO=351ELEC
export PROJECT=Rockchip
export DEVICE=RG351P
export ARCH=arm


if [ ! "${1^^}" == "WORLD" ]
then
  BUILD=$(echo ${BUILD} | sed 's#^.*-##')
  BUILD="${DEVICE}-${1^^}"
else
  BUILD=$(echo ${1^^})
fi

function additional_packages () {
  git checkout projects/Rockchip/options
  if [ "$1" == "emulators" ]
  then
    sed -i 's/#ADDITIONAL_PACKAGES#/dtc emuelec dosbox-sdl2 fba4arm mupen64plus-nx PPSSPPSDL amiberry advancemame hatarisa hatari/g' projects/Rockchip/options
  else
    sed -i 's/#ADDITIONAL_PACKAGES#/dtc emuelec/g' projects/Rockchip/options
  fi
}

function RG351P-LI () {
  echo "Checking out the latest Linux kernel packages for building."
  git checkout packages/linux
  git checkout packages/linux-driver-addons
  git checkout packages/linux-drivers
  git checkout packages/linux-firmware
  git checkout packages/virtual/linux-drivers
  git checkout packages/virtual/linux-firmware
  echo "Setting build device directory to ${BUILD}"
  rm -rf projects/Rockchip/devices/RG351P
  cp -rf projects/Rockchip/devices/RG351P-LI projects/Rockchip/devices/RG351P
  make image
}

function RG351P-AK () {
  echo "Removing Linux kernel packages for Anbernic injection"
  rm -rf packages/linux
  rm -rf packages/linux-driver-addons
  rm -rf packages/linux-drivers
  rm -rf packages/linux-firmware
  rm -rf packages/virtual/linux-drivers
  rm -rf packages/virtual/linux-firmware
  rm -rf projects/Rockchip/devices/RG351P
  cp -rf projects/Rockchip/devices/RG351P-AK projects/Rockchip/devices/RG351P
}

if [ "${BUILD}" == "RG351P-LI" ]
then
  additional_packages
  RG351P-LI
elif [ "${BUILD}" == "RG351P-AK" ]
then
  additional_packages
  RG351P-AK
elif [ "${BUILD}" == "WORLD" ]
then
  additional_packages
  RG351P-LI
  additional_packages emulators
  RG351P-LI
  RG351P-AK
else
  echo "Pass the project to build (LI,AL,WORLD) as an argument on the command line. [${BUILD}]"
  exit 1
fi


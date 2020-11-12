#!/bin/bash

###
### Simple script to build 351ELEC using the Anbernic kernel or the lualiliu kernel.
###

export DISTRO=351ELEC
export PROJECT=Rockchip
export DEVICE=RG351P
#export ARCH=arm

if [ ! "${1^^}" == "WORLD" ] && [ ! "${1^^}" == "RESET" ]
then
  BUILD=$(echo ${BUILD} | sed 's#^.*-##')
  BUILD="${DEVICE}-${1^^}"
else
  BUILD=$(echo ${1^^})
fi

function additional_packages () {
  if [ "$1" == "emulators" ]
  then
    sed -i 's/@ADDITIONAL_PACKAGES@/dtc emuelec dosbox-sdl2 fba4arm mupen64plus-nx PPSSPPSDL amiberry advancemame hatarisa hatari/g' projects/Rockchip/options
  else
    sed -i 's/@ADDITIONAL_PACKAGES@/dtc emuelec/g' projects/Rockchip/options
  fi
}

function RG351P-LI () {
  echo "Checking out the latest Linux kernel packages for building."
  echo "Setting build device directory to ${BUILD}"
  rm -rf projects/Rockchip/devices/RG351P
  cp -rf projects/Rockchip/devices/RG351P-LI projects/Rockchip/devices/RG351P
  make $1 || exit 1
  if [ -d "release/RG351P-LI" ]
  then
    rm -rf "release/RG351P-LI"
  fi
  mv target release/RG351P-LI
  mkdir target
  RESET
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
  make $1 || exit 1
  if [ -d "release/RG351P-AK" ]
  then
    rm -rf "release/RG351P-AK"
  fi
  mv target release/RG351P-AK
  mkdir target
  RESET
}

function RESET () {
  git checkout projects/Rockchip/options
  git checkout packages/linux
  git checkout packages/linux-driver-addons
  git checkout packages/linux-drivers
  git checkout packages/linux-firmware
  git checkout packages/virtual/linux-drivers
  git checkout packages/virtual/linux-firmware
}

for dir in release target
do
  if [ ! -d "${dir}" ]
  then
    mkdir ${dir}
  fi
done

RESET
additional_packages

if [ "${BUILD}" == "RG351P-LI" ]
then
  RG351P-LI image
elif [ "${BUILD}" == "RG351P-AK" ]
then
  RG351P-AK image
elif [ "${BUILD}" == "WORLD" ]
then
  # Temporary build world loop, replace with a virtual package.
  additional_packages
  RG351P-LI image
  additional_packages emulators
  RG351P-LI image
  additional_packages emulators
  RG351P-AK image
elif [ "${BUILD}" == "RESET" ]
then
  RESET
else
  echo "Pass the project to build (LI,AL,WORLD) as an argument on the command line. [${BUILD}]"
  exit 1
fi


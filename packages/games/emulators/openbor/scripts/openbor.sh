#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

# OpenBOR only works with Pak files, if you have an extracted game you will need to create a pak first.

pakname=$(basename "$1")
pakname="${pakname%.*}"

CONFIGDIR="/storage/openbor"
PAKS="${CONFIGDIR}/Paks"
SAVES="${CONFIGDIR}/Saves"

# Make sure the folders exists
  mkdir -p "${CONFIGDIR}"
  mkdir -p "${PAKS}"
  mkdir -p "${SAVES}"

# Clear PAKS folder to avoid getting the launcher on next run
  rm -rf ${PAKS}/*

# make a symlink to the pak
  ln -sf "$1" "${PAKS}"

# Run OpenBOR in the config folder
  cd "${CONFIGDIR}"
  SDL_AUDIODRIVER=alsa OpenBOR

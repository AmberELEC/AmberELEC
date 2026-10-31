#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

# The rk817 codec on this kernel names its playback volume 'DAC', not
# 'Playback'. Percentages are linear in raw steps, the same mapping ES's
# volume slider uses on this control, so both agree on audio.volume.
MIXER='DAC'

if [ "${1}" == "vol" ]; then
  VOLSTEP="${3:-1}"
  CURRENTVOL=$(amixer sget "${MIXER}" | grep -o -m1 '[0-9]*%' | tr -d '%')
  if [ "${2}" == "+" ]; then
    STEPVOL=$((CURRENTVOL + VOLSTEP))
  elif [ "${2}" == "-" ]; then
    STEPVOL=$((CURRENTVOL - VOLSTEP))
  else
    STEPVOL=${2}
  fi
  [ "${STEPVOL}" -gt 100 ] && STEPVOL=100
  [ "${STEPVOL}" -lt 0 ] && STEPVOL=0
  amixer -q set "${MIXER}" ${STEPVOL}%
  set_ee_setting "audio.volume" ${STEPVOL}
fi

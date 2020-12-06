#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Fewtarius

source /emuelec/scripts/env.sh
source /etc/profile

# Is userland 32bit or 64bit?
TEST=$(ldd /usr/bin/emulationstation | grep 64)
if [ $? == 0 ]
then
  MYARCH="aarch64"
else
  MYARCH="arm"
fi

# Check if we need retroarch 32 bits or 64 bits
RABIN="retroarch"
if [[ "${PLATFORM}" == "psx" ]] || [[ "${PLATFORM}" == "n64" ]]; then
    if [[ "${CORE}" == "pcsx_rearmed" ]] || [[ "${CORE}" == "parallel_n64" ]]; then
        if [ "${MYARCH}" == "arm" ]
        then
          set_kill_keys "retroarch"
          RABIN="retroarch"
        else
          set_kill_keys "retroarch32"
          export LD_LIBRARY_PATH="/usr/lib32"
          RABIN="retroarch32"
        fi
    fi
fi

${RABIN}

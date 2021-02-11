#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

dir="$1"
name=${dir##*/}
name=${name%.*}

if [[ -f "$dir/$name.commands" ]]; then
    params=$(<"$dir/$name.commands")
fi

cd ~/.config/distribution/configs/hypseus/

mkdir -p /tmp/bin ||:

cp -f /usr/bin/hypseus /tmp/bin

### Hypseus bugs out with SDL 2.0.12, until we can fix it...
patchelf --replace-needed libSDL2-2.0.so.0 libSDL2-2.0.so.0.10.0 /tmp/bin/hypseus

### You cannot call hypseus with a fully qualified path or it loses its mind.
PATH=/tmp/bin:$PATH

hypseus "$name" vldp -framefile "$dir/$name.txt" -fullscreen -useoverlaysb 2 $params

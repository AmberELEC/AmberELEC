#!/bin/bash

systemctl stop emustation

if [ "$(cat /usr/config/.OS_ARCH)" == "RG351P" ]; then
        echo "351P"
        cp -f /usr/config/splash/splash-480l.png /storage/.config/emulationstation/resources/logo.png
elif [ "$(cat /usr/config/.OS_ARCH)" == "RG351V" ]; then
        echo "351V"
        cp -f /usr/config/splash/splash-640.png /storage/.config/emulationstation/resources/logo.png
fi

cp -f /usr/config/splash/splash-*.png /storage/.config/splash/

systemctl start emustation
# Rockchip

This project is for Rockchip SoC devices

## Devices

Anbernic RG351P

## Links

* https://github.com/rockchip-linux
* http://opensource.rock-chips.com

## Useful debug commands

* `cat /sys/kernel/debug/dri/0/summary`
* `cat /sys/kernel/debug/dw-hdmi/status`
* `cat /sys/kernel/debug/clk/clk_summary`
* `hexdump -C /sys/class/drm/card0-HDMI-A-1/edid`
* `edid-decode /sys/class/drm/card0-HDMI-A-1/edid`
* `cat /sys/kernel/debug/dma_buf/bufinfo`

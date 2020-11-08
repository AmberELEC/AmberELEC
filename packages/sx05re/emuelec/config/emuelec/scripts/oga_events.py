#!/usr/bin/env python3

import evdev
import asyncio
import time
from subprocess import check_output

pwrkey = evdev.InputDevice("/dev/input/event0")

need_to_swallow_pwr_key = False # After a resume, we swallow the pwr input that triggered the resume
time_start=0
time_end=0
class Power:
    pwr = 116

def runcmd(cmd, *args, **kw):
    print(f">>> {cmd}")
    check_output(cmd, *args, **kw)

async def handle_event(device):
    async for event in device.async_read_loop():
        global need_to_swallow_pwr_key
        global time_start
        global time_end
        if device.name == "rk8xx_pwrkey":
            if event.value == 1 and event.code == Power.pwr: # pwr on release
                time_start=time.time()
                time_end=time.time()
                if need_to_swallow_pwr_key == False:
                    need_to_swallow_pwr_key = True
                    runcmd("/bin/systemctl suspend || true", shell=True)
                else:
                    need_to_swallow_pwr_key = False
            if event.value == 0 and event.code == Power.pwr:
                time_end=time.time()
                if (time_end-time_start) >= 3:
                    runcmd("/usr/sbin/poweroff", shell=True)


        if event.code != 0:
            print(device.name, event)

def run():
    asyncio.ensure_future(handle_event(pwrkey))

    loop = asyncio.get_event_loop()
    loop.run_forever()

if __name__ == "__main__": # admire
    run()

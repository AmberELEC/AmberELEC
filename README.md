# 351ELEC
  
A fork of EmuELEC for the Anbernic RG351P

Based on (forked from) [EmuELEC](https://github.com/EmuELEC/EmuELEC) 3.9 which is based on [CoreELEC](https://github.com/CoreELEC/CoreELEC) and [Lakka](https://github.com/libretro/Lakka-LibreELEC) with tidbits from [Batocera](https://github.com/batocera-linux/batocera.linux).

This fork is only intended to be used with the Anbernic RG351P and is not compatible with other devices.  It requires a 16GB microSD minimum.  It will create a boot partition, a storage partition, and a games partition (FAT32).

Building a firmware with the Anbernic kernel (AK) requires first building the lualiliu kernel (LI).  The lualiliu kernel build does not boot yet.

```
sudo apt update && sudo apt upgrade
sudo apt-get install gcc make git unzip wget xz-utils libsdl2-dev libsdl2-mixer-dev libfreeimage-dev libfreetype6-dev libcurl4-openssl-dev rapidjson-dev libasound2-dev libgl1-mesa-dev build-essential libboost-all-dev cmake fonts-droid-fallback libvlc-dev libvlccore-dev vlc-bin texinfo premake4 golang libssl-dev curl patchelf xmlstarlet
git clone https://github.com/fewtarius/351ELEC.git 351ELEC    
cd 351ELEC
git checkout master  
make world
```

The resulting image will be located in 351ELEC/target.  Use 'dd' or your favorite image writer to write it to a microSD.  Note: The first boot after partitioning will take a minute or two, subsequent boots are much faster.

If you want to build the addon: 
```
cd 351ELEC
./emuelec-addon.sh
```
Resulting zip files will be inside 351ELEC/repo

**License**

351ELEC is based on EmuELEC which is based on CoreELEC which in turn is licensed under the GPLv2 (and GPLv2-or-later), all original files created by the 351ELEC team are licensed as GPLv2-or-later and marked as such.

However, like EmuELEC the distro includes many non-commercial emulators/libraries/cores/binaries and as such, **it cannot be sold, bundled, offered, included, or anything similar, in any commercial product/application including but not limited to: Android Devices, Smart-TVs, TV-boxes, Hand-held Devices, Computers, SBCs, or anything else that can run EmuELEC.** with those emulators/libraries/cores/binaries included.

I will also add this from the CoreELEC readme, adapted to EmuELEC, and now to 351ELEC:

As 351ELEC includes code from many upstream projects it includes many copyright owners. 351ELEC makes NO claim of copyright on any upstream code. Patches to upstream code have the same license as the upstream project, unless specified otherwise. For a complete copyright list please checkout the source code to examine license headers. Unless expressly stated otherwise all code submitted to the 351ELEC project (in any form) is licensed under GPLv2-or-later. You are absolutely free to retain copyright. To retain copyright simply add a copyright header to each submitted code page. If you submit code that is not your own work it is your responsibility to place a header stating the copyright.

**Branding**

All 351ELEC related logos, videos, images and branding in general are the sole property of 351ELEC and they are all Copyrighted by the 351ELEC team and are not to be included in any commercial application whatsoever without the proper authorization, (yes, this includes 351ELEC bundled with ROMS for donations!).

You are however granted permission to include/modify them in your forks/projects as long as they are completely open-source, freely available (as in [but not limited to] not under a bunch of "click this sponsored ad to get the link!"), and do not infringe on any copyright laws, even if you receive donations for such project (we are not against donations for honest people!), we only ask that you give us the proper credit and if possible a link to this repo.

Happy retrogaming! 

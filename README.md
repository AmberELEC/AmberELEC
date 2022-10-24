![GitHub-Mark-Dark](https://camo.githubusercontent.com/9d21b94911995ca5ed907fd1688dae360411a1d792a6f4047962041ca12b0b02/68747470733a2f2f616d626572656c65632e6f72672f696d616765732f7472616e73706172656e745f616d6265725f656c65635f686f72697a2e7376672367682d6461726b2d6d6f64652d6f6e6c79#gh-dark-mode-only)
![GitHub-Mark-Light](https://camo.githubusercontent.com/1ecfd366cc8fc1bf3dab7a1f685280e2f88f0f43946a9ca784a044ef883fe375/68747470733a2f2f616d626572656c65632e6f72672f696d616765732f7472616e73706172656e745f626c61636b5f616d6265725f656c65635f686f72697a2e7376672367682d6c696768742d6d6f64652d6f6e6c79#gh-light-mode-only)
<br />An open source firmware for the Anbernic RG351P/M/V/MP and RG552 devices.<p>
[![GitHub Release](https://img.shields.io/github/release/AmberELEC/AmberELEC.svg?label=latest%20release&style=flat-square)](https://github.com/AmberELEC/AmberELEC/releases/latest)
[![GPL-2.0 Licensed](https://shields.io/badge/license-GPL2-blue?style=flat-square)](https://github.com/AmberELEC/AmberELEC/blob/main/licenses/GPL2.txt)
[![Discord](https://img.shields.io/discord/777665344289898536?label=chat%20on%20discord&logo=discord&style=flat-square)](https://discord.com/invite/R9Er7hkRMe)
<br />
[![Downloads Latest](https://img.shields.io/github/downloads/AmberELEC/AmberELEC/latest/total?label=downloads%40latest%20release&style=flat-square)](https://github.com/AmberELEC/AmberELEC/releases/latest)
[![Downloads Prerelease](https://img.shields.io/github/downloads/AmberELEC/AmberELEC-prerelease/total?label=downloads%40prerelease%20builds&style=flat-square)](https://github.com/AmberELEC/AmberELEC-prerelease/releases)


AmberELEC (formerly know as 351ELEC) is a fork of [EmuELEC](https://github.com/EmuELEC/EmuELEC) which is based on [CoreELEC](https://github.com/CoreELEC/CoreELEC), [Lakka](https://github.com/libretro/Lakka-LibreELEC), and [Batocera](https://github.com/batocera-linux/batocera.linux). It is intended for use only on the RG351P/M/V/MP and RG552, it is not compatible with any other device.

We have a [Website](https://amberelec.org) with [installation instructions](https://amberelec.org/installation#overview) and a lot of information on how to [get started using AmberELEC](https://amberelec.org/guides/getting-to-know-amberelec).

Visit us on our Discord! https://discord.com/invite/R9Er7hkRMe


## Installation

Please visit our Website [Installation](https://amberelec.org/installation#overview) page for installation instructions.

## Building from Source
Building AmberELEC from source is a fairly simple process. It is recommended to have a minimum of 4 cores, 16GB of RAM, and an SSD with 200GB of free space. The build environment used to develop these steps uses Ubuntu 20.04, your mileage may vary when building on other distributions.

```
sudo apt update && sudo apt upgrade

sudo apt install gcc make git unzip wget xz-utils libsdl2-dev libsdl2-mixer-dev libfreeimage-dev libfreetype6-dev libcurl4-openssl-dev rapidjson-dev libasound2-dev libgl1-mesa-dev build-essential libboost-all-dev cmake fonts-droid-fallback libvlc-dev libvlccore-dev vlc-bin texinfo premake4 golang libssl-dev curl patchelf xmlstarlet patchutils gawk gperf xfonts-utils default-jre python xsltproc libjson-perl lzop libncurses5-dev device-tree-compiler u-boot-tools rsync p7zip unrar libparse-yapp-perl zip binutils-aarch64-linux-gnu dos2unix p7zip-full libvpx-dev meson

git clone https://github.com/AmberELEC/AmberELEC.git AmberELEC

cd AmberELEC

make clean

make world
```

The make world process will build and generate a image which will be located in AmberELEC/release. Follow the installation steps to write your image to a microSD.
It will build for the RG351P/M, RG351V, RG351MP and for the RG552.

To create the image for the RG351P/M just ``make RG351P``, and just for the RG351V ``make RG351V``, and just for the RG351MP ``make RG351MP``, and just for the RG552 ``make RG552``.

## Building from Source - Docker
Building with Docker simplifies the build process as any dependencies, with the exception of `make`, are contained within the docker image - all CPU/RAM/Disk/build time requirements remain similar. 

NOTE: Make can be installed with `sudo apt update && sudo apt install -y make` on Ubuntu-based systems.

All make commands are available via docker, by prepending `docker-`. `make RG351V` becomes `make docker-RG351V` and `make clean` becomes `make docker-clean`.

New docker make commands: 
- `make docker-image-build` - Builds the docker image based on the Dockerfile. This is not required unless changes are needed locally. 
- `make docker-image-pull` - Pulls docker image from dockerhub. This will update to the latest image and replace any locally built changes to the docker file.
- `make docker-shell` - (advanced) Launches a shell inside the docker build container. This allows running any development commands like `./scripts/build`, etc, which aren't in the Makefile.
  - NOTE: Errors like `groups: cannot find name for group ID 1002` and the user being listed as `I have no name!` are OK and a result of mapping the host user/group into the docker container where the host user/groups may not exist.

Example building with docker:
```
git clone https://github.com/AmberELEC/AmberELEC.git AmberELEC
cd AmberELEC
make docker-clean
make docker-world
```

## Automated Dev Builds
Builds are automatically run on commits to `main` and for Pull Requests (*PR's*) from previous committers.

Development builds can be found looking for the green checkmarks next to commit history. Artifacts are generated for each build which can be used to update the RG351P/RG351V and are stored for 30 days by GitHub. Note that due to Github Action limitations, artifacts are zipped (.img.gz and .tar are inside the zip file).

All artifacts generated by builds should be considered 'unstable' and only used by developers or advanced users who want to test the latest code.

See: [Build Overview](.github/workflows/README.md) for more information.

### GitHub Actions and Forks
Builds use GitHub actions (`.github/workflow`) to execute. GitHub validates that changes to the `.github/workflow` folder require a special `workflow` permission. 

When using [Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) to push in upstream changes from AmberELEC into your fork, you may get an error similar to the following:

```
! [remote rejected] main -> main (refusing to allow a Personal Access Token to create or update workflow `.github/workflows/README.md` without `workflow` scope)
error: failed to push some refs to 'https://github.com/my-AmberELEC-fork/AmberELEC.git'
```

To fix, edit the [Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) to add `workflow` permissions (or create a new token with workflow permission).

Alternatively, [ssh-key authentication](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) can be used.

## License

AmberELEC (formerly known as 351ELEC) is a fork of EmuELEC which is based on CoreELEC which in turn is licensed under the GPLv2 (and GPLv2-or-later), all original files created by the AmberELEC team are licensed as GPLv2-or-later and marked as such.

This firmware includes many non-commercial emulators/libraries/cores/binaries and as such, **it cannot be sold, bundled, offered, included, or anything similar, in any commercial product/application including but not limited to: Android Devices, Smart-TVs, TV-boxes, Hand-held Devices, Computers, SBCs, or anything else that can run AmberELEC.** with those emulators/libraries/cores/binaries included.

As AmberELEC includes code from many upstream projects it includes many copyright owners. AmberELEC makes NO claim of copyright on any upstream code. Patches to upstream code have the same license as the upstream project, unless specified otherwise. For a complete copyright list please checkout the source code to examine license headers. Unless expressly stated otherwise all code submitted to the AmberELEC project (in any form) is licensed under GPLv2-or-later. You are absolutely free to retain copyright. To retain copyright simply add a copyright header to each submitted code page. If you submit code that is not your own work it is your responsibility to place a header stating the copyright.

## Branding

All AmberELEC (formerly known as 351ELEC) related logos, videos, images and branding in general are the sole property of AmberELEC and they are all Copyrighted by the AmberELEC team and are not to be included in any commercial application whatsoever without the proper authorization! AmberELEC may not be bundled with games or distributed as donationware!

You are however granted permission to include/modify them in your forks/projects as long as they are completely open-source, freely available (as in [but not limited to] not under a bunch of "click this sponsored ad to get the link!"), and do not infringe on any copyright laws, even if you receive donations for such project (we are not against donations for honest people!), we only ask that you give us the proper credit and if possible a link to this repo.

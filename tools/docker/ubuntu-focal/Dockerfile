FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y locales sudo \
 && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8 \
 && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US:en
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN adduser --disabled-password --gecos '' docker \
 && adduser docker sudo \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN apt-get update && apt-get install -y \
    bash bc binutils bsdmainutils build-essential bzip2 cmake cpp curl \
    default-jre default-jre-headless device-tree-compiler diffutils dpkg-dev \
    file fonts-droid-fallback g++ g++-multilib gawk gcc gcc-7 git golang \
    golang-go gperf gzip libasound2-dev libboost-all-dev libc-dev libc6-dev \
    libcurl4-openssl-dev libfreeimage-dev libfreetype6-dev libgl1-mesa-dev \
    libjson-perl libncurses5-dev libsdl2-dev libsdl2-mixer-dev libssl-dev \
    libvlc-dev libvlccore-dev libxml-parser-perl libzip-dev lzop make \
    openssh-client p7zip patch patchelf patchutils perl premake4 python \
    python3 rapidjson-dev rsync sed tar texinfo u-boot-tools unzip vlc-bin \
    wget xfonts-utils xmlstarlet xsltproc xz-utils zip libparse-yapp-perl \
    unrar \
    --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

USER docker

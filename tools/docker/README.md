# Build container

## Clone repo

_(You've likely already done this if you're reading this from a local repo...)_

 - `git clone https://github.com/fewtarius/351ELEC.git 351ELEC`

## Build the container

 - `cd 351ELEC`
 - `docker build --pull -t 351elec-build tools/docker/ubuntu-focal`

## Build image inside container

 - `docker run --rm -v "$(pwd)":/var/351elec-build -w /var/351elec-build 351elec-build make`

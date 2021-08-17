# Build container

## Clone repo

_(You've likely already done this if you're reading this from a local repo...)_

 - `git clone https://github.com/fewtarius/351ELEC.git 351ELEC`

## Build the container

 - `cd 351ELEC`
 - `docker build --pull -t 351elec-build tools/docker/ubuntu-focal`

## Build image inside container

 - `docker run --rm -v "$(pwd)":/var/351elec-build -w /var/351elec-build 351elec-build make`

### NOTE

The build process requires a substantial amount of resources, for CPU cores, RAM, and disk volume space.

While most of the process will simply scale with your available computer resources and power, the volume space is a pretty hard requirement.

At the time of writing this, the build process alone took ~95GB of volume storage space.

If you run into any errors such as "no space left on device" or similar, you'll likely need to tweak your Docker configuration to allow for more space to be allocated.

# Build container

## Clone repo

_(You've likely already done this if you're reading this from a local repo...)_

 - `git clone https://github.com/fewtarius/351ELEC.git 351ELEC`

## Build the container

 - `cd 351ELEC`
 - `docker build --pull -t 351elec tools/docker/bionic`

## Build image inside container

 - `docker run -v "$(pwd)":/home/docker -w /home/docker -h docker-351elec -it 351elec`
 - `make`

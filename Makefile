BUILD_DIRS=build.*

all:

system:
	./scripts/image

release:
	./scripts/image release

image:
	./scripts/image mkimage

noobs:
	./scripts/image noobs

clean:
	rm -rf $(BUILD_DIRS)

distclean:
	rm -rf ./.ccache ./$(BUILD_DIRS)

src-pkg:
	tar cvJf sources.tar.xz sources .stamps

world: RG351P RG351V

RG351P: p-arm p-aarch64

RG351V: v-arm v-aarch64

p-arm:
	DEVICE=RG351P ARCH=arm ./scripts/build_distro

p-aarch64:
	DEVICE=RG351P ARCH=aarch64 ./scripts/build_distro

v-arm:
	DEVICE=RG351V ARCH=arm ./scripts/build_distro

v-aarch64:
	DEVICE=RG351V ARCH=aarch64 ./scripts/build_distro

update:
	DEVICE=RG351P ARCH=aarch64 ./scripts/update_packages


## Docker builds - overview
# docker-* commands just wire up docker to call the normal make command via docker
# For example: make docker-RG351V will use docker to call: make RG351V
# All variables are scoped to docker-* commands to prevent weird collisions/behavior with non-docker commands

docker-%: DOCKER_IMAGE := "351build/351elec-build:latest"

# UID is the user ID of current user - ensures docker sets file permissions properly
docker-%: UID := $(shell id -u)

# GID is the main user group of current user - ensures docker sets file permissions properly
docker-%: GID := $(shell id -g)

# PWD is 'present working directory' and passes through the full path to current dir to docker (becomes 'work')
docker-%: PWD := $(shell pwd)

# Use 'sudo' if docker ps doesn't work.  In theory, other things than missing sudo could cause this.  But sudo needed is a common issue and easy to fix.
docker-%: SUDO := $(shell if ! docker ps -q 2>&1 > /dev/null; then echo "sudo"; fi)

# Launch docker as interactive if this is an interactive shell (allows ctrl-c for manual and running non-interactive - aka: build server)
docker-%: INTERACTIVE=$(shell [ -t 0 ] && echo "-it")

# Command: builds docker image locally from Dockerfile
docker-image-build:
	$(SUDO) docker build . -t $(DOCKER_IMAGE)
# Command: pulls latest docker image from dockerhub.  This will *replace* locally built version.
docker-image-pull:
	$(SUDO) docker pull $(DOCKER_IMAGE)

# Wire up docker to call equivalent make files using % to match and $* to pass the value matched by %
docker-%:
	$(SUDO) docker run $(INTERACTIVE) --rm --user $(UID):$(GID) -v $(PWD):/work $(DOCKER_IMAGE) make $*


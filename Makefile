BUILD_DIRS=build.*

all: clean world

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

world: arm aarch64

arm:
	ARCH=arm ./scripts/build_distro

aarch64:
	ARCH=aarch64 ./scripts/build_distro

update:
	./scripts/package_bump

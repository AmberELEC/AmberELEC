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

BUILD_DIRS=build.*

all: release

system:
	./scripts/image

release:
	./scripts/image release

image:
	./scripts/image mkimage

noobs:
	./scripts/image noobs

clean:
	rm -rf $(BUILD_DIRS)/* $(BUILD_DIRS)/.stamps

distclean:
	rm -rf ./.ccache ./$(BUILD_DIRS)

src-pkg:
	tar cvJf sources.tar.xz sources .stamps

ak:
	./scripts/build_distro ak

li:
	./scripts/build_distro li

world:
	./scripts/build_distro world

reset:
	./scripts/build_distro reset

update:
	./scripts/package_bump

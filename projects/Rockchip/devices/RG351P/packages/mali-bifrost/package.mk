# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mali-bifrost"
PKG_VERSION="43b24f4a2c7cda2144210e6ca6c62eaaf8a29497"
PKG_SHA256="1b6b81d29d352595c2f2ace495c311bd0189d55352b5c4bc6d5a2022eafb9a39"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/rockchip-linux/libmali"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libdrm"
PKG_LONGDESC="The Mali GPU library used in Rockchip Platform for Odroidgo Advance"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
	# remove all the extra blobs, we only need one
	rm -rf $INSTALL/usr
	mkdir -p $INSTALL/usr/lib/
        mkdir -p $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib

	cp -pr $PKG_BUILD/include $TOOLCHAIN/$TARGET_NAME/sysroot/usr
	cp $PKG_BUILD/include/GBM/gbm.h $TOOLCHAIN/$TARGET_NAME/sysroot/usr/include/gbm.h
	ln -sf $TOOLCHAIN/$TARGET_NAME/sysroot/usr/include/KHR/mali_khrplatform.h $TOOLCHAIN/$TARGET_NAME/sysroot/usr/include/KHR/khrplatform.h

        if [ $TARGET_ARCH == 'aarch64' ]
	then
     		mkdir -p $INSTALL/usr/lib32/
        	mkdir -p $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib32

		cp $PKG_BUILD/lib/aarch64-linux-gnu/libmali-bifrost-g31-rxp0-gbm.so $INSTALL/usr/lib/libmali.so.1
		cp -PR $PKG_BUILD/lib/aarch64-linux-gnu/libmali-bifrost-g31-rxp0-gbm.so $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib/libmali.so.1
		ln -sf /usr/lib/libmali.so.1 $INSTALL/usr/lib/libmali.so
		ln -sf $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib/libmali.so.1 $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib/libmali.so

                for lib in libEGL.so \
                           libEGL.so.1 \
                           libgbm.so \
                           libGLESv2.so \
                           libGLESv2.so.2 \
                           libGLESv3.so \
                           libGLESv3.so.3 \
                           libGLESv1_CM.so.1 \
                           libGLES_CM.so.1
		do
			ln -sf /usr/lib/libmali.so $INSTALL/usr/lib/${lib}
			ln -sf /usr/lib32/libmali.so $INSTALL/usr/lib32/${lib}
        		ln -sf $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib/libmali.so $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib/${lib}
        		ln -sf $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib32/libmali.so $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib32/${lib}
        	done
	else
        	mkdir -p $INSTALL/usr/lib/
        	mkdir -p $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib

	        cp -pr $PKG_BUILD/include $TOOLCHAIN/$TARGET_NAME/sysroot/usr
	        cp $PKG_BUILD/include/GBM/gbm.h $TOOLCHAIN/$TARGET_NAME/sysroot/usr/include/gbm.h
		ln -sf $TOOLCHAIN/$TARGET_NAME/sysroot/usr/include/KHR/mali_khrplatform.h $TOOLCHAIN/$TARGET_NAME/sysroot/usr/include/KHR/khrplatform.h

        	cp $PKG_BUILD/lib/arm-linux-gnueabihf/libmali-bifrost-g31-rxp0-gbm.so $INSTALL/usr/lib/libmali.so.1
        	cp -PR $PKG_BUILD/lib/arm-linux-gnueabihf/libmali-bifrost-g31-rxp0-gbm.so $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib/libmali.so.1
		ln -sf /usr/lib/libmali.so.1 $INSTALL/usr/lib/libmali.so
                ln -sf $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib/libmali.so.1 $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib/libmali.so

        	for lib in libEGL.so \
			   libEGL.so.1 \
			   libgbm.so \
			   libGLESv2.so \
			   libGLESv2.so.2 \
                           libGLESv3.so \
			   libGLESv3.so.3 \
			   libGLESv1_CM.so.1 \
			   libGLES_CM.so.1
        	do
        		ln -sf /usr/lib/libmali.so $INSTALL/usr/lib/${lib}
        		ln -sf $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib/libmali.so $TOOLCHAIN/$TARGET_NAME/sysroot/usr/lib/${lib}
        	done
	fi
}

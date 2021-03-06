ETHERLAB=ethercat-hg
KERNEL=kernel
UBOOT=u-boot

CROSS_PREFIX=arm-linux-gnueabihf-
MAKE_JOBS=-j `nproc`

etherlab:
	cd ${ETHERLAB} && ./configure --host=arm-linux-gnueabihf --with-linux-dir=`pwd`/../${KERNEL} --disable-generic --disable-8139too --disable-eoe --disable-tool --enable-ccat
	cd ${ETHERLAB} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} clean
	cd ${ETHERLAB} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} ${MAKE_JOBS}
	cd ${ETHERLAB} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} ${MAKE_JOBS} modules

uboot:
	cd ${UBOOT} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} distclean
	cd ${UBOOT} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} mx53cx9020_defconfig
	cd ${UBOOT} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} ${MAKE_JOBS}

kernel:
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} oldconfig
#	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} menuconfig
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} ${MAKE_JOBS}
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} ${MAKE_JOBS} modules
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} imx53-cx9020.dtb
	cp -a ${KERNEL}/.config kernel-patches/config-CX9020

.PHONY: busybox dropbear glibc kernel install uboot prepare_disk install_rootfs install_small install_smallrootfs post_install install_debian

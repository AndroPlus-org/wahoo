#!/bin/sh

# This is a temporary, simple build script until twrp is ready for anykernel

export ARCH=arm64
export SUBARCH=arm64
#export CLANG_PATH=~/sdclang/linux-x86/bin/
export CLANG_PATH=~/Desktop/kernel/wahoo/tools/linux-x86/clang-3859424/bin/
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=~/aarch64-linux-android-4.9-aosp/bin/aarch64-linux-android-
export MKDTBIMG_PATH=~/bin/
export PATH=${MKDTBIMG_PATH}:${PATH}
export LD_LIBRARY_PATH=:${LD_LIBRARY_PATH}

#make mrproper -j8
make snoke_defconfig
make CC=clang -j8
make CC=clang dtbs -j8

if [ -f arch/arm64/boot/Image.lz4-dtb ]
then

cp -a arch/arm64/boot/dtbo.img ../tools/dtbo.img
../tools/mkbootimg \
	--kernel arch/arm64/boot/Image.lz4-dtb \
	--ramdisk ../tools/boot.img-ramdisk.cpio.gz \
	--cmdline "console=ttyMSM0,115200,n8 earlycon=msm_serial_dm,0xc1b0000 androidboot.hardware=taimen androidboot.console=ttyMSM0 lpm_levels.sleep_disabled=1 user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3 service_locator.enable=1 swiotlb=2048 firmware_class.path=/vendor/firmware loop.max_part=7 buildvariant=user" \
	--base 0x00000000 \
        --kernel_offset 0x00008000 \
        --ramdisk_offset 0x01000000 \
        --tags_offset 0x00000100 \
        --pagesize 4096 \
	--output ../tools/boot.img
fi

#!/bin/bash

. variables.sh

for command_ in binwalk mksquashfs qemu-mipsel-static; do
	command -v mksquashfs >/dev/null || { echo "${command_} command is missing" ; exitFlag="true" ; }
done

[ "exitFlag" == "true" ] && { echo "Please install missing package(s) before running this script" ; exit 1 ; }
echo
echo "----------- 01_extract_firmware.sh --------"
./01_extract_firmware.sh && \

echo
echo "----------- 02_chroot.sh ------------------"
./02_chroot.sh -a && \

echo
echo "----------- 03_configure_aback.sh ---------"
./03_configure_aback.sh && \

echo
echo "----------- 04_configure_app.sh -----------"
./04_configure_app.sh && \

echo
echo "----------- 05_configure_rootfs.sh --------"
./05_configure_rootfs.sh && \

echo
echo "----------- 06_generate_images.sh ---------"
./06_generate_images.sh

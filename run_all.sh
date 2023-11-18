#!/bin/bash

. variables.sh

for cmd in binwalk mksquashfs qemu-mipsel-static dropbear; do
	command -v mksquashfs >/dev/null || { echo "${cmd} command is missing" ; exitFlag="true" ; }
done



[ "exitFlag" == "true" ] && { echo "Please install missing package(s) before running this script" ; exit 1 ; }
echo
echo "----------- 01_unpack.sh --------"
./01_unpack.sh && \

echo
echo "----------- 02_chroot.sh ------------------"
./02_chroot.sh --install && \

echo
echo "----------- 03_configure.sh --------"
./03_configure.sh && \

echo
echo "----------- 04_repack.sh ---------"
./04_repack.sh

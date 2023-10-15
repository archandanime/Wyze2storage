#!/bin/bash
#
# Description: This script extract kernel, rootfs, app images from firmware upgrade file demo_wcv3.bin,
# then decompress rootfs and app images for later modification
#

. variables.sh



echo "- Determining rootfs start address and size in upgrade file ..."
[ ! -f ${UPGRADE_FILE} ] && { echo "${UPGRADE_FILE} does not exist" ; exit 1 ; }

binwalk_result=`binwalk ${UPGRADE_FILE}`

kernel_start_addr="64"
rootfs_start_addr="2031680"
app_start_addr="6029376"
upgrade_file_size=`du -b ${UPGRADE_FILE} | cut -f1`

kernel_size=$(( ${rootfs_start_addr} - ${kernel_start_addr}))
rootfs_size=$(( ${app_start_addr} - ${rootfs_start_addr} ))
app_size=$(( ${upgrade_file_size} - ${app_start_addr} ))

echo -n "- Extracting kernel image from firmware upgrade file ... "
if [ ! -f ${OUT_KERNEL_IMG} ]; then
	dd if=${UPGRADE_FILE} of=${OUT_KERNEL_IMG} bs=1 skip=${kernel_start_addr} count=${kernel_size} status=none && echo "done"
	md5sum ${OUT_KERNEL_IMG} > ${OUT_KERNEL_IMG}.md5sum
	sed -i 's/output\///g' ${OUT_KERNEL_IMG}.md5sum
else
	echo "${OUT_KERNEL_IMG} exists"
	exit 1
fi

echo -n "- Extracting rootfs image from firmware upgrade file ... "
if [ ! -f ${ROOTFS_IMG} ]; then
	dd if=${UPGRADE_FILE} of=${ROOTFS_IMG} bs=1 skip=${rootfs_start_addr} count=${rootfs_size} status=none && echo "done"
else
	echo "${ROOTFS_IMG} exists"
	exit 1
fi

echo -n "- Extracting app image from firmware upgrade file ... "
if [ ! -f ${OUT_APP_IMG} ]; then
	dd if=${UPGRADE_FILE} of=${APP_IMG} bs=1 skip=${app_start_addr} count=${app_size} status=none && echo "done"
else
	echo "${APP_IMG} exists"
	exit 1
fi



echo -n "- Uncompressing rootfs image ... "
if [ ! -d ${ROOTFS_DIR} ]; then
	unsquashfs ${ROOTFS_IMG} >/dev/null && echo "done"
	mv squashfs-root ${ROOTFS_DIR}
fi

echo -n "- Uncompressing app image ... "
if [ ! -d ${APP_DIR} ]; then
	unsquashfs ${APP_IMG} >/dev/null && echo "done"
	mv squashfs-root ${APP_DIR}
fi

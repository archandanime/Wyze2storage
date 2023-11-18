#!/bin/bash
#
# Description: This script extract kernel, rootfs, app images from firmware upgrade file demo_wcv3.bin,
# then decompress rootfs and app images for later modification
#

. variables.sh




[ ! -f ${UPGRADE_FILE} ] && { echo "${UPGRADE_FILE} does not exist" ; exit 1 ; }

binwalk_result=`binwalk ${UPGRADE_FILE}`

kernel_start_addr="64"
rootfs_start_addr="2031680"
app_start_addr="6029376"
upgrade_file_size=`du -b ${UPGRADE_FILE} | cut -f1`

kernel_size=$(( ${rootfs_start_addr} - ${kernel_start_addr}))
rootfs_size=$(( ${app_start_addr} - ${rootfs_start_addr} ))
app_size=$(( ${upgrade_file_size} - ${app_start_addr} ))



echo -n "- Extracting kernel image... "
[ -f ${OUT_KERNEL_IMG} ] && { echo "${OUT_KERNEL_IMG} exists" ; exit 1 ; }
dd if=${UPGRADE_FILE} of=${OUT_KERNEL_IMG} bs=1 skip=${kernel_start_addr} count=${kernel_size} status=none && echo "done"
md5sum ${OUT_KERNEL_IMG} > ${OUT_KERNEL_IMG}.md5sum
sed -i 's/output\///g' ${OUT_KERNEL_IMG}.md5sum


echo -n "- Extracting rootfs image..."
[ -f ${ROOTFS_IMG} ] && { echo "${ROOTFS_IMG} exists" ; exit 1 ; }
dd if=${UPGRADE_FILE} of=${ROOTFS_IMG} bs=1 skip=${rootfs_start_addr} count=${rootfs_size} status=none && echo "done"


echo -n "- Extracting app image... "
[ -f ${APP_IMG} ] && { echo "${APP_IMG} exists" ; exit 1 ; }
dd if=${UPGRADE_FILE} of=${APP_IMG} bs=1 skip=${app_start_addr} count=${app_size} status=none && echo "done"


echo -n "- Uncompressing rootfs image... "
[ -d ${ROOTFS_DIR} ] && { echo ${ROOTFS_DIR} exists ; exit 1 ; }
mkdir -p ${ROOTFS_DIR}
unsquashfs -d ${ROOTFS_DIR} ${ROOTFS_IMG} >/dev/null && echo "done"
echo " + rootfs version: $(cat ${ROOTFS_DIR}/usr/app.ver | tail -n 1 | cut -d '=' -f2)"


echo -n "- Uncompressing app image... "
[ ! -z "$(ls -A ${ROOTFS_DIR}/system)" ] && { echo ${ROOTFS_DIR}/system is not empty ; exit 1 ; }
mkdir -p ${ROOTFS_DIR}/system/
unsquashfs -d ${ROOTFS_DIR}/system/ ${APP_IMG} >/dev/null && echo "done"
echo " + app version: $(cat ${ROOTFS_DIR}/system/bin/app.ver | tail -n 1 | cut -d '=' -f2)"


echo
echo -n "- Changing permissions... "
sudo chown 1000:1000 -R ${ROOTFS_DIR} && echo "done"

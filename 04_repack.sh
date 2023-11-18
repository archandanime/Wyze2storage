#!/bin/bash
#
# Descriptions: This script rootfs image
#

. variables.sh


[ -f ${OUT_ROOTFS_IMG} ] && { echo "WARNING: ${OUT_ROOTFS_IMG} exists, move it somewhere else first" ; exit 1 ; }

mountpoint -q ${ROOTFS_DIR}/opt/ && sudo umount ${ROOTFS_DIR}/opt/
echo -n " - Generating aback rootfs image ... "
mksquashfs ${ROOTFS_DIR} ${OUT_ROOTFS_IMG} -one-file-system-x -comp xz -all-root -no-progress > /dev/null && echo "done"

md5sum ${OUT_ROOTFS_IMG} > ${OUT_ROOTFS_IMG}.md5sum
sed -i 's/output\///g' ${OUT_ROOTFS_IMG}.md5sum

echo "Output rootfs image size:"
[ -f ${OUT_ROOTFS_IMG} ] && du ${OUT_ROOTFS_IMG}


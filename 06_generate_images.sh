#!/bin/bash
#
# Descriptions: This script generates rootfs, app and aback images
#

. variables.sh


function generate_aback_img() {
	echo -n " - Generating aback squashfs image ... "
	mksquashfs ${ABACK_DIR} ${OUT_ABACK_IMG} -comp xz -all-root -no-progress > /dev/null && echo "done"
	md5sum ${OUT_ABACK_IMG} > ${OUT_ABACK_IMG}.md5sum
	sed -i 's/output\///g' ${OUT_ABACK_IMG}.md5sum
}

function generate_app_img() {
	echo -n " - Generating app squashfs image ... "
	mksquashfs ${APP_DIR} ${OUT_APP_IMG} -comp xz -all-root -no-progress > /dev/null && echo "done"
	md5sum ${OUT_APP_IMG} > ${OUT_APP_IMG}.md5sum
	sed -i 's/output\///g' ${OUT_APP_IMG}.md5sum
}

function generate_rootfs_img() {
	mountpoint -q ${ROOTFS_DIR}/opt/ && sudo umount ${ROOTFS_DIR}/opt/
	echo -n " - Generating aback rootfs image ... "
	mksquashfs ${ROOTFS_DIR} ${OUT_ROOTFS_IMG} -one-file-system-x -comp xz -all-root -no-progress > /dev/null && echo "done"

	md5sum ${OUT_ROOTFS_IMG} > ${OUT_ROOTFS_IMG}.md5sum
	sed -i 's/output\///g' ${OUT_ROOTFS_IMG}.md5sum
}



[ ! -f ${OUT_ABACK_IMG} ] && generate_aback_img || echo "Warning: ${OUT_ABACK_IMG} exists, move it somewhere else first"
[ ! -f ${OUT_APP_IMG} ] && generate_app_img || echo "Warning: ${OUT_APP_IMG} exists, move it somewhere else first"
[ ! -f ${OUT_ROOTFS_IMG} ] && generate_rootfs_img || echo "Warning: ${OUT_ROOTFS_IMG} exists, move it somewhere else first"



echo
echo "Output files size:"
for file_ in ${ROOTFS_IMG} ${APP_IMG} ${OUT_ROOTFS_IMG} ${OUT_APP_IMG} ${OUT_ABACK_IMG} ; do
	[ -f ${file_} ] && du ${file_}
done

[ ! -f output/w2s_copy_dropbear.shh ] && cp resources/w2s_copy_dropbear.sh output/
[ ! -f output/wcv3_flash-helper.conf ] && cp resources/wcv3_flash-helper.conf output/

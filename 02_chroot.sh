#!/bin/bash
#
# Description: This script allows user to enter chroot environment of extracted rootfs image to install Entware packages.
# With "-a" option, Entware packages installation is automatic
#
#
. variables.sh


echo "- Making files that are needed for chroot"
[ ! -f ${ROOTFS_DIR}/inchroot_install_opt_packages.sh ] && cp inchroot_install_opt_packages.sh ${ROOTFS_DIR}/
[ ! -f ${ROOTFS_DIR}/usr/bin/qemu-mipsel-static ] && cp /usr/bin/qemu-mipsel-static ${ROOTFS_DIR}/usr/bin
[ ! -f ${ROOTFS_DIR}/variables.sh ] && cp variables.sh ${ROOTFS_DIR}


echo "- Mounting virtual filesystems in ${ROOTFS_DIR}"

! mountpoint -q ${ROOTFS_DIR}/dev && sudo mount -t devtmpfs devtmpfs ${ROOTFS_DIR}/dev
! mountpoint -q ${ROOTFS_DIR}/proc && sudo mount -t proc none ${ROOTFS_DIR}/proc
! mountpoint -q ${ROOTFS_DIR}/sys && sudo mount -t sysfs sysfs ${ROOTFS_DIR}/sys

echo "- Entering chroot"
if [ "${1}" == "--install" ]; then
	sudo chroot ${ROOTFS_DIR} qemu-mipsel-static /bin/sh -c ". /etc/profile && /inchroot_install_opt_packages.sh"
else
	echo "After entering chroot environment, type the following to be able to execute commands:"
	echo ". /etc/profile"
	echo "then to install packages, execute: "
	echo "/inchroot_install_opt_packages.sh"
	sudo chroot ${ROOTFS_DIR} qemu-mipsel-static /bin/sh
fi

echo "- Umounting virtual filesystems in ${ROOTFS_DIR}"
for mountpoint_ in dev sys proc opt; do
	while mountpoint -q ${ROOTFS_DIR}/${mountpoint_}; do
		sudo umount ${ROOTFS_DIR}/${mountpoint_}
	done
done

echo "- Cleaning up files that was needed for chroot"

trash_files="${ROOTFS_DIR}/inchroot_install_opt_packages.sh ${ROOTFS_DIR}/usr/bin/qemu-mipsel-static ${ROOTFS_DIR}/variables.sh ${ROOTFS_DIR}/root/.ash_history"

for trash_file in ${trash_files}; do
	[ -f ${trash_file} ] && rm -f ${trash_file}
done

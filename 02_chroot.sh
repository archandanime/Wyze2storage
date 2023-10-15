#!/bin/bash
#
# Description: This script allows user to enter chroot environment of extracted rootfs image to install Entware packages.
# With "-a" option, Entware packages installation is automatic
#
#
. variables.sh


echo "- Making files that was needed for chroot ... "
[ ! -f ${ROOTFS_DIR}/inchroot_install_opt_packages.sh ] && cp inchroot_install_opt_packages.sh ${ROOTFS_DIR}/
[ ! -f ${ROOTFS_DIR}/usr/bin/qemu-mipsel-static ] && cp /usr/bin/qemu-mipsel-static ${ROOTFS_DIR}/usr/bin
[ ! -f ${ROOTFS_DIR}/variables.sh ] && cp variables.sh ${ROOTFS_DIR}


echo "- Mounting virtual filesystems in ${ROOTFS_DIR} ..."

! mountpoint -q ${ROOTFS_DIR}/dev && sudo mount -t devtmpfs devtmpfs ${ROOTFS_DIR}/dev
! mountpoint -q ${ROOTFS_DIR}/proc && sudo mount -t proc none ${ROOTFS_DIR}/proc
! mountpoint -q ${ROOTFS_DIR}/sys && sudo mount -t sysfs sysfs ${ROOTFS_DIR}/sys


echo "- Mounting ${ROOTFS_DIR}/opt ..."
if [ ! -d ${ABACK_DIR} ]; then
	mkdir ${ABACK_DIR}
	sudo mount --bind ${ABACK_DIR} ${ROOTFS_DIR}/opt/
fi

echo "- Entering chroot ..."
if [ "${1}" == "-a" ]; then
	sudo chroot ${ROOTFS_DIR} qemu-mipsel-static /bin/sh -c ". /etc/profile && /inchroot_install_opt_packages.sh"
else
	echo "After entering chroot environment, type the following to be able to execute commands:"
	echo ". /etc/profile"
	echo "then to install packages, execute: "
	echo "/inchroot_install_opt_packages.sh"
	sudo chroot ${ROOTFS_DIR} qemu-mipsel-static /bin/sh
fi

echo "- Umounting virtual filesystems in ${ROOTFS_DIR} ..."
for mountpoint_ in dev sys proc opt; do
	while mountpoint -q ${ROOTFS_DIR}/${mountpoint_}; do
		sudo umount ${ROOTFS_DIR}/${mountpoint_}
	done
done

echo "- Cleaning up files that was needed for chroot ... "
[ -f ${ROOTFS_DIR}/inchroot_install_opt_packages.sh ] && rm -f ${ROOTFS_DIR}/inchroot_install_opt_packages.sh
[ -f ${ROOTFS_DIR}/usr/bin/qemu-mipsel-static ] && rm ${ROOTFS_DIR}/usr/bin/qemu-mipsel-static
[ -f ${ROOTFS_DIR}/variables.sh ] && rm ${ROOTFS_DIR}/variables.sh
[ -f ${ROOTFS_DIR}/.ash_history ] && rm ${ROOTFS_DIR}/.ash_history

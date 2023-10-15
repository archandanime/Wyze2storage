#!/bin/bash
#
# Description: This script modifies extracted rootfs image to be later be compressed as squashfs image
#


. variables.sh


ROOT_PASSWD_HASHED="root:u1Wh/Ywl3ZETI:19637:0:99999:7:::"

echo -n " - Changing root password to 'root' ... "
if [[ ! "$( cat ${ROOTFS_DIR}/etc/shadow )" == "${ROOT_PASSWD_HASHED}" ]]; then
	chmod 755 ${ROOTFS_DIR}/etc/shadow
	echo -n "${ROOT_PASSWD_HASHED}" > ${ROOTFS_DIR}/etc/shadow
	chmod 400 ${ROOTFS_DIR}/etc/shadow
	echo "done"
else
	echo "already done"
fi

echo -n " - Adding some lines to /etc/init.d/rcS to mount aback partition at /opt and run dropbear at boot ... "
if ! cat ${ROOTFS_DIR}/etc/init.d/rcS | grep -q "##### w2s section #####"; then
	echo "
##### w2s section #####

if ! mountpoint -q /opt; then # Mount aback at /opt if it has not been mounted
	mount -t squashfs /dev/mtdblock5 /opt
	[ -f /opt/etc/init.d/S51dropbear ] && /opt/etc/init.d/S51dropbear start
	[ -f /configs/w2s_custom.sh ] && /configs/w2s_custom.sh
fi
" >> ${ROOTFS_DIR}/etc/init.d/rcS
	echo "done"
else
	echo "already done"
fi


echo -n " - Setting hostname ... "
if [ ! "$(cat ${ROOTFS_DIR}/etc/hostname)" == "{HOSTNAME}" ]; then
	echo "${HOSTNAME}" > ${ROOTFS_DIR}/etc/hostname
	echo "done"
else
	echo "already done"
fi


echo -n " - Injecting PATH and variables to /etc/profile ... "
if ! cat ${ROOTFS_DIR}/etc/profile | grep -q "export PATH=\$PATH:/opt/bin:/opt/sbin"; then
	sed -i '/\export\ PATH=\/system\/bin:$PATH/a\export\ PATH=$PATH:\/opt\/bin:\/opt\/sbin' ${ROOTFS_DIR}/etc/profile
	echo "done"
else
	echo "already done"
fi

echo -n " - Injecting resize command to /etc/profile ... "
if ! cat ${ROOTFS_DIR}/etc/profile | grep -q "/bin/busybox resize"; then
	echo "/bin/busybox resize" >> ${ROOTFS_DIR}/etc/ptofile
	echo "done"
else
	echo "already done"
fi

echo -n " - Injecting TERMINFO and variables to /etc/profile ... "
if ! cat ${ROOTFS_DIR}/etc/profile | grep -q "export TERMINFO=/opt/share/terminfo"; then
	sed -i '/\export\ PATH=$PATH:\/opt\/bin:\/opt\/sbin/a\export\ TERMINFO=\/opt\/share\/terminfo' ${ROOTFS_DIR}/etc/profile
	echo "done"
else
	echo "already done"
fi

echo -n " - Injecting custom rootfs app.ver ... "
if [[ ! "$CUSTOM_ROOTFS_APPVER" == "" ]] && ! cat ${ROOTFS_DIR}/usr/app.ver | grep -q "${CUSTOM_ROOTFS_APPVER}" ; then
	echo -e "[VER]\nappver=${CUSTOM_ROOTFS_APPVER}" > ${ROOTFS_DIR}/usr/app.ver
	echo "done"
else
	echo "already done"
fi

echo -n " - Creating link /usr/libexec -> /opt/libexec for SFTP ... "
if [ ! -L ${ROOTFS_DIR}/usr/libexec ]; then
	ln -s /opt/libexec ${ROOTFS_DIR}/usr/libexec
	echo "done"
else
	echo "already done"
fi




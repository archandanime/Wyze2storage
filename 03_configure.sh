#!/bin/bash
#
# Description: This script modifies extracted rootfs image to be later be compressed as squashfs image
#


. variables.sh


ROOT_PASSWD_HASHED="root:u1Wh/Ywl3ZETI:19637:0:99999:7:::"

echo -n "- Changing root password to 'root'... "
if [[ ! "$( cat ${ROOTFS_DIR}/etc/shadow )" == "${ROOT_PASSWD_HASHED}" ]]; then
	chmod 755 ${ROOTFS_DIR}/etc/shadow
	echo -n "${ROOT_PASSWD_HASHED}" > ${ROOTFS_DIR}/etc/shadow
	chmod 400 ${ROOTFS_DIR}/etc/shadow
	echo "done"
else
	echo "already done"
fi


echo -n "- Adding some lines to /etc/init.d/rcS to mount aback partition at /opt and run dropbear at boot... "
if ! cat ${ROOTFS_DIR}/etc/init.d/rcS | grep -q "##### w2s section #####"; then
	echo "
##### w2s section #####

DROPBEAR_W2S_PIDFILE=/tmp/dropbear_w2s.pid
DROPBEAR_W2S_PORT=1022
/usr/bin/dropbear -p \$DROPBEAR_W2S_PORT -P \$DROPBEAR_W2S_PIDFILE -b /etc/dropbear.banner -s -g

[ -f /configs/w2s_custom_script.sh ] && /bin/sh /configs/w2s_custom_script.sh
if ! mountpoint -q /opt ; then
	mount -t squashfs /dev/mtdblock5 /opt
fi
" >> ${ROOTFS_DIR}/etc/init.d/rcS
	echo "done"
else
	echo "already done"
fi


echo -n "- Linking /etc/dropbear to /git/wyze2storage/resources..."
if [ ! -L /etc/dropbear ]; then
	ln -sf /configs/dropbear ${ROOTFS_DIR}/etc/dropbear
	echo "done"
else
	echo "already done"
fi

echo -n "- Copy dropbear binary to /usr/bin/... "
if [ ! -f ${ROOTFS_DIR}/usr/bin/dropbear ]; then
	cp resources/dropbear ${ROOTFS_DIR}/usr/bin/ || { echo "Dropbear binary does not exist" ; exit 1 ; }
	chmod +x ${ROOTFS_DIR}/usr/bin/dropbear
	echo "done"
else
	echo "already done"	
fi


echo -n "- Creating dropbear banner file... "
if [ ! -f ${ROOTFS_DIR}/etc/dropbear.banner ]; then
	figlet "w2s" > ${ROOTFS_DIR}/etc/dropbear.banner
	echo "done"
else
	echo "already done"
fi


echo -n "- Setting hostname... "
CURRENT_HOSTNAME=`cat ${ROOTFS_DIR}/etc/hostname`
if [ ! "${CURRENT_HOSTNAME}" == "{HOSTNAME}" ]; then
	echo "${HOSTNAME}" > ${ROOTFS_DIR}/etc/hostname
	echo "done"
else
	echo "already done"
fi


echo -n "- Injecting PATH and variables to /etc/profile... "
if ! cat ${ROOTFS_DIR}/etc/profile | grep -q "export PATH=\$PATH:/opt/bin:/opt/sbin"; then
	sed -i '/\export\ PATH=\/system\/bin:$PATH/a\export\ PATH=$PATH:\/opt\/bin:\/opt\/sbin' ${ROOTFS_DIR}/etc/profile
	echo "done"
else
	echo "already done"
fi


echo -n "- Injecting TERMINFO and variables to /etc/profile... "
if ! cat ${ROOTFS_DIR}/etc/profile | grep -q "export TERMINFO=/opt/share/terminfo"; then
	sed -i '/\export\ PATH=$PATH:\/opt\/bin:\/opt\/sbin/a\export\ TERMINFO=\/opt\/share\/terminfo' ${ROOTFS_DIR}/etc/profile
	echo "done"
else
	echo "already done"
fi

echo -n "- Injecting custom rootfs app.ver... "
if [[ ! "$CUSTOM_ROOTFS_APPVER" == "" ]] && ! cat ${ROOTFS_DIR}/usr/app.ver | grep -q "${CUSTOM_ROOTFS_APPVER}" ; then
	echo -e "[VER]\nappver=${CUSTOM_ROOTFS_APPVER}" > ${ROOTFS_DIR}/usr/app.ver
	echo "done"
else
	echo "already done"
fi

echo -n "- Injecting custom app app.ver... "
if [[ ! "$CUSTOM_APP_APPVER" == "" ]] && ! cat ${ROOTFS_DIR}/system/bin/app.ver | grep -q "${CUSTOM_APP_APPVER}" ; then
	echo -e "[VER]\nappver=${CUSTOM_APP_APPVER}" > ${ROOTFS_DIR}/system/bin/app.ver
	echo "done"
else
	echo "already done"
fi

echo -n "- Creating link /usr/libexec -> /opt/libexec for SFTP... "
if [ ! -L ${ROOTFS_DIR}/usr/libexec ]; then
	ln -s /opt/libexec ${ROOTFS_DIR}/usr/libexec
	echo "done"
else
	echo "already done"
fi

echo -n "- Changing permissions... "
sudo chown 1000:1000 -R ${ROOTFS_DIR}/opt/ && echo "done"


#!/bin/bash
#
# Description: This script modifies files in /opt directory inside rootfs image, will later be compressed as squashfs
# image to be mounted at /opt
#

. variables.sh



echo " - Creating symlinks in /opt/etc"
for etc_file in  passwd group shells shadow gshadow; do
	if [ -f ${ROOTFS_DIR}/etc/${etc_file} ]; then
		if [ ! -L ${ABACK_DIR}/etc/$etc_file ]; then
			echo "  /opt/etc/${etc_file} -> /etc/${etc_file} ... done"
			ln -sf /etc/$etc_file ${ABACK_DIR}/etc/$etc_file
		else
			echo " /opt/etc/${etc_file} -> /etc/${etc_file} ... already done"
		fi
	fi
done

if [ -f ${ABACK_DIR}/etc/profile ]; then
	rm ${ABACK_DIR}/etc/profile
	ln -sf /etc/profile ${ABACK_DIR}/etc/profile
fi

echo -n " - Redirecting drobear key dicretory to /configs/dropbear ..."
if [ -d ${ABACK_DIR}/etc/dropbear/ ]; then
	if [[ "${KEEP_DROPBEAR_KEYS}" == "yes" ]]; then
		mv ${ABACK_DIR}/etc/dropbear/ output/
		echo "${SSH_PUB_KEY}" > output/dropbear/authorized_keys
		echo "done"
	else
		echo -n "user does not want to keep, deleting instead ... "
		rm -r ${ABACK_DIR}/etc/dropbear/ && echo "done"
	fi
	ln -sf /configs/dropbear/ ${ABACK_DIR}/etc/
else
	echo "already done"
fi


echo -n " - Changing dropbear PID path ... "
if [ -f ${ABACK_DIR}/etc/init.d/S51dropbear ] && ! cat ${ABACK_DIR}/etc/init.d/S51dropbear | grep -q "PIDFILE=\"/tmp/dropbear.pid\""; then
	sed -i 's~PIDFILE=\"/opt/var/run/dropbear.pid\"~PIDFILE=\"/tmp/dropbear.pid\"~g' ${ABACK_DIR}/etc/init.d/S51dropbear
	echo "done"
else
	echo "already done"
fi


echo -n  " - Disallowing dropbear root login ... "
if ! cat ${ABACK_DIR}/etc/init.d/S51dropbear | grep -q "\$DROPBEAR -p \$PORT -P \$PIDFILE -g"; then
	sed -i 's/\$DROPBEAR\ -p\ \$PORT\ -P\ \$PIDFILE/\$DROPBEAR\ -p\ \$PORT\ -P\ \$PIDFILE\ -g/g' ${ABACK_DIR}/etc/init.d/S51dropbear
	echo "done"
else
	echo "already done"
fi

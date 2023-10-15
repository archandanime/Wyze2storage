#!/bin/sh
#
# Description: This script installs Entware packages to /opt without extra configurations, must be run inside chroot
#


. /variables.sh

ARCH=mipselsf-k3.4
URL=http://bin.entware.net/${ARCH}/installer


chroot_msg() {
	echo "[chroot] ${1} ..."
}

msg() {
	echo "- ${1} ..."
}

submsg() {
	echo " + ${1} ..."
}

opt_prepare() {
	chroot_msg "Preparing"

	echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /tmp/resolv.conf

	msg "Creating directories"
	for dir in bin etc lib/opkg tmp var/lock; do
		submsg "/opt/${dir}"
		mkdir -p  /opt/${dir}
	done

	msg "Downloading and configuring opkg"

	submsg "Downloading"
	wget -q $URL/opkg -O /opt/bin/opkg

	submsg "Chmoding opkg binary"
	chmod 755 /opt/bin/opkg

	submsg "Updating opkg conf"
	wget $URL/opkg.conf -O /opt/etc/opkg.conf

	submsg "Updating opkg database"
	/opt/bin/opkg update

}


opt_download() {
	chroot_msg "Downloading packages"

	msg "Downloading package"
	for package in $NEEDED_PACKAGES; do
		submsg "Package: $package"
		/opt/bin/opkg install $package
	done
}


opt_cleanup() {
	msg "Removing opkg files and directories"

	for opkg_res in /opt/bin/opkg /opt/etc/opkg.conf /opt/lib/opkg/ /opt/var/lock/ /opt/var/opkg-lists/; do
		submsg "Removing ${opkg_res}"
		rm -r ${opkg_res}
	done

	msg "Removing /tmp/resolv.conf"
	rm /tmp/resolv.conf

	echo "Chmoding /opt to be writable by user 1000"
	chown 1000:1000 -R /opt
}


opt_prepare
echo
opt_download
echo
opt_cleanup


#!/bin/sh

mkdir /configs/
mount -t jffs2 /dev/mtdblock6 /configs

source_dropbear_dir="/sdcard/wcv3_flash-helper/restore/dropbear/"
dest_dropbear_dir="/configs/dropbear/"

if [ -d $source_dropbear_dir ]; then
	echo "$source_dropbear_dir is found"
	echo
	if [ -d $dest_dropbear_dir ]; then
		echo "Old $dest_dropbear_dir exists, deleting"
		rm -r $dest_dropbear_dir
	fi
	echo "Copying $source_dropbear_dir to $dest_dropbear_dir"
	cp -r $source_dropbear_dir $dest_dropbear_dir
	chmod 600 $dest_dropbear_dir/*
else
	echo "$source_dropbear_dir is missing"
fi


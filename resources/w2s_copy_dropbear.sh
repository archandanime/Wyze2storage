#!/bin/sh

mkdir /configs/
mount -t jffs2 /dev/mtdblock6 /configs

old_dropbear_dir="/configs/dropbear/"
new_dropbear_dir="/sdcard/wcv3_flash-helper/restore/dropbear/"

if [[ -d $new_dropbear_dir ]]; then
	echo "$new_dropbear_dir is found"
	echo 
	if [[ -d $old_dropbear_dir ]]; then
		echo "Old $old_dropbear_dir exists, deleting"
		rm -r /configs/dropbear/
	fi
	echo "Copying $new_dropbear_dir to $old_dropbear_dir"
	cp -r $new_dropbear_dir $old_dropbear_dir
	chmod 600 $old_dropbear_dir/*
else
	echo "$new_dropbear_dir is missing"
fi

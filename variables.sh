#!/bin/bash

## USER CUSTOM VARIABLES
# New hostname for camera, will be written into /etc/hostname in rootfs
HOSTNAME="WyzeCamv3"

# Entware packages that you want to install
NEEDED_PACKAGES="dropbear openssh-sftp-server"

# This SSH Public key will be used for dropbear authentication
SSH_PUB_KEY=""

# Dropbear automatically generates a set of secret keys on fresh installation
# Disable this if you already have secret keys to push into the camera
KEEP_DROPBEAR_KEYS="no"

# Set a fake app.ver inside rootfs image
CUSTOM_ROOTFS_APPVER="9.36.3.19"

# Set a fake app.ver inside app image
CUSTOM_APP_APPVER="9.36.9.139"



# OTHER VARIABLES
UPGRADE_FILE="input/demo_wcv3.bin"

ROOTFS_IMG="rootfs.sqsh"
ROOTFS_DIR="rootfs"

APP_IMG="app.sqsh"
APP_DIR="app"

ABACK_DIR="aback"

OUT_KERNEL_IMG="output/mtdblock1_kernel_w2s"
OUT_ROOTFS_IMG="output/mtdblock2_rootfs_w2s"
OUT_APP_IMG="output/mtdblock3_app_w2s"
OUT_ABACK_IMG="output/mtdblock5_aback_w2s"




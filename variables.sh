#!/bin/bash

## USER CUSTOM VARIABLES
# New hostname for camera, will be written into /etc/hostname in rootfs
HOSTNAME="WyzeCamv3"

# Entware packages that you want to install
#NEEDED_PACKAGES="dropbear openssh-sftp-server nano-full rsync htop"
NEEDED_PACKAGES="ffmpeg"

# This SSH Public key will be used for dropbear authentication
SSH_PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfWp/Q39DU05CsVNLvEy/lNeIkjnQ5kpLgnQBzvXl4XX/ss/7uDa1TMF6PMk1mGTHmuPHL6jHmfw5dIq9cADuvzEdkTZLy/O+vz+Gs5unU8zrz6W4kn3li0p2K+LfED7z9F7Kt/mnR5paSZWuelr936FvIfk6nqpJEA0cAniMlGGm81kdNNMws7UPZEGxQehF/nrtiK5/S/lCD5QA0q37bqXM9O4IE6gGVMAySCJtxylpHQ8ICklbGiWtEMS+UlneBfPg7rGTNp9EAHKjTRKNHul3E0zWyvDNEa0Ih8qTNLzxmxAmWwPimIAQd2NJjhcWuEPvV3MqFn1HQNsZ3vdleXOnz26908HuIsdZ8MbfZQrDhlAmzOnRikjYujz01AAqGxQp8SV9R6TAaP6LS/I3V+ZiWFjCJrewpNs0OWckd0Y7MXjrBZK87UB6GQ9QQKi3qQIL/9sqs7r0HyeLEtLYudttpclPhLVYT8Vz0MvgBmuv9S3g3ZKUtyXqNTTnCjGk= squid@arch"

# Dropbear automatically generates a set of secret keys on fresh installation
# Disable this if you already have secret keys to push into the camera
KEEP_DROPBEAR_KEYS="no"

# Set a fake app.ver inside rootfs image
#CUSTOM_ROOTFS_APPVER="9.36.3.19"

# Set a fake app.ver inside app image
#CUSTOM_APP_APPVER="9.36.9.139"

# OTHER VARIABLES
UPGRADE_FILE="input/demo_wcv3.bin"

ROOTFS_IMG="rootfs.sqsh"
APP_IMG="app.sqsh"

ROOTFS_DIR="rootfs"

OUT_KERNEL_IMG="output/mtdblock1_kernel_w2s.bin"
OUT_ROOTFS_IMG="output/mtdblock2_rootfs_w2s.bin"





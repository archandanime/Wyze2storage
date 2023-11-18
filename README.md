**Abandoned !**
Powered by Entware !


## Features
- SSH and SFTP
- rsync
- NFS mount
- nano-full and htop
- cron
- Works with lastest firmware
- Works with exFAT SD Card
- No SD Card is needed to be functional
- Wiping SD Card has no impact!
- Doesn't cause conflict with wz_mini_hacks

## How to install
1. Download installer from Releases page and place it in your SD Card.
2. Generate dropbear key for the Camera with the following command and copy to `w2s_install/dropbear/` directory on your SD Card:
```
dropbearkey -t rsa -f dropbear_rsa_host_key
```
Keep this file safe!

3. Copy your dropbear to `w2s_install/dropbear/` on your SD Card and rename it to `authorized_keys`.
4. Insert your SD Card into your Camera and power on.
5. Wait for the installation to finish until you can ping the Camera.

After that you can safely format the Camera to exFAT if you want

------------------
## How to Build

**Build `rootfs.sqsh` and `aback.sqsh`:**

Packages that you need in order to build:
- squashfs-tools
- binwalk 
- qemu-user-static
- qemu-user-static-binfmt

You also need `systemd-binfmt` running :
```bash
> sudo systemctl start systemd-binfmt.service
> sudo systemctl status systemd-binfmt.service
```
- Then building is just as simple as:
```
./run-all.sh
```

After the build script is finished, you can use the installer to flash output files from `output/` directory.

**Build installer boot image `factory_t31_ZMC6tiIDQN`**:
- Install docker and get it running
- Git clone: https://github.com/mnakada/atomcam_tools
- Replace `initramfs_skeletion/` directory with one from my repo
- Build the boot image with these commands:
```
sudo ln -s . /src
sudo make build

sudo docker-compose exec builder bash
root@e478b7b013d4:/atomtools/build/buildroot-2016.02# ln -s /atomtools/ /openmiko
root@e478b7b013d4:/atomtools/build/buildroot-2016.02# cp /atomtools/build/buildroot-2016.02/output/images/uImage.lzma /src/factory_t31_ZMC6tiIDQN
```

If a command fails, try running it again a few times or try the other commands. If something breaks, delete then docker container and start a new one:
```
sudo docker stop atomcam_tools-builder-1 && sudo docker remove atomcam_tools-builder-1
```


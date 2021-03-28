#!/bin/bash

set -x

echo -e "g\nn\n\n\n+200M\nt\n1\nn\n\n\n\nw\n" | fdisk archlinux.img
read -r -d '\n' ARCHBOOT ARCHROOT <<<$(sudo kpartx -av archlinux.img | grep -oh "\w*loop\w*")
mkfs.vfat $ARCHBOOT
mkfs.ext4 $ARCHROOT
mkdir root
mount $ARCHROOT root
mkdir root/boot
mount $ARCHBOOT root/boot
bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C root
blkid
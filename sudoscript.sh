#!/bin/bash

set -x

echo -e "g\nn\n\n\n+200M\nt\n1\nn\n\n\n\nw\n" | fdisk archlinux.img
read -r -d '\n' ARCHBOOT ARCHROOT <<<$(kpartx -av archlinux.img | grep -oh "\w*loop\w*")
mkfs.vfat /dev/mapper/$ARCHBOOT
mkfs.ext4 /dev/mapper/$ARCHROOT
mkdir root
mount /dev/mapper/$ARCHROOT root
mkdir root/boot
mount /dev/mapper/$ARCHBOOT root/boot
bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C root
blkid
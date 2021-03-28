#!/bin/bash

set -x

echo -e "g\nn\n\n\n+200M\nt\n1\nn\n\n\n\nw\n" | fdisk archlinux.img
read -r -d '\n' ARCHBOOT ARCHROOT <<<"$(kpartx -av archlinux.img | grep -oh "\w*loop\w*")"
read -r ARCHBOOT ARCHROOT <<<"/dev/mapper/${ARCHBOOT} /dev/mapper/${ARCHROOT}"
mkfs.vfat $ARCHBOOT
mkfs.ext4 $ARCHROOT
mkdir root
mount $ARCHROOT root
mkdir root/boot
mount $ARCHBOOT root/boot
bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C root
BOOTUUID=$(blkid $ARCHBOOT -o value -s UUID)
ROOTUUID=$(blkid $ARCHROOT -o value -s UUID)
echo "BOOTUUID=$BOOTUUID"
echo "ROOTUUID=$ROOTUUID"
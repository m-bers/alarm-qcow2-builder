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
echo "/dev/disk/by-uuid/$ROOTUUID / ext4 defaults 0 0\n/dev/disk/by-uuid/$BOOTUUID /boot vfat defaults 0 0" >> root/etc/fstab
echo "Image root=UUID=$ROOTUUID rw initrd=\initramfs-linux.img" >> root/boot/startup.nsh
umount root/boot
umount root
kpartx -d archlinux.img
sync
exit
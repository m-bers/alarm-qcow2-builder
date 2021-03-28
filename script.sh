#!/bin/bash

set -x

sudo apt update
sudo apt -y install qemu-system-arm qemu-efi-aarch64 qemu-utils fdisk kpartx bsdtar wget
mkdir alarm
cd alarm
wget http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
qemu-img create archlinux.img 32GB
echo -e "g\nn\n\n\n+200M\nt\n1\nn\n\n\nw\n" | fdisk $DISK
sudo kpartx -av archlinux.img
ls /dev/mapper
#!/bin/bash

set -x

sudo apt update
sudo apt -y install qemu-system-arm qemu-efi-aarch64 qemu-utils fdisk kpartx libarchive-tools wget
mkdir alarm
cd alarm
wget http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
qemu-img create archlinux.img 32G
echo -e "g\nn\n\n\n+200M\nt\n1\nn\n\n\n\nw\n" | fdisk archlinux.img
read -r -d '\n' ARCHBOOT ARCHROOT <<<$(sudo kpartx -av archlinux.img | grep -oh "\w*loop\w*")
echo "ARCHBOOT=$ARCHBOOT"
echo "ARCHROOT=$ARCHROOT"
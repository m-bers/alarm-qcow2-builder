#!/bin/bash

set -x

sudo apt update
sudo apt -y install qemu-system-arm qemu-efi-aarch64 qemu-utils fdisk kpartx libarchive-tools wget
mkdir alarm
cd alarm
wget http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
qemu-img create archlinux.img 32G
sudo $GITHUB_WORKSPACE/sudoscript.sh
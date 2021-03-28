#!/bin/bash

set -x

sudo apt update
sudo apt -y install qemu-system-arm qemu-efi-aarch64 qemu-utils fdisk kpartx libarchive-tools wget bzip2
mkdir alarm
cd alarm
wget -qq http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
qemu-img create archlinux.img 32G
sudo $GITHUB_WORKSPACE/sudoscript.sh
qemu-img convert -O qcow2 archlinux.img archlinux.qcow2
wget -qq https://github.com/qemu/qemu/raw/master/pc-bios/edk2-aarch64-code.fd.bz2
bzip2 -d edk2-aarch64-code.fd.bz2
dd if=/dev/zero conv=sync bs=1M count=64 of=ovmf_vars.fd
qemu-system-aarch64 -L ~/bin/qemu/share/qemu \
	-smp 8 \
	-machine virt,highmem=off \
	-cpu cortex-a72 -m 4096 \
	-drive file=edk2-aarch64-code.fd,if=pflash,format=raw,readonly=on \
	-drive file=ovmf_vars.fd,if=pflash,format=raw \
	-drive "if=virtio,media=disk,id=drive2,file=archlinux.qcow2,cache=writethrough,format=qcow2" \
	-nic user,model=virtio-net-pci,hostfwd=tcp::50022-:22 -nographic \
	-device virtio-rng-device -device virtio-balloon-device -device virtio-keyboard-device \
	-device virtio-mouse-device -device virtio-serial-device -device virtio-tablet-device \
	-object cryptodev-backend-builtin,id=cryptodev0 \
	-device virtio-crypto-pci,id=crypto0,cryptodev=cryptodev0
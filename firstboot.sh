#!/bin/bash

https://github.com/qemu/qemu/raw/master/pc-bios/edk2-aarch64-code.fd.bz2
efibootmgr --disk /dev/vda --part 1 --create --label "Arch Linux ARM" --loader /Image --unicode 'root=UUID=aad256f7-ee8f-4a67-8e38-cf23987d12d7 rw initrd=\initramfs-linux.img' --verbose
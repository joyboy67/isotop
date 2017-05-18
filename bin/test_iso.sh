#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : test openbsd curstom iso
# Depends : qemu

if [ ! -f sio2.img ]; then
    qemu-img create -f qcow2 sio2.img 20G
    qemu-system-x86_64 -cdrom CustomOBSD.iso -hda sio2.img -boot d -m 1G,slots=3,maxmem=4G
else
    qemu-system-x86_64 -hda sio2.img -m 1G,slots=3,maxmem=4G

fi

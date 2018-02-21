#!/bin/sh
# build openbsd custom iso
# require genisoimage

. ./obsdiso.conf

echo "---"
echo "* Rebuilding iso"


if [ -n "$(command -v mkisofs)" ]; then
    mkisofs -r -no-emul-boot -b ${V1}.${V2}/${ARCH}/cdbr -c boot.catalog -o ${CWD}/CustomOBSD.iso ${NAME}
else
    genisoimage -r -no-emul-boot -b ${V1}.${V2}/${ARCH}/cdbr -c boot.catalog -o ${CWD}/CustomOBSD.iso ${NAME} 
fi

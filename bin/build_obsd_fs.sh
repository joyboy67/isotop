#!/bin/sh
# build openbsd custom fs
# only works on openbsd for now

# see : 
# https://github.com/openbsd/src/blob/master/distrib/amd64/iso/Makefile#L9
# http://undeadly.org/cgi?action=article&sid=20140225072408

. ./obsdiso.conf

SIZE=$1

if [ "$(uname)" = "OpenBSD" ]; then
    echo "---"
    echo "* Rebuilding fs"

    # temp image
    TMPIMG="tmpimage.$$"
    # sizes ...
    BLOCKSIZE=512
    #BUF=$(expr 1024 \* 1024 \* 10) # 10M
    #FSSIZE=$(expr $(du -s ${NAME} |awk '{print $1}') + $BUF)
    FSSIZE=$(expr $SIZE / $BLOCKSIZE ) 

    # mount points
    VND="vnd0"
    VND_DEV="/dev/${VND}a"
    VND_RDEV="/dev/r${VND}a"
    MOUNT_POINT="${NAME}-fstmp"

    mkdir -p ${MOUNT_POINT}

    # this create a disk and format it
    echo "preparing disk image"
    dd if=/dev/zero of=${TMPIMG} bs=${BLOCKSIZE} count=${FSSIZE}
    vnconfig ${VND} ${TMPIMG}
    echo "writing mbr"
    fdisk -yi ${VND}
    echo "creating slice"
    echo "a\n\n\n\n\nw\nq\n" | disklabel -E ${VND} 
    echo "running newfs"
    newfs ${VND_RDEV}
    mount ${VND_DEV} ${MOUNT_POINT}

    echo "Copy image files"
    cp -r ${NAME}/* ${MOUNT_POINT}
    installboot -r ${MOUNT_POINT} ${VND} /usr/mdec/biosboot /usr/mdec/boot

	umount ${MOUNT_POINT}
	vnconfig -u ${VND}
    rm -r ${MOUNT_POINT}

	mv ${TMPIMG} CustomOBSD.fs


else
    echo "This script only works on OpenBSD"
fi

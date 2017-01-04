#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : Download and extract openbsd iso.

. ./obsdiso.conf


echo "---"
echo "* Downloading OpenBSD iso"


if [ "$(uname)" = "OpenBSD" ]; then
    DLER="ftp -C"
else
    if [ -n "$(command -v curl)" ]; then
        DLER="curl -O -C -"
    elif [ -n "$(command -v wget)" ]; then
        DLER="wget --continue"
    fi
fi

if [ ! -e ${NAME}.iso ]; then
    $DLER "${MIRROR}/${VERSION}/${ARCH}/install${V1}${V2}.iso"
    echo "---"
    echo "* Checking iso"
    # check if iso fits SHA256
    $DLER "${MIRROR}/${VERSION}/${ARCH}/SHA256"
    if [ "$(uname)" = "OpenBSD" ]; then
        sha256 -C SHA256 install${V1}${V2}.iso
    else
        GOODSHA="$(grep install60.iso SHA256 |cut -d' ' -f4)"
        CURSHA="$(sha256sum install${V1}${V2}.iso |cut -d' ' -f1)"
        test $GOODSHA = $CURSHA
    fi

    if [ $? -ne 0 ]; then
        echo "There is a problem with the downloaded iso. Run the script again and try do delete the previous downloaded file."
        exit 1
    else
        mv install${V1}${V2}.iso ${NAME}.iso
    fi
fi

echo "---"
echo "* Extracting iso..."
mkdir -p loopdir
if [ "$(uname)" = "OpenBSD" ]; then
    vnconfig vnd0 ${NAME}.iso
    mount -t cd9660 /dev/vnd0c loopdir/
    cp -r loopdir/ ./${NAME}
    umount loopdir/
    vnconfig -u vnd0
else
    mkdir -p ./${NAME}
    mount -o loop ${NAME}.iso loopdir
    cp -r loopdir/* ./${NAME}
    umount loopdir/
fi
#chown -R root:wheel ./${NAME}/
#chmod -R +w ./${NAME}/
rm -r loopdir/

mkdir -p site/etc
touch site/install.site
chmod 755 site/install.site
touch site/etc/rc.firsttime
chmod 755 site/etc/rc.firsttime

echo "* Now edit the files in ${NAME}"

exit 0


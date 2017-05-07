#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : Create siteXX.tgz
# Depends : tar

. ./obsdiso.conf

if [ -d ./site ]; then
    echo "---"
    echo "* Create packages list to install"
    if [ -e ./site/etc/rc.firsttime ]; then
        echo "$PACKAGES" > ./site/etc/firsttime_packages
    fi

    echo "---"
    echo "* set installurl"
    echo "$MIRROR" > ./site/etc/installurl

    echo "---"
    echo "* Create siteXX.tgz"
    cd site
    tar cvzf ../site${V1}${V2}.tgz *

    cd ..
    echo "* Copy custom siteXX.tgz"
    cp site${V1}${V2}.tgz ${NAME}/${VERSION}/${ARCH}/site${V1}${V2}.tgz 
fi

exit 0


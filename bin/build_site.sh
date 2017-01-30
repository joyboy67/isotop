#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : Create siteXX.tgz
# Depends : tar

. ./obsdiso.conf

if [ -d ./site ]; then
    echo "---"
    echo "* Create siteXX.tgz"
    if [ -e ./site/etc/rc.firsttime ]; then
        echo "$PACKAGES" > ./site/etc/firsttime_packages
    fi

    cd site
    tar cvzf ../site${V1}${V2}.tgz *
    cd ..
    echo "* Copy custom siteXX.tgz"
    cp site${V1}${V2}.tgz ${NAME}/${VERSION}/${ARCH}/site${V1}${V2}.tgz 
fi

exit 0


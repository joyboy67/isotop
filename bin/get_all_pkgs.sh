#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : download all packages and theirs dependencies
# Depends : openbsd


. ./obsdiso.conf
OUTDIR=site/home/root/pkg_cache

get_deps() {
    DEPS=$(pkg_info -f $1 | grep '^@depend' | cut -f 3 -d :)
    echo $DEPS
}

dl_pkgs() {
    DEPS=$(get_deps $1)
    for d in $DEPS; do
        if [ ! -f $OUTDIR/$d.tgz ]; then
            ftp -C -o $OUTDIR/$d.tgz $PKG_PATH/$d.tgz
            dl_pkgs $d
        fi
    done
    p=$(pkg_info $1 | head -n1 | cut -d' ' -f 3)
    # test if url in description -> package not installed
	if [ -n "$(echo $p |grep $PKG_PATH)" ]; then
		ftp -C -o $OUTDIR/$(basename $p) $p
	else
		p=$(echo $p | cut -d':' -f2)
		ftp -C -o $OUTDIR/$p.tgz $PKG_PATH/$p.tgz
	fi

}

mkdir -p $OUTDIR


# quirks is needed
dl_pkgs "quirks"

for p in $PACKAGES; do
    echo ""
    echo "*** $p"
    dl_pkgs $p
done

exit 0

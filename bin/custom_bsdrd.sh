#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : create custom bsd.rd to have autoinstall locally
# http://mouedine.net/reinstall57/
# https://github.com/Mayeu/NYaifO
# https://www.openbsd.org/faq/faq5.html#Release
# https://man.openbsd.org/release

# Prérequis : 
##user mod -G wsrc exampleuser
# and eventually : 
#$ cd /usr
#$ cvs -qd anoncvs@anoncvs.example.org:/cvs checkout -rOPENBSD_6_2 -P src


. ./obsdiso.conf

CURDIR=$(pwd)

CUSTOM=./custom_bsdrd

echo "---"
echo "* Creating custom bsd.rd for autoinstall"

 
rm -r ${CUSTOM}/sources/*
mkdir -p ${CUSTOM}/{tgz,sources}

ftp -C -o ${CUSTOM}/tgz/src.tar.gz ${MIRROR}/${VERSION}/src.tar.gz
ftp -C -o ${CUSTOM}/tgz/sys.tar.gz ${MIRROR}/${VERSION}/sys.tar.gz
tar zxf ${CUSTOM}/tgz/src.tar.gz -C ${CUSTOM}/sources
tar zxf ${CUSTOM}/tgz/sys.tar.gz -C ${CUSTOM}/sources

echo 'COPY    ${CURDIR}/../../miniroot/auto_install.conf   auto_install.conf' >> ${CUSTOM}/sources/distrib/${ARCH}/common/list


echo "Compiling new bsd.rd"
cd ${CURDIR}/${CUSTOM}/sources/distrib/special
make clean
make obj
make
make install

cd ${CURDIR}/${CUSTOM}/sources/distrib/${ARCH}
make clean
make obj
make depend
make

 

 
Install crunchgen

Go to /usr/src/distrib/crunch. Run "make" and "make install".
Install distrib/special

Go to /usr/src/distrib/special. Run "make" and "make install".
Build bsd.rd

Go to /usr/src/distrib/i386/ramdisk_cd. Type "make". You'll find bsd.rd, cd??.iso and a few more friends in the directory with you.

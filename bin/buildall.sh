#!/bin/sh
F="isotop-0.2"
# download all packages in packages-amd64 and packages-i386 first

# amd64
sed -i 's/ARCH=.*$/ARCH=amd64/g' obsdiso.conf
rm site/home/root/pkg_cache/*

doas make iso
mv CustomOBSD.iso MEDIAS/$F-amd64-netinst.iso

doas make fsnetinst
mv CustomOBSD.fs MEDIAS/$F-amd64-netinst.fs

cp packages-amd64/* site/home/root/pkg_cache/

doas make iso
mv CustomOBSD.iso MEDIAS/$F-amd64-full.iso

doas make fs
mv CustomOBSD.fs MEDIAS/$F-amd64-full.fs

# i386
sed -i 's/ARCH=.*$/ARCH=i386/g' obsdiso.conf
rm site/home/root/pkg_cache/*

doas make iso
mv CustomOBSD.iso MEDIAS/$F-i386-netinst.iso

doas make fsnetinst
mv CustomOBSD.fs MEDIAS/$F-i386-netinst.fs

cp packages-i386/* site/home/root/pkg_cache/

doas make iso
mv CustomOBSD.iso MEDIAS/$F-i386-full.iso

doas make fs
mv CustomOBSD.fs MEDIAS/$F-i386-full.fs

cd MEDIAS
sha256 * > SHA256

#mktorrent -a udp://tracker.openbittorrent.com:80 \
	#	-a udp://tracker.opentrackr.org:1337 \
	#	-a udp://tracker.coppersurfer.tk:6969 \
	#	-a udp://tracker.publicbt.com:80 \
	#	-a http://opensharing.org:2710/announce  \
	#	-a udp://tracker.leechers-paradise.org:6969 \
	#	-a udp://zer0day.ch:1337 \
	#	$i; 

for i in *.fs; do 
	transmission-create $i
done
for i in *.iso; do 
	transmission-create $i
done

for i in *.torrent; do 
	transmission-show -m $i >> magnets
done


exit 0

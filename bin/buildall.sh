#!/bin/sh
F="isotop-0.2.1"
# download all packages in packages-amd64 and packages-i386 first

mkdir -p MEDIAS

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
sha256 *.iso > SHA256
sha256 *.fs >> SHA256

# compress

for i in *.fs; do
	echo "xz'ing $i"
	xz -v -T 0 -k -9 $i
done
for i in *.iso; do
	echo "xz'ing $i"
	xz -v -T 0 -k -9 $i
done


for i in *.xz; do 
	echo "torrent'ing $i"
	transmission-create \
	-t udp://tracker.opentrackr.org:1337 \
	-t udp://tracker.coppersurfer.tk:6969 \
	-t udp://tracker.publicbt.com:80 \
	-t http://opensharing.org:2710/announce  \
	-t udp://tracker.leechers-paradise.org:6969 \
	-t udp://zer0day.ch:1337 \
	$i
done

for i in *.torrent; do 
	transmission-show -m $i >> magnets
done


exit 0

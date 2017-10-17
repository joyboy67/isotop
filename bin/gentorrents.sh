#!/bin/sh
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




#!/bin/sh
# ffom : find fast openbsd mirror
# Auteur :      thuban <thuban@yeuxdelibad.net>
# Improved by vincentdelft
# licence :     MIT

# Description : cherche le miroir OpenBSD le plus rapide
# Depends : curl

if [ -z "$(whereis curl)" ]; then
	echo "You need curl to use ffom"
	exit 1
fi

t=$(mktemp)
MIRRORS="$(curl -s https://www.openbsd.org/ftp.html | grep -Eo "(https?|ftp)://.*/pub/OpenBSD/" |uniq)"

NB=$(echo $MIRRORS | wc -w | tr -d ' ')
COUNT=1

end() {
	clear 
	echo 'RESULTS: (firsts are better)'
	echo '- - - - - - - - - - - - - - '
	sort -g $t 
	rm $t
	ksh
}

trap end INT
echo "Hit ctrl-c to stop and see results"

for URL in $MIRRORS; do
	result=$(curl --silent --output /dev/null --max-time 5 --write-out "%{time_total}-%{time_pretransfer}" "$URL")
	time=$(echo ${result} | bc)
	echo "...tested $time $URL [${COUNT}/${NB}]" 
	echo "$time : $URL" >> $t
	COUNT=$(($COUNT + 1))
done 

end

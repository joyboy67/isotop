#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : télécharge fichier unbound anti-pub et domaines suspects

LOCALZONEURL="https://stephane-huc.net/share/BlockZones/lists/local-zone"
LOCALZONEURLSHA512="https://stephane-huc.net/share/BlockZones/lists/local-zone.sha512"

cd /tmp

echo "---"
echo "Installing last unbound file"
echo "---"
ftp -o /tmp/local-zone "$LOCALZONEURL"
ftp -o /tmp/local-zone.sha512 "$LOCALZONEURLSHA512"

echo "Check sha512 sum"
sha512 -C local-zone.sha512 local-zone
if [ $? -eq 0 ]; then
    mv /tmp/local-zone /var/unbound/etc/unbound_ad_servers
fi

exit 0


#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : send dmesg to dmesg@openbsd.org

case $LANG in
	fr_FR*)
		TXT_SUBJECT="Afin d'aider les développeurs d'OpenBSD, vous pouvez envoyer
des informations sur votre matériel.
Indiquez le nom du modèle de votre ordinateur
et ce qui fonctionne ou non (en anglais).
ex : Dell XPS M1330, SD card not working, everything else works."
		TXT_REALMAIL="Indiquez votre adresse mail."
		TXT_THX="Message envoyé. Merci d'avoir aidé les développeurs d'OpenBSD"
	;;
	*)
		TXT_SUBJECT="To help OpenBSD developpers, 
write you computer model and
what works or not (in english).
ex : Dell XPS M1330, SD card not working, everything else works."
		TXT_REALMAIL="What is you email address?"
		TXT_THX="Message send. Thanks for OpenBSD developpers"
	;;
esac

SUBJECT="$(zeniTK --entry --title "dmesg@openbsd.org" --text "$TXT_SUBJECT")"
if [ -n "$SUBJECT" ]; then
	REALMAIL="$(zeniTK --entry --title "dmesg@openbsd.org" --text "$TXT_REALMAIL")"
else
	exit
fi

if [ -n "$SUBJECT" -a -n "$REALMAIL" ]; then
	echo "Sending dmesg"
	(dmesg; sysctl hw.sensors) | mail -r "$REALMAIL" -s "$SUBJECT" dmesg@openbsd.org
	if [ $? -eq 0 ]; then
		zeniTK --info --title "dmesg@openbsd.org" --text "$TXT_THX"
	fi
fi


exit 0

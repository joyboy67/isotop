#!/bin/sh
# Auteur :      prx <prx@ybad.name>
# licence :     MIT

# Description : send dmesg to dmesg@openbsd.org
# Depends : dmenu

case $LANG in
	fr_FR*)
		TXT_SUBJECT="Afin d'aider les développeurs d'OpenBSD, vous pouvez envoyer
des informations sur votre matériel.
Indiquez le nom du modèle de votre ordinateur
et ce qui fonctionne ou non (en anglais).
ex : Dell XPS M1330, SD card not working, everything else works."
		TXT_REALMAIL="Indiquez votre adresse mail."
		TXT_THX="Message envoyé. Merci d'avoir aidé les développeurs d'OpenBSD"
		TXT_ERR="Erreur à l'envoi du dmesg..."
	;;
	*)
		TXT_SUBJECT="To help OpenBSD developpers, 
write you computer model and
what works or not (in english).
ex : Dell XPS M1330, SD card not working, everything else works."
		TXT_REALMAIL="What is you email address?"
		TXT_THX="Message send. Thanks for OpenBSD developpers"
		TXT_ERR="Error while sending dmesg"
	;;
esac

test -s $HOME/.dmenurc && . $HOME/.dmenurc
dmenucmd='dmenu -l ${l} 
-fn "${fn}" 
-nb "${nb}" 
-nf "${nf}" 
-sb "${sb}" 
-sf "${sf}"'

SUBJECT="$(echo "$TXT_SUBJECT" | eval $dmenucmd )"
if [ -n "$SUBJECT" ]; then
	REALMAIL="$(echo "$TXT_REALMAIL" | eval $dmenucmd )"
else
	exit
fi

if [ -n "$SUBJECT" -a -n "$REALMAIL" ]; then
	echo "Sending dmesg"
	(dmesg; sysctl hw.sensors) | mail -r "$REALMAIL" -s "$SUBJECT" dmesg@openbsd.org
	if [ $? -eq 0 ]; then
		notify-send "$TXT_THX"
	else
		notify-send "$TXT_ERR"
	fi
fi


exit 0

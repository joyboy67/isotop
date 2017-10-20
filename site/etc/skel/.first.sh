#!/bin/sh

# first session launch configuration
. ~/.profile

# add xdg-user-dirs
export XDG_CONFIG_DIRS=$HOME/.config/user-dirs.dirs
xdg-user-dirs-update


# TRADS
lang=$(cat /etc/kbdtype)

case lang in 
	"fr")
		cp -r /opt/isotop/trads/fr/.mozilla ~
		cp -r /opt/isotop/trads/fr/.thunderbird ~
LC_CTYPE="fr_FR.UTF-8"
LC_MESSAGES="fr_FR.UTF-8"
LC_ALL='fr_FR.UTF-8'
LANG='fr_FR.UTF-8'
export LC_CTYPE LC_MESSAGES LC_ALL LANG
	;;
esac


# change mpd configuration
#sed -i -e "s;CHANGEME;$(xdg-user-dir MUSIC);" ~/.mpdconf

rm $0
exit 0


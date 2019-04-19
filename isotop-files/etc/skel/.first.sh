#!/bin/sh

# first session launch configuration
. ~/.profile

# TRADS
lang=$(cat /etc/kbdtype)

case $lang in 
	"fr")
		cp -r /usr/local/share/isotop/data/trads/fr/.thunderbird ~
		echo 'LC_CTYPE="fr_FR.UTF-8"' >> ~/.profile
		echo 'LC_MESSAGES="fr_FR.UTF-8"' >> ~/.profile
		echo 'LC_COLLATE="fr_FR.UTF-8"' >> ~/.profile
		echo 'LC_ALL="fr_FR.UTF-8"' >> ~/.profile
		echo 'LANG="fr_FR.UTF-8"' >> ~/.profile
		echo 'export LC_CTYPE LC_MESSAGES LC_COLLATE LC_ALL LANG' >> ~/.profile
		MOUNTPOINTNAME="Disques"
	;;
	*)
		echo "No translation to do, default to en_EN"
		echo 'LC_CTYPE="en_EN.UTF-8"' >> ~/.profile
		echo 'LC_MESSAGES="en_EN.UTF-8"' >> ~/.profile
		echo 'LC_COLLATE="en_EN.UTF-8"' >> ~/.profile
		echo 'LC_ALL="en_EN.UTF-8"' >> ~/.profile
		echo 'LANG="en_EN.UTF-8"' >> ~/.profile
		echo 'export LC_CTYPE LC_MESSAGES LC_COLLATE LC_ALL LANG' >> ~/.profile
		MOUNTPOINTNAME="Disks"
	;;
esac

. ~/.profile
# add xdg-user-dirs
export XDG_CONFIG_DIRS=$HOME/.config/user-dirs.dirs
xdg-user-dirs-update

# link to /vol for automounting
ln -s /vol/ ~/${MOUNTPOINTNAME}

rm $0
exit 0


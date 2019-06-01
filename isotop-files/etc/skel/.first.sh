#!/bin/sh

# first session launch configuration
. ${HOME}/.profile

# TRADS
lang=$(cat /etc/kbdtype)

case $lang in 
	"fr")
		echo 'LC_CTYPE="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'LC_MESSAGES="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'LC_COLLATE="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'LC_ALL="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'LANG="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'export LC_CTYPE LC_MESSAGES LC_COLLATE LC_ALL LANG' >> ${HOME}/.profile
		# thunderbird
		cp -r /usr/local/share/isotop/data/trads/fr/.thunderbird ${HOME}/
		# hotplug
		MOUNTPOINTNAME="Disques"
		# cwm
		sed -i -e "s;___CWMMINWIN;Minimiser une fenêtre;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMMAXMIN;Maximiser une fenêtre;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMCLOSEWIN;Fermer une fenêtre;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMSHOWDESKTOP;Voir le bureau;" ${HOME}/.cwmrc
	;;
	*)
		echo 'LC_CTYPE="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'LC_MESSAGES="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'LC_COLLATE="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'LC_ALL="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'LANG="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'export LC_CTYPE LC_MESSAGES LC_COLLATE LC_ALL LANG' >> ${HOME}/.profile
		# No translation to do for thunderbird, default to en_EN
		# hotplug
		MOUNTPOINTNAME="Disks"
	;;
esac

. ${HOME}/.profile
# add xdg-user-dirs
export XDG_CONFIG_DIRS=$HOME/.config/user-dirs.dirs
xdg-user-dirs-update

# link to /vol for automounting
ln -s /vol/ ${HOME}/${MOUNTPOINTNAME}

rm $0
exit 0


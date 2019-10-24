#!/bin/sh

# first session launch configuration
. ${HOME}/.profile

xrdb -merge $HOME/.Xresources # for xterm later

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
		# hotplug
		MOUNTPOINTNAME="Médias"
		# cwm
		sed -i -e "s;___CWMSHORTCUTS;RACCOURCIS;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMWEB;Navigateur web;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMMAILS;Client de messagerie;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMFILES;Fichiers;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMOFFICE;Bureautique;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMMUSIC;Musique;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMMIXER;Volume;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMXTERM;Terminal;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMPKGMGR;Gestionnaire de paquets;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMMANISOTOP;man isotop-fr;" ${HOME}/.cwmrc

		sed -i -e "s;___CWMSESSION;SESSION;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMEDITCONFIG;Configurer cwm;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMLOGOUT;Déconnexion;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMLOCK;Verouiller;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMSUSPEND;Suspendre;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMREBOOT;Redémarrer;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMHALT;Éteindre;" ${HOME}/.cwmrc
		# show man
		xterm -rv -e 'man isotop-fr' &
	;;
	*)
		echo 'LC_CTYPE="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'LC_MESSAGES="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'LC_COLLATE="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'LC_ALL="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'LANG="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'export LC_CTYPE LC_MESSAGES LC_COLLATE LC_ALL LANG' >> ${HOME}/.profile
		# hotplug
		MOUNTPOINTNAME="Medias"
		# cwm
		sed -i -e "s;___CWMSHORTCUTS;SHORTCUTS;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMWEB;Web;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMMAILS;Mails;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMFILES;Files;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMOFFICE;Office;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMMUSIC;Music;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMMIXER;Mixer;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMPKGMGR;pkg_mgr;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMMANISOTOP;man isotop;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMXTERM;Term;" ${HOME}/.cwmrc

		sed -i -e "s;___CWMSESSION;SESSION;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMEDITCONFIG;Configure cwm;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMLOGOUT;Logout;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMLOCK;Lock;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMSUSPEND;Suspend;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMREBOOT;Reboot;" ${HOME}/.cwmrc
		sed -i -e "s;___CWMHALT;Halt;" ${HOME}/.cwmrc

		# show man
		xterm -rv -e 'man isotop' &
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


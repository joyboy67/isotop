#!/bin/sh
# Auteur :      prx <prx@ybad.name>
# licence :     MIT
# Description : install isotop customization on OpenBSD

lang=$(cat /etc/kbdtype)

case $lang in 
	fr*)
		DOASINSTALL='Si vous en avez la permission, vous pouvez maintenant lancer 
    doas sh isotop-root.sh
Ou recharger votre session'
	;;
	*)
		DOASINSTALL='If you have permission, you may now run
    doas sh isotop-root.sh
Or reload your session'
	;;
esac

wd=$(pwd)
echo "* Copy user configuration"
cp -v -r isotop-files/user $HOME
cp -v -r isotop-files/user/.* $HOME/

# compile dwm, slstatus, dmenu
echo "* compiles tools"
cd $wd/isotop-files/src/dwm
make
cp -f dwm $HOME/bin/dwm-isotop
cd $wd/isotop-files/src/dmenu
make
cp -f dmenu dmenu_path dmenu_run stest $HOME/bin/
cd $wd/isotop-files/src/slstatus
make
cp -f slstatus $HOME/bin/
# compile lsdesktop
cd $wd/isotop-files/src/lsdesktop
make lsdesktop && cp lsdesktop $HOME/bin/
cd $wd

mkdir -p ${HOME}/.config

echo "* set up language"
# TRADS
case $lang in 
	fr*)
		echo 'LC_CTYPE="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'LC_MESSAGES="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'LC_COLLATE="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'LC_ALL="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'LANG="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'export LC_CTYPE LC_MESSAGES LC_COLLATE LC_ALL LANG' >> ${HOME}/.profile
		# xdg
		echo 'fr_FR.UTF-8' > ${HOME}/.config/user-dirs.locale
		# manpage
		mv $HOME/.isotop/man/man7/isotop-fr.mdoc \
		     $HOME/.isotop/man/man7/isotop.mdoc
	;;
	*)
		echo 'LC_CTYPE="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'LC_MESSAGES="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'LC_COLLATE="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'LC_ALL="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'LANG="en_EN.UTF-8"' >> ${HOME}/.profile
		echo 'export LC_CTYPE LC_MESSAGES LC_COLLATE LC_ALL LANG' >> ${HOME}/.profile
		# xdg
		echo 'en_EN.UTF-8' > ${HOME}/.config/user-dirs.locale
	;;
esac

. ${HOME}/.profile

# manpages
echo "* install isotop manpages"
find $HOME/.isotop/man/ -type f -iname *.mdoc | while read -r m
do
	section=$(echo "${m}" | grep -o "man[0-9]" | cut -c4)
	mandoc -T man "${m}" > "${m%.*}.$section"
done
makewhatis $HOME/.isotop/man

# make sure scripts are +x
chmod +x ${HOME}/bin/*

# add xdg-user-dirs
xdg-user-dirs-update

# mpd
echo "* set up mpd"
mkdir -p $HOME/.mpd/playlists

echo "* install checkbatt cron"
(
crontab -l
echo "*/5 * * * * $HOME/bin/checkbatt >/dev/null 2>&1"
) | sort -u | crontab -

echo ""
echo "------------"
echo "${DOASINSTALL}"

exit 0


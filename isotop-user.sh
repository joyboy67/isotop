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
cp -v -r isotop-files/user/* $HOME/
cp -v -r isotop-files/user/.* $HOME/

if [ ! -f $HOME/.bookmarks ]; then
	echo "* add bookmarks"
	cat << EOF >> $HOME/.bookmarks
OpenBSD https://www.openbsd.org/
OpenBSD pour tou(te)?s https://openbsd.fr.eu.org
EOF
fi

# compile dwm, st, slstatus, dmenu, rover
echo "* compiles tools"
for i in dwm dmenu st slstatus rover; do
	cd $wd/isotop-files/src/$i
	make
	make install PREFIX=$HOME MANPREFIX=$HOME/man/
done

#rename dwm
mv -fv $HOME/bin/dwm $HOME/bin/dwm-isotop

cd $wd/isotop-files/src/lsdesktop
make lsdesktop && cp lsdesktop $HOME/bin/

# back to first directory
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
		mdocs=isotop-files/mdoc/fr
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
		# manpage
		mdocs=isotop-files/mdoc/en
	;;
esac

. ${HOME}/.profile

# manpages
echo "* install isotop manpages"
mkdir -p $HOME/man
cp -r ${mdocs}/* $HOME/man
find $HOME/man/ -type f -iname *.mdoc | while read -r m
do
	section=$(echo "${m}" | grep -o "man[0-9]" | cut -c4)
	mandoc -T man "${m}" > "${m%.*}.$section"
	rm "${m}"
done
makewhatis $HOME/man

# set up wallpaper
mkdir $HOME/.wallpapers 
cp -v isotop-files/walls/isotopwall.jpg $HOME/.wallpapers/

# make sure scripts are +x
chmod +x ${HOME}/bin/*

# mpd
echo "* set up mpd"
mkdir -p $HOME/mpd
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


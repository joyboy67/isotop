#!/bin/sh
# Auteur :      prx <prx@ybad.name>
# licence :     MIT

# Description : install isotop customization on OpenBSD

VERSION="_ISOTOPVERSION_"
ISOTOPURL="https://framagit.org/3hg/isotop/raw/master/"

selmenu()
{
# show a menu from a list in $@ and return user choice
	ans=""
	select item in $@; do
		if [ $REPLY -gt 0 -a $REPLY -le $# ]; then
			echo $item
			break
		fi
	done
}

echo "Language ?"
lang=$(selmenu fr en)

case $lang in 
	fr*)
		RELOADMSG='Ouvrez une nouvelle session pour utiliser isotop'
		XENODMWHOAREYOU='Qui est-ce ?'
		XENODMLOGIN='identifiant ='
		XENODMPASSWORD='secret =      '
		XENODMFAIL='Echec :s'
	;;
	*)
		RELOADMSG='Open a new session to use isotop'
		XENODMWHOAREYOU='Who are you?'
		XENODMLOGIN='login=   '
		XENODMPASSWORD='password='
		XENODMFAIL='Authentication failed :s'
	;;
esac

wd=$(pwd)
echo "* Get isotop files"
ftp "${ISOTOPURL}/isotop-${VERSION}.tgz"
ftp "${ISOTOPURL}/isotop-${VERSION}.sha256"
echo "* Check $0 checksum before going any further"
sha256 -C isotop-${VERSION}.sha256 isotop-${VERSION}.sh || exit 1
sha256 -C isotop-${VERSION}.sha256 isotop-${VERSION}.tgz || exit 1

# untar and copy files
echo "* Untgz archive"
tar xzf isotop-${VERSION}.tgz

echo "* Copy user configuration"
cp -v -r isotop-files/user $HOME
cp -v -r isotop-files/user/.* $HOME/

# compile dwm, slstatus, dmenu
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
		# hotplug
		MOUNTPOINTNAME="Médias"
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
		# hotplug
		MOUNTPOINTNAME="Medias"
	;;
esac

. ${HOME}/.profile

# make sure scripts are +x
chmod +x ${HOME}/bin/*

# add xdg-user-dirs
xdg-user-dirs-update

# link to /vol for automounting
ln -s /vol/ ${HOME}/${MOUNTPOINTNAME}

# mpd
mkdir -p $HOME/.mpd/playlists

# install checkbatt cron
(
crontab -l
echo "*/5 * * * * $HOME/bin/checkbatt >/dev/null 2>&1"
) | sort -u | crontab -

echo ""
echo "------------"
echo "${DOASINSTALL}"
echo "${RELOADMSG}"

exit 0


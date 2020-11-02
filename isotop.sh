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

# warning
banner "isotop"
echo "Files in /etc will be modified,"
echo "packages will be installed,"
echo "press ctrl-c if you're not sure to install isotop customization."
echo ""

echo "Language ?"
lang=$(selmenu fr en)

case $lang in 
	fr*)
		THX="Merci ! ;)"
		DLFILES='Vous pouvez maintenant supprimer les fichiers avec
    rm -r isotop*'
		RELOADMSG='Ouvrez une nouvelle session pour utiliser isotop'
		XENODMWHOAREYOU='Qui est-ce ?'
		XENODMLOGIN='identifiant ='
		XENODMPASSWORD='secret =      '
		XENODMFAIL='Echec :s'
		LASTVER="La dernière version d'isotop est déjà installée."
	;;
	*)
		THX="Thanks! ;)"
		DLFILES='Feel free to remove files with : 
    rm -r isotop*'
		RELOADMSG='Open a new session to use isotop'
		XENODMWHOAREYOU='Who are you?'
		XENODMLOGIN='login=   '
		XENODMPASSWORD='password='
		XENODMFAIL='Authentication failed :s'
		LASTVER="The last isotop version is already installed" 
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
for i in dwm slstatus dmenu; do
	echo "compile $i"
	cd $wd/isotop-files/src/$i && make && make install PREFIX=$HOME MANPREFIX=/tmp
done
# compile lsdesktop
cd $wd/isotop-files/src/lsdesktop
make lsdesktop && cp lsdesktop $HOME/bin/
cd $wd

# TRADS
case $lang in 
	fr*)
		echo 'LC_CTYPE="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'LC_MESSAGES="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'LC_COLLATE="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'LC_ALL="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'LANG="fr_FR.UTF-8"' >> ${HOME}/.profile
		echo 'export LC_CTYPE LC_MESSAGES LC_COLLATE LC_ALL LANG' >> ${HOME}/.profile
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
		# hotplug
		MOUNTPOINTNAME="Medias"
	;;
esac

. ${HOME}/.profile

# make sure scripts are +x
chmod +x ${HOME}/bin/*

# add xdg-user-dirs
export XDG_CONFIG_DIRS=$HOME/.config/user-dirs.dirs
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

###
# root configuration
###
# no need to remake all changes
test ! -f /etc/isotop.version && echo "0" | doas tee -a /etc/isotop.version
if [ ${VERSION} -gt $(cat /etc/isotop.version) ]; then

	# softdep
	echo "* Enable softdeps"
	doas sed -i 's/ffs rw,/ffs rw,softdep,/g' /etc/fstab   # only one ffs
	doas sed -i 's/softdep,softdep,/softdep,/g' /etc/fstab # only one softdep
	doas mount -a

	echo "* Copy rc scripts"
	doas cp -v -r isotop-files/etc/rc.local /etc/
	doas chmod +x /etc/rc.local
	doas cp -v -r isotop-files/etc/rc.shutdown /etc/
	doas chmod +x /etc/rc.shutdown

	# manpages
	doas cp -v -r isotop-files/man/man7/* /usr/local/man/man7/
	echo "* Build manpage database"
	doas makewhatis

	# xenodm
	sed -i -e "s;___WHOAREYOU___;${XENODMWHOAREYOU};" isotop-files/etc/X11/xenodm/Xresources.isotop
	sed -i -e "s;___LOGIN___;${XENODMLOGIN};" isotop-files/etc/X11/xenodm/Xresources.isotop
	sed -i -e "s;___PASSWORD___;${XENODMPASSWORD};" isotop-files/etc/X11/xenodm/Xresources.isotop
	sed -i -e "s;___FAILEDLOGIN___;${XENODMFAIL};" isotop-files/etc/X11/xenodm/Xresources.isotop
	doas cp -v -r isotop-files/etc/X11/xenodm/Xsetup_0 /etc/X11/xenodm/
	doas cp -v -r isotop-files/etc/X11/xenodm/GiveConsole /etc/X11/xenodm/
	doas cp -v -r isotop-files/etc/X11/xenodm/Xresources.isotop /etc/X11/xenodm/
	doas chmod +x /etc/X11/xenodm/Xsetup_0
	doas chmod +x /etc/X11/xenodm/GiveConsole
	doas sed -i '/DisplayManager\*resources:.*$/s/.*/DisplayManager*resources:\/etc\/X11\/xenodm\/Xresources.isotop/' /etc/X11/xenodm/xenodm-config
	WALLDIR=/usr/local/share/isotop/walls
	WALL="${WALLDIR}/loginbg.jpg"
	doas mkdir -p ${WALLDIR}
	doas cp isotop-files/walls/loginbg.jpg "${WALL}"

	echo "* Enable xenodm"
	doas rcctl enable xenodm

	# apm
	echo "* Enable apmd"
	doas rcctl enable apmd
	doas rcctl set apmd status on
	doas rcctl set apmd flags -A
	doas mkdir -p /etc/apm/
	doas cp -rv isotop-files/etc/apm/* /etc/apm/
	doas chmod +x /etc/apm/*

	# doas
	echo "* Configure doas"

	echo "permit persist :wheel
permit nopass  :wheel cmd /sbin/shutdown
permit nopass  :wheel cmd /sbin/reboot
permit nopass  :wheel cmd /sbin/disklabel
permit nopass  :wheel cmd /sbin/mount
permit nopass  :wheel cmd /sbin/umount
permit nopass  :wheel cmd /usr/sbin/zzz
permit nopass  :wheel cmd /usr/sbin/ZZZ
" | doas tee /etc/doas.conf

	# unwind configuration
	echo "* Configure unwind DNS resolver"
	echo 'block list "/var/unwind.block"' | doas tee /etc/unwind.conf
	doas rcctl enable unwind

	echo "* Configure dhclient"
	echo "prepend domain-name-servers 127.0.0.1;" | doas tee /etc/dhclient.conf

	echo "* Installing packages"
	doas pkg_add -vmzl isotop-files/packages.txt
	if [ $? -eq 0 ]; then
		echo '* Package installation finished :)'
	else
		echo '* Package installation did not work :('
		exit 1
	fi

	echo "* Enable hotplugd"
	doas /usr/local/libexec/hotplug-diskmount init
	doas cp -v -r isotop-files/etc/hotplug/ /etc/
	doas chmod +x /etc/hotplug/{attach,detach}
	doas rcctl enable hotplugd
	doas rcctl start hotplugd

	echo "* Set up ntpd"
	doas sed -i 's/www\.google\.com/www.openbsd.org/' /etc/ntpd.conf
	doas rcctl enable ntpd

	echo "* Enable cups"
	doas rcctl enable cupsd cups_browsed
	doas rcctl start cupsd cups_browsed

	echo "* Save isotop version"
	echo ${VERSION} | doas tee /etc/isotop.version
else
	echo "${LASTVER}"
fi

echo ""
echo "------------"
echo "${DLFILES}"
echo "${RELOADMSG}"
echo "${THX}"

exit 0


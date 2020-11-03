#!/bin/sh
# this must be run as root

if [ $(id -u) -ne 0 ]; then
	echo "You must be root"
	exit
fi

lang=$(cat /etc/kbdtype)

case $lang in 
	fr*)
		RELOADMSG='Ouvrez une nouvelle session pour utiliser isotop'
		XENODMWHOAREYOU='Qui est-ce ?'
		XENODMLOGIN='identifiant ='
		XENODMPASSWORD='secret =      '
		XENODMFAIL='Echec :s'
		LASTVER='La dernière version d'isotop est déjà
installée'
	;;
	*)
		RELOADMSG='Open a new session to use isotop'
		XENODMWHOAREYOU='Who are you?'
		XENODMLOGIN='login=   '
		XENODMPASSWORD='password='
		XENODMFAIL='Authentication failed :s'
		LASTVER='Last isotop version already installed'
	;;
esac

# no need to remake all changes
test ! -f /etc/isotop.version && echo "0" | tee /etc/isotop.version
if [ $(cat isotop-files/etc/isotop.version) -le $(cat /etc/isotop.version) ]; then
	echo "${LASTVER}"
else
	# softdep
	echo "* Enable softdeps"
	sed -i 's/ffs rw,/ffs rw,softdep,/g' /etc/fstab   # only one ffs
	sed -i 's/softdep,softdep,/softdep,/g' /etc/fstab # only one softdep
	mount -a

	echo "* Copy rc scripts"
	if [ -z $(grep -q "sh /etc/rc.local.isotop" /etc/rc.local) ]; then
		cp -v -r isotop-files/etc/rc.local.isotop /etc/
		echo "sh /etc/rc.local.isotop" | tee -a /etc/rc.local
		chmod +x /etc/rc.local
	fi

	# xenodm
	cp -v -r isotop-files/etc/X11/xenodm/Xsetup_0 /etc/X11/xenodm/
	cp -v -r isotop-files/etc/X11/xenodm/GiveConsole /etc/X11/xenodm/
	cp -v -r isotop-files/etc/X11/xenodm/Xresources.isotop /etc/X11/xenodm/
	sed -i -e "s;___WHOAREYOU___;${XENODMWHOAREYOU};" /etc/X11/xenodm/Xresources.isotop
	sed -i -e "s;___LOGIN___;${XENODMLOGIN};" /etc/X11/xenodm/Xresources.isotop
	sed -i -e "s;___PASSWORD___;${XENODMPASSWORD};" /etc/X11/xenodm/Xresources.isotop
	sed -i -e "s;___FAILEDLOGIN___;${XENODMFAIL};" /etc/X11/xenodm/Xresources.isotop
	sed -i '/DisplayManager\*resources:.*$/s/.*/DisplayManager*resources:\/etc\/X11\/xenodm\/Xresources.isotop/' /etc/X11/xenodm/xenodm-config
	chmod +x /etc/X11/xenodm/Xsetup_0
	chmod +x /etc/X11/xenodm/GiveConsole
	WALLDIR=/usr/local/share/isotop/walls
	WALL="${WALLDIR}/loginbg.jpg"
	mkdir -p ${WALLDIR}
	cp isotop-files/walls/loginbg.jpg "${WALL}"

	echo "* Enable xenodm"
	rcctl enable xenodm

	# apm
	echo "* Enable apmd"
	rcctl enable apmd
	rcctl set apmd status on
	rcctl set apmd flags -A
	mkdir -p /etc/apm/
	cp -rv isotop-files/etc/apm/* /etc/apm/
	chmod +x /etc/apm/*

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
" | tee /etc/doas.conf

	# unwind configuration
	echo "* Configure unwind DNS resolver"
	echo 'block list "/var/unwind.block"' | tee /etc/unwind.conf
	rcctl enable unwind

	echo "* Configure dhclient"
	echo "prepend domain-name-servers 127.0.0.1;" | tee /etc/dhclient.conf

	echo "* Installing packages"
	pkg_add -vmzl isotop-files/packages.txt
	if [ $? -eq 0 ]; then
		echo '* Package installation finished :)'
	else
		echo '* Package installation did not work :('
		exit 1
	fi

	echo "* Set up ntpd"
	sed -i 's/www\.google\.com/www.openbsd.org/' /etc/ntpd.conf
	rcctl enable ntpd

	echo "* Save isotop version"
	cp isotop-files/etc/isotop.version /etc/isotop.version

	echo ""
	echo "------------"
	echo "${RELOADMSG}"
fi

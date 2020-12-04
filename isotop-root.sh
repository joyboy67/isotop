#!/bin/sh
# this must be run as root

if [ $(id -u) -ne 0 ]; then
	echo "You must be root"
	exit
fi

addline()
{
	# addline "line" "file"
	# avoid doubles
	grep -qxF "${1}" "${2}" || echo "${1}" >> "${2}"
}

lang=$(cat /etc/kbdtype)

case $lang in 
	fr*)
		RELOADMSG='Ouvrez une nouvelle session pour utiliser isotop'
		XENODMWHOAREYOU='Qui est-ce ?'
		XENODMLOGIN='identifiant ='
		XENODMPASSWORD='\\040\\040\\040\\040\\040secret ='
		XENODMFAIL='Echec :s'
		LASTVER="La dernière version d\'isotop est déjà installée"
	;;
	*)
		RELOADMSG='Open a new session to use isotop'
		XENODMWHOAREYOU='Who are you?'
		XENODMLOGIN='\\040\\040\\040\\040login='
		XENODMPASSWORD='password='
		XENODMFAIL='Authentication failed :s'
		LASTVER='Last isotop version already installed'
	;;
esac

# no need to remake all changes
test ! -f /etc/isotop.version && echo "0" > /etc/isotop.version
if [ $(cat isotop-files/etc/isotop.version) -le $(cat /etc/isotop.version) ]; then
	echo "${LASTVER}"
else
	# softdep
	echo "* Enable softdeps"
	sed -i 's/ffs rw,/ffs rw,softdep,/g' /etc/fstab   # only one ffs
	sed -i 's/softdep,softdep,/softdep,/g' /etc/fstab # only one softdep
	mount -a

	echo "* Copy rc scripts"
	cp -v -r isotop-files/etc/rc.local.isotop /etc/
	addline "sh /etc/rc.local.isotop" /etc/rc.local

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

	addline "permit persist :wheel" /etc/doas.conf
	addline "permit nopass  :wheel cmd /sbin/shutdown" /etc/doas.conf
	addline "permit nopass  :wheel cmd /sbin/reboot" /etc/doas.conf
	addline "permit nopass  :wheel cmd /sbin/disklabel" /etc/doas.conf
	addline "permit nopass  :wheel cmd /sbin/mount" /etc/doas.conf
	addline "permit nopass  :wheel cmd /sbin/umount" /etc/doas.conf
	addline "permit nopass  :wheel cmd /usr/sbin/zzz" /etc/doas.conf
	addline "permit nopass  :wheel cmd /usr/sbin/ZZZ" /etc/doas.conf

	# unwind configuration
	echo "* Configure unwind DNS resolver"
	addline 'block list "/var/unwind.block"' /etc/unwind.conf
	rcctl enable unwind

	echo "* Configure dhclient"
	addline "prepend domain-name-servers 127.0.0.1;" /etc/dhclient.conf

	echo "* Installing packages"
	pkg_add -vmzl isotop-files/packages.txt

	echo "* Set up ntpd"
	sed -i 's/www\.google\.com/www.openbsd.org/' /etc/ntpd.conf
	rcctl enable ntpd

	echo "* Save isotop version"
	cp isotop-files/etc/isotop.version /etc/isotop.version

	echo ""
	echo "------------"
	echo "${RELOADMSG}"
fi

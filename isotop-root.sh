#!/bin/sh
# this must be run as root

VERSION="_ISOTOPVERSION_"
# no need to remake all changes
test ! -f /etc/isotop.version && echo "0" | doas tee -a /etc/isotop.version
if [ ${VERSION} -gt $(cat /etc/isotop.version) ]; then
	# softdep
	echo "* Enable softdeps"
	doas sed -i 's/ffs rw,/ffs rw,softdep,/g' /etc/fstab   # only one ffs
	doas sed -i 's/softdep,softdep,/softdep,/g' /etc/fstab # only one softdep
	doas mount -a

	echo "* Copy rc scripts"
	if [ -z $(grep -q "sh /etc/rc.local.isotop" /etc/rc.local) ]; then
		doas cp -v -r isotop-files/etc/rc.local.isotop /etc/
		echo "sh /etc/rc.local.isotop" | doas tee -a /etc/rc.local
		doas chmod +x /etc/rc.local
	fi

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
	echo "Last isotop version already installed"
fi

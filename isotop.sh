#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : This will install the isotop preconfiguration on an
# OpenBSD system

# check if root
if [ $(id -u) -eq 0 ]; then
	echo "You must run this script with root privileges"
	exit
fi

# TRADS
lang=$(cat /etc/kbdtype)

case $lang in 
	"fr")
		REBOOTMSG='Entrez la commande "reboot" pour utiliser isotop'
		XENODMWHOAREYOU='Qui est-ce ?'
		XENODMLOGIN='identifiant ='
		XENODMPASSWORD=' secret ='
		XENODMFAIL='Echec :s'
	;;
	*)
		REBOOTMSG='Enter "reboot" to start on you new isotop install'
		XENODMWHOAREYOU='Who are you?'
		XENODMLOGIN='login='
		XENODMPASSWORD='password='
		XENODMFAIL='Authentication failed :s'
	;;
esac



VERSION="65"
ISOTOPURL="https://yeuxdelibad.net/DL/isotop/"

echo "======================="
echo "     isotop install    "
echo "======================="

echo "* Customizing boot.conf"
echo "---"
echo "echo ---" > /etc/boot.conf
echo "echo Let's boot on isotop ${VERSION}" >> /etc/boot.conf
echo "echo ---" >> /etc/boot.conf

echo "* Configuring install PATH"
echo "---"
echo "https://cdn.openbsd.org/pub/OpenBSD" > /etc/installurl

# doas
echo "* Configure doas"
echo "---"
echo "permit keepenv persist :wheel " >> /etc/doas.conf
echo "permit nopass :wheel cmd /sbin/shutdown" >> /etc/doas.conf
echo "permit nopass :wheel cmd /sbin/reboot" >> /etc/doas.conf

# softdep
echo "* Enable softdeps"
echo "---"
sed -i 's/rw,/rw,softdep,/g' /etc/fstab

# ports
#echo "* Ports configuration"
#echo "---"
#cd /usr
#ftp http://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/ports.tar.gz
#ftp http://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/SHA256.sig
#signify -Cp /etc/signify/openbsd-$(uname -r | cut -c 1,3)-base.pub -x SHA256.sig ports.tar.gz
#tar xzf ports.tar.gz
#rm ports.tar.gz
#

######
#####
echo "* Get isotop files"
echo "---"
cd /tmp
ftp "${ISOTOPURL}/isotop-${VERSION}.tgz"
cd /
tar xzf /tmp/isotop-${VERSION}.tgz
chmod +x /etc/X11/xenodm/Xsetup_0
chmod +x /etc/X11/xenodm/*Console
chmod +x /usr/local/share/isotop/bin/*

### set trads for xenodm
sed -i -e "s;___WHOAREYOU___;${XENODMWHOAREYOU};" /etc/X11/xenodm/Xresources_isotop
sed -i -e "s;___LOGIN___;${XENODMLOGIN};" /etc/X11/xenodm/Xresources_isotop
sed -i -e "s;___PASSWORD___;${XENODMPASSWORD};" /etc/X11/xenodm/Xresources_isotop
sed -i -e "s;___FAILEDLOGIN___;${XENODMFAIL};" /etc/X11/xenodm/Xresources_isotop

# unbound configuration
echo "* Configure unbound DNS resolver"
echo "---"
rcctl enable unbound

echo "* Configure dhclient"
echo "---"
echo "prepend domain-name-servers 127.0.0.1;" >> /etc/dhclient.conf

echo "* Enable zerohosts script at boot"
echo "---"
ftp -o /usr/local/sbin/zerohosts "https://dev.yeuxdelibad.net/OpenBSD-stuff/zerohosts"
echo "/usr/local/sbin/zerohosts &" >> /etc/rc.local
chmod +x /usr/local/sbin/zerohosts
/usr/local/sbin/zerohosts &

echo "* Enable apmd"
echo "---"
rcctl enable apmd
rcctl set apmd status on
rcctl set apmd flags -A

echo "* Enable xenodm"
echo "---"
rcctl enable xenodm

echo '* Installing packages' 
PACKAGES="$(cat /usr/local/share/isotop/data/packages)"

pkg_add -vmz $PACKAGES | tee -a -

if [ $? -eq 0 ]; then
	echo '* Package installation finished :)'
else
	echo '* Package installation did not work :('
	exit 1
fi

echo ""
echo "* Enable hotplugd"
echo "---"
/usr/local/libexec/hotplug-diskmount init
chmod +x /etc/hotplug/{attach,detach}
rcctl enable hotplugd
rcctl start hotplugd
echo ""

echo "* Set up ntpd"
echo "---"
sed -i 's/www\.google\.com/www.openbsd.org/' /etc/ntpd.conf


echo "* Enable messagebus"
echo "---"
rcctl enable messagebus
rcctl order messagebus
rcctl start messagebus
echo ""

echo "* Enable cups"
echo "---"
rcctl enable cupsd cups_browsed
rcctl start cupsd cups_browsed
echo ""

# Reboot
echo "${REBOOTMSG}"

exit 0


#!/bin/sh
# Auteur :      prx <prx@ybad.name>
# licence :     MIT

# Description : This will install the isotop preconfiguration on an
# OpenBSD system

# check if root
if [ $(id -u) -ne 0 ]; then
	echo "You must run this script with root privileges"
	exit 1
fi
OBSDVER=$(uname -r | tr -d '.') # 65
if [ $OBSDVER -lt 65 ]; then
	echo "isotop support only OpenBSD > 6.5"
	exit 1
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
ISOTOPURL="https://ybad.name/DL/isotop/"

echo "======================="
echo "     isotop install    "
echo "======================="

echo "* Customizing boot.conf"
echo "echo ---" > /etc/boot.conf
echo "echo Let's boot on isotop ${VERSION}" >> /etc/boot.conf
echo "echo ---" >> /etc/boot.conf

echo "* Configuring install PATH"
echo "https://cdn.openbsd.org/pub/OpenBSD" > /etc/installurl

# doas
echo "* Configure doas"
echo "permit persist :wheel " >> /etc/doas.conf
echo "permit nopass :wheel cmd /sbin/shutdown" >> /etc/doas.conf
echo "permit nopass :wheel cmd /sbin/reboot" >> /etc/doas.conf
echo "permit nopass :wheel cmd env" >> /etc/doas.conf


# softdep
echo "* Enable softdeps"
sed -i 's/rw,/rw,softdep,/g' /etc/fstab

# ports
#echo "* Ports configuration"
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
cd /tmp
ftp "${ISOTOPURL}/isotop-${VERSION}.tgz"
cd /
tar xzf /tmp/isotop-${VERSION}.tgz
chmod +x /etc/X11/xenodm/Xsetup_0
chmod +x /etc/X11/xenodm/*Console
chmod +x /usr/local/share/isotop/bin/*
PATH=$PATH:/usr/local/share/isotop/bin

### set trads for xenodm
sed -i -e "s;___WHOAREYOU___;${XENODMWHOAREYOU};" /etc/X11/xenodm/Xresources_isotop
sed -i -e "s;___LOGIN___;${XENODMLOGIN};" /etc/X11/xenodm/Xresources_isotop
sed -i -e "s;___PASSWORD___;${XENODMPASSWORD};" /etc/X11/xenodm/Xresources_isotop
sed -i -e "s;___FAILEDLOGIN___;${XENODMFAIL};" /etc/X11/xenodm/Xresources_isotop

# unwind configuration
echo "* Configure unwind DNS resolver"
rcctl enable unwind
if [ ${OBSDVER} -gt 65 ]; then
	# FIXME : remove test after 6.6
	touch /var/unwind.block
	echo 'block list "/var/unwind.block"' > /etc/unwind.conf
fi

echo "* Configure dhclient"
echo "prepend domain-name-servers 127.0.0.1;" >> /etc/dhclient.conf

echo "* Enable apmd"
rcctl enable apmd
rcctl set apmd status on
rcctl set apmd flags -A

echo "* Enable xenodm"
rcctl enable xenodm

echo '* Installing packages' 
PACKAGES=/usr/local/share/isotop/data/packages

pkg_add -vlmz $PACKAGES | tee -a -

if [ $? -eq 0 ]; then
	echo '* Package installation finished :)'
else
	echo '* Package installation did not work :('
	exit 1
fi

echo ""
echo "* Enable hotplugd"
/usr/local/libexec/hotplug-diskmount init
chmod +x /etc/hotplug/{attach,detach}
rcctl enable hotplugd
rcctl start hotplugd
echo ""

echo "* Set up ntpd"
sed -i 's/www\.google\.com/www.openbsd.org/' /etc/ntpd.conf


echo "* Enable messagebus"
rcctl enable messagebus
rcctl order messagebus
rcctl start messagebus
echo ""

echo "* Enable cups"
rcctl enable cupsd cups_browsed
rcctl start cupsd cups_browsed
echo ""

echo "* Build manpage database"
mandb
echo ""

# Reboot
echo "${REBOOTMSG}"

exit 0


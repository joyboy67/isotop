#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : This will install the isotop preconfiguration on an
# OpenBSD system

# check if root
if [ "⁽whoami)" != "root" ]; then
	echo "You must run this script with root privileges"
fi

# TRADS
lang=$(cat /etc/kbdtype)

case $lang in 
	"fr")
		REBOOTMSG='Entrez la commande "reboot" pour utiliser isotop'
		XENODMWHOAREYOU='Qui êtes vous ?'
		XENODMLOGIN='identifiant ='
		XENODMPASSWORD=' secret ='
		XENODMFAIL='Identification échouée :s'
	;;
	*)
		REBOOTMSG='Enter "reboot" to start on you new isotop install'
		XENODMWHOAREYOU='Who are you?'
		XENODMLOGIN='login='
		XENODMPASSWORD='password='
		XENODMFAIL='Authentication failed :s'
	;;
esac



VERSION="0.4"
ISOTOPURL="https://yeuxdelibad.net/DL/isotop/"

echo "======================="
echo "     isotop install    "
echo "======================="

echo "* Customizing boot.conf"
echo "---"
echo "---\nLet's boot on isotop ${VERSION}\n---" > /etc/boot.conf

echo "* Configuring install PATH"
echo "---"
# random cdn
CDNS="https://cloudflare.cdn.openbsd.org/pub/OpenBSD/
https://mirror.leaseweb.com/pub/OpenBSD/
https://fastly.cdn.openbsd.org/pub/OpenBSD/
https://mirror.vdms.io/pub/OpenBSD/"
echo "$CDNS" | sort -R | head -n 1 > /etc/installurl

# doas
echo "* Configure doas"
echo "---"
echo "permit keepenv persist :wheel " >> /etc/doas.conf

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
# FIXME
# Get configuration files : .tgz ?
cd /tmp
ftp "${ISOTOPURL}/isotop-${VERSION}.tgz"
cd /
tar xzf /tmp/isotop-${VERSION}.tgz

### set trads for xenodm
sed -i -e "s;___WHOAREYOU___;$(XENODMWHOAREYOU);" /etc/X11/xenodm/Xresources_isotop
sed -i -e "s;___LOGIN___;$(XENODMLOGIN);" /etc/X11/xenodm/Xresources_isotop
sed -i -e "s;___PASSWORD___;$(XENODMPASSWORD);" /etc/X11/xenodm/Xresources_isotop
sed -i -e "s;___FAILEDLOGIN___;$(XENODMFAIL /etc/X11/xenodm/Xresources_isotop

# unbound configuration
echo "* Configure unbound DNS resolver"
echo "---"
ftp -o /var/unbound/etc/unbound_ad_servers "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=unbound&showintro=0&mimetype=plaintext"
touch /etc/monthly.local
echo 'ftp -o /var/unbound/etc/unbound_ad_servers "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=unbound&showintro=0&mimetype=plaintext"' >> /etc/monthly.local
rcctl enable unbound

echo "* Configure dhclient"
echo "---"
echo "prepend domain-name-servers 127.0.0.1;" >> /etc/dhclient.conf

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

echo "* Disable ulpt to use USB printers"
echo "---"
config -fe /bsd << EOF
disable ulpt
quit
EOF
# recompute sha256 sum
sha256 /bsd > /var/db/kernel.SHA256

# Reboot
echo "${REBOOTMSG}"

exit 0


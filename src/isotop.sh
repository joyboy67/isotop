#!/bin/sh
# Auteur :      prx <prx@ybad.name>
# licence :     MIT

# Description : This will install the isotop preconfiguration on an
# OpenBSD system
VERSION="661"

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
		THX="Merci ! ;)"
		REBOOTMSG='Entrez la commande "reboot" pour utiliser isotop'
		XENODMWHOAREYOU='Qui est-ce ?'
		XENODMLOGIN='identifiant ='
		XENODMPASSWORD=' secret ='
		XENODMFAIL='Echec :s'
		SKEL="Voulez-vous copier la configuration d'isotop dans le HOME
des utilisateurs existants et remplacer leur configuration? Ils seront
aussi ajoutés au groupe wheel" 
	;;
	*)
		THX="Thanks! ;)"
		REBOOTMSG='Enter "reboot" to start on you new isotop install'
		XENODMWHOAREYOU='Who are you?'
		XENODMLOGIN='login='
		XENODMPASSWORD='password='
		XENODMFAIL='Authentication failed :s'
		SKEL="Do you want to copy isotop configuration from /etc/skel to
user's HOME directories? It will override previous configuration. They
will belong to wheel group then."
	;;
esac

ISOTOPURL="https://framagit.org/3hg/isotop/raw/master/"

echo "======================="
echo "     isotop install    "
echo "======================="



dldir=$(pwd)
echo "* Get isotop files"
ftp "${ISOTOPURL}/isotop-${VERSION}.tgz"
ftp "${ISOTOPURL}/isotop.sha256"
echo "* Check $0 checksum before going any further"
sha256 -C isotop.sha256 isotop.sh || exit 1
sha256 -C isotop.sha256 isotop-${VERSION}.tgz || exit 1
cd /
tar xzf "${dldir}"/isotop-${VERSION}.tgz
chmod +x /etc/X11/xenodm/Xsetup_0
chmod +x /etc/X11/xenodm/*Console
chmod +x /usr/local/share/isotop/bin/*
PATH=$PATH:/usr/local/share/isotop/bin

echo "* Remove downloaded files"
rm "${dldir}"/isotop-${VERSION}.tgz
rm "${dldir}"/isotop.sha256


echo "* Runnign syspatch for security reasons"
syspatch

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

# in case a previous isotop install has been made
sort -ru /etc/doas.conf -o /etc/doas.conf

# softdep
echo "* Enable softdeps"
sed -i 's/rw,/rw,softdep,/g' /etc/fstab
mount -a

# ports
#echo "* Ports configuration"
#cd /usr
#ftp http://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/ports.tar.gz
#ftp http://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/SHA256.sig
#signify -Cp /etc/signify/openbsd-$(uname -r | cut -c 1,3)-base.pub -x SHA256.sig ports.tar.gz
#tar xzf ports.tar.gz
#rm ports.tar.gz
#

### set trads for xenodm
sed -i -e "s;___WHOAREYOU___;${XENODMWHOAREYOU};" /etc/X11/xenodm/Xresources_isotop
sed -i -e "s;___LOGIN___;${XENODMLOGIN};" /etc/X11/xenodm/Xresources_isotop
sed -i -e "s;___PASSWORD___;${XENODMPASSWORD};" /etc/X11/xenodm/Xresources_isotop
sed -i -e "s;___FAILEDLOGIN___;${XENODMFAIL};" /etc/X11/xenodm/Xresources_isotop

# unwind configuration
echo "* Configure unwind DNS resolver"
rcctl enable unwind

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

pkg_add -vmzl $PACKAGES | tee -a -

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
rcctl enable ntpd

echo ""
echo "* Enable cups"
rcctl enable cupsd cups_browsed
rcctl start cupsd cups_browsed

echo ""
echo "* Build manpage database"
makewhatis
echo ""

userdirs=$(grep '/home' /etc/passwd | cut -d':' -f1,6)
	echo "${SKEL}"
	echo ""
	res=""
	for ud in $userdirs; do
		u=$(echo $ud | cut -d':' -f1)
		d=$(echo $ud | cut -d':' -f2)

		if [ "$res" != "a" ]; then
			echo "$u ?"
			echo "[Y]es / [No] / [A]ll / [S]top"
			read res
			res=$(echo $res | tr '[:upper:]' '[:lower:]')
		fi

		case $res in
			y|a ) 
				cp -vR /etc/skel/.* "$d/"
				# not yet
				# cp -vR /etc/skel/* "$d/" 
				chown -R ${u}:${u} "$d"
				usermod -G wheel ${u}
				;;
			n )
				echo ""
				;;
			s )
				break
				;;
			* )
				echo "Wrong answer, not copying anything"
				;;
		esac
	done

# Reboot
echo "${REBOOTMSG}"
echo "${THX}"


exit 0


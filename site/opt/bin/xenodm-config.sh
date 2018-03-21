#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : configure xenodm
# Depends : zeniTK

WIDTH=400
HEIGHT=300
DEFAULTBG=/opt/isotop/walls/loginbg.jpg
TITLE="Xenodm configuration"
QUESTION="What do you wan't to configure?"
TXT_CHGBG="Choose background image"
TXT_RDMBG="Choose random background image directory"
TXT_AUTOLOGIN="Set up autologin"
TXT_AUTOLOGIN_WARN="Enter username to automatically log in.
Warning, this leaves your machine open to the world"

RES=$(zeniTK --width $WIDTH --height $HEIGHT --text "$QUESTION" --list "$TXT_CHGBG" "$TXT_RDMBG" "$TXT_AUTOLOGIN")

case "$RES" in
	"$TXT_CHGBG") 
		BG=$(zeniTK --file-selection --file-filter "*JPG | *.jpg")
		if [ -f "$BG" ]; then
			cp "$BG" "$DEFAULTBG"
		fi
		;;
	"$TXT_RDMBG") 
		BGDIR=$(zeniTK --directory --file-selection)
		if [ -d "$BGDIR" ]; then
			sed -i "s;WALLDIR=.*$;WALLDIR=$BGDIR;" /etc/X11/xenodm/Xsetup_0
		fi
		;;
	"$TXT_AUTOLOGIN") 
		U=$(zeniTK --entry --text "$TXT_AUTOLOGIN_WARN")
		if [ -n "$U" ]; then
			sed -i "s/DisplayManager._0.autoLogin:.*$//" /etc/X11/xenodm/xenodm-config
			echo "DisplayManager._0.autoLogin:    $U" >> /etc/X11/xenodm/xenodm-config
		fi
esac

exit 0


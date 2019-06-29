#!/bin/sh
# This script is run at the beginning of each X session
# edit as you like, but remember to leave a "&" at the end of lines.

# isotop first start
if [ -f ~/.first.sh ]; then
	sh ~/.first.sh
fi

# translations and environment
. ~/.profile

# dbus
if [ -x /usr/local/bin/dbus-launch -a -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
    eval `dbus-launch --sh-syntax --exit-with-x11` &
fi

# Load X options
xrdb -merge ~/.Xresources &
# disable bell
xset b off &
# Random Wallpaper
rdmwall &
# numpad
numlockx &
# Vi user, be grateful
xcape -e 'Alt_L=Escape' &
# take care of you eyes, change temperature color
sct 5000 1>/dev/null &
# Auto-lock the screen
xidle -timeout 900 -program "/usr/X11R6/bin/xlock -mode space" &
# screen corners start menu 
xdotool behave_screen_edge --delay 600 bottom-left exec jgmenu_run &

# start cwm. No & here
cwm


#!/bin/sh
if [ -f ~/.first.sh ]; then
	~/.first.sh
fi
. ~/.profile
if [ -x /usr/local/bin/dbus-launch -a -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
        eval `dbus-launch --sh-syntax --exit-with-x11`
fi
startxfce4 --with-ck-launch

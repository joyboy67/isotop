#!/bin/sh

# translations and environment
. $HOME/.profile
# autostart
sh $HOME/.start &
# start dwm window manager
dwm-isotop

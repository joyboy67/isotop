#!/bin/sh

# translations and environment
. $HOME/.profile
# autostart
sh $HOME/.start &
# start window manager
dwm-isotop

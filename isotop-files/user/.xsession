#!/bin/sh

# translations and environment
. $HOME/.profile
# autostart
sh $HOME/.start &
# start session
dwm-isotop

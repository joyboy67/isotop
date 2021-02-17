#!/bin/sh

# load X resources for xterm later
xrdb -merge $HOME/.Xresources
xterm -rv -class 'float' -e 'man isotop' &
# delete self
rm $0
exit 0


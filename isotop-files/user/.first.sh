#!/bin/sh

# load X resources for xterm later
xrdb -merge $HOME/.Xresources

# TRADS
case $LANG in
    fr*) xterm -rv -class 'manisotop' -e 'man isotop-fr' & ;;
	*) xterm -rv -class 'manisotop' -e 'man isotop' & ;;
esac

# delete self
rm $0
exit 0


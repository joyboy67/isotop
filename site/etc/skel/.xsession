#!/bin/sh
if [ -f ~/.first.sh ]; then
	~/.first.sh
fi
. ~/.profile
startxfce4 --with-ck-launch

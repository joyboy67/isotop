#!/bin/sh
. ~/.profile
if [ -f ~/.first.sh ]; then
	~/.first.sh
fi
startxfce4 --with-ck-launch

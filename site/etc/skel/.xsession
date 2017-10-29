#!/bin/sh
if [ -f ~/.first.sh ]; then
	~/.first.sh
fi
. ~/.profile
ck-launch-session startxfce4

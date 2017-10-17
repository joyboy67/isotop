#!/bin/sh
. ~/.profile
if [ -f ~/.first.sh ]; then
	~/.first.sh
fi
ck-launch-session startxfce4

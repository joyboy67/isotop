#!/bin/sh

# first session launch configuration

# add xdg-user-dirs
export XDG_CONFIG_DIRS=$HOME/.config/user-dirs.dirs
xdg-user-dirs-update

# change mpd configuration
sed -i -e "s;CHANGEME;$(xdg-user-dir MUSIC);" ~/.mpdconf

rm $0
exit 0


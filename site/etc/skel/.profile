PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:/opt/bin:.
export PATH HOME TERM
LC_CTYPE="fr_FR.UTF-8"
LC_MESSAGES="fr_FR.UTF-8"
LC_ALL='fr_FR.UTF-8'
LANG='fr_FR.UTF-8'
export LC_CTYPE LC_MESSAGES LC_ALL LANG

export LDFLAGS="-L /usr/lib -L/usr/local/lib"
export CXXFLAGS="-I /usr/include -I/usr/local/include"

. ~/.kshrc

if [ "$(tty)" == "/dev/ttyC0" ]; then
    startx
fi

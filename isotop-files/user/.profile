PATH=$HOME/bin:$HOME/.local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:/opt/bin:.:/usr/local/jdk-1.8.0/jre/bin/:/usr/local/share/isotop/bin:$HOME/.cabal/bin:$HOME/.local/bin
EDITOR='vi'
VISUAL='vi'
TOP='-s .5'
PAGER=less
BROWSER='firefox'
ENV=$HOME/.kshrc
MANPATH=:$HOME/man
export VISUAL EDITOR PATH HOME TERM TOP PAGER BROWSER ENV MANPATH
export LDFLAGS="-L /usr/lib -L/usr/local/lib"
export CXXFLAGS="-I /usr/include -I/usr/local/include"
export ROVER_OPEN="rover-open"

# for firefox
export MOZ_ACCELERATED=1

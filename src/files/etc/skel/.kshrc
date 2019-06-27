. /etc/ksh.kshrc
HISTFILE=~/.ksh_hist
HISTSIZE=3000
HISTCONTROL=ignoredumps
# Prompt
_PS1_CLEAR='\[\033[0m\]'
_PS1_BLUE='\[\033[33m\]'
case "$(id -u)" in
	0) _PS1_COLOR='\[\033[0;31m\]' ;;
	*) _PS1_COLOR='\[\033[0;34m\]'   ;;
esac
PS1='($?) \[\033[1;29m\]\A $_PS1_COLOR\u@\h$_PS1_CLEAR:$_PS1_BLUE\w$_PS1_CLEAR
$_PS1_COLOR\$$_PS1_CLEAR '


# Some autocompletition stolen here :
# https://github.com/qbit/dotfiles/blob/master/common/dot_ksh_completions
PKG_LIST=$(ls -1 /var/db/pkg)
set -A complete_pkg_delete -- $PKG_LIST
set -A complete_pkg_info -- $PKG_LIST

set -A complete_ssh -- $(awk '{split($1,a,","); print a[1]}' $HOME/.ssh/known_hosts)
set -A complete_rcctl_1 -- disable enable get ls order set
set -A complete_rcctl_2 -- $(ls /etc/rc.d)

set -A complete_signify_1 -- -C -G -S -V
set -A complete_signify_2 -- -q -p -x -c -m -t -z
set -A complete_signify_3 -- -p -x -c -m -t -z
set -A complete_gpg2 -- --refresh --receive-keys --armor --clearsign --sign --list-key --decrypt --verify --detach-sig
set -A complete_ifconfig_1 -- $(ifconfig | grep ^[a-z] | cut -d: -f1)

pgrep -q vmd
if [ $? = 0 ]; then
	set -A complete_vmctl -- console load reload start stop reset status send receive
	set -A complete_vmctl_2 -- $(vmctl status | awk '!/NAME/{print $NF}')
fi

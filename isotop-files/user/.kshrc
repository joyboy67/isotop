# source some aliases
. /etc/ksh.kshrc
test -f $HOME/.aliases && . $HOME/.aliases
test -f $HOME/.functions && . $HOME/.functions

# history
HISTFILE=$HOME/.hist
HISTSIZE=3000
HISTCONTROL=ignoredumps # no doubles

# Prompt
# colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LGRAY='\033[0;37m'
DGRAY='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
LCYAN='\033[1;36m'
WHITE='\033[0;37m'
NC='\033[0m'
GREEN='\e[32m'
YELLOW='\e[33m'
BOLD='\e[1m'

case "$(id -u)" in
	0) _PS1_COLOR=${RED}  ;;
	*) _PS1_COLOR=${BLUE} ;;
esac

# set prompt red if error
get_retvalcol()
{
	case $? in
		0|130) RETVALCOL=${NC}  ;;
		*) RETVALCOL=${RED} ;;
	esac
	printf "%s" "${RETVALCOL}"
}

PS1='${NC}$(get_retvalcol)($?) ${BOLD}\w${NC}
${PURPLE}\A ${_PS1_COLOR}\u@\h${NC} \$ '

# autocompletion
# https://github.com/qbit/dotfiles/blob/master/common/dot_ksh_completions

set -A complete_git -- clone branch add rm checkout fetch show tag commit
PKG_LIST=$(ls -1 /var/db/pkg)
set -A complete_pkg_delete -- $PKG_LIST
set -A complete_pkg_info -- $PKG_LIST

if [ -f $HOME/.ssh/known_hosts ]; then
	set -A complete_ssh -- $(awk '{split($1,a,","); print a[1]}' $HOME/.ssh/known_hosts)
fi
set -A complete_rcctl_1 -- disable enable get ls order set
set -A complete_rcctl_2 -- $(ls /etc/rc.d)

set -A complete_signify_1 -- -C -G -S -V
set -A complete_signify_2 -- -q -p -x -c -m -t -z
set -A complete_signify_3 -- -p -x -c -m -t -z
set -A complete_gpg2 -- --refresh --receive-keys --armor --clearsign --sign --list-key --decrypt --verify --detach-sig
set -A complete_ifconfig_1 -- $(ifconfig | grep ^[a-z] | cut -d: -f1)

pgrep -q vmd >/dev/null 2>&1
if [ $? = 0 ]; then
	set -A complete_vmctl -- console load reload start stop reset status send receive
	set -A complete_vmctl_2 -- $(vmctl status | awk '!/NAME/{print $NF}')
fi

. /etc/ksh.kshrc
HISTFILE=~/.ksh_hist
HISTSIZE=3000
HISTCONTROL=ignoredumps
# Prompt
# nice colored prompt that also sets xterm title
_XTERM_TITLE='\[\033]0;\u@\h:\w\007\]'
_PS1_CLEAR='\[\033[0m\]'
_PS1_BLUE='\[\033[33m\]'
case "$(id -u)" in
	0) _PS1_COLOR='\[\033[0;31m\]' ;;
	*) _PS1_COLOR='\[\033[0;34m\]'   ;;
esac
PS1='${_XTERM_TITLE}\[\033[1;29m\]\A $_PS1_COLOR\u@\h$_PS1_CLEAR: $_PS1_BLUE\w$_PS1_COLOR
\$$_PS1_CLEAR '



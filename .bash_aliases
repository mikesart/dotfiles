
[[ -f ~/.bash_colors ]] && source ~/.bash_colors

# SSH_CLIENT=192.168.1.xxx
# SSH_CONNECTION=192.168.1.xxx
# SSH_TTY=/dev/ttys021
export IN_SSH_SESSION=0
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$SSH_CONNECTION" ]; then 
  IN_SSH_SESSION=1
fi

path_append ()  { path_remove $1; export PATH="$PATH:$1"; }
path_prepend () { path_remove $1; export PATH="$1:$PATH"; }
path_remove ()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }

# set PATH so it includes user's private bin if it exists.
if [ -d "$HOME/bin" ] ; then 
  path_prepend "$HOME/bin"
fi

export VISUAL=vi
export EDITOR=vi

shopt -s cdable_vars

setxkbmap -option "numpad:microsoft" &> /dev/null

export GREP_COLORS='ms=07;33:mc=07;33:sl=:cx=:fn=32:ln=33:bn=33:se=36'
alias grep='grep --color=always'

alias libc_version='ldd --version'

export LESS='-QRS --prompt="%f (%pb\%, %lmth line, %L lines)$ '

alias man="LESS_TERMCAP_mb=$'\E[01;31m' LESS_TERMCAP_md=$'\E[01;38;5;74m' LESS_TERMCAP_me=$'\E[0m' LESS_TERMCAP_se=$'\E[0m' LESS_TERMCAP_so=$'\E[48;5;3m\E[38;5;0m' LESS_TERMCAP_ue=$'\E[0m' LESS_TERMCAP_us=$'\E[04;38;5;146m' man"

alias less="LESS_TERMCAP_mb=$'\E[01;31m' LESS_TERMCAP_md=$'\E[01;38;5;74m' LESS_TERMCAP_me=$'\E[0m' LESS_TERMCAP_se=$'\E[0m' LESS_TERMCAP_so=$'\E[48;5;3m\E[38;5;0m' LESS_TERMCAP_ue=$'\E[0m' LESS_TERMCAP_us=$'\E[04;38;5;146m' less"

alias ll="ls -alF --group-directories-first --block-size=\'1"

# remove ls quotes around files with spaces
# https://unix.stackexchange.com/questions/258679/why-is-ls-suddenly-wrapping-items-with-spaces-in-single-quotes
export QUOTING_STYLE=literal

alias tree="tree -aCFl --charset=UTF8 --du -h"
alias tree_nogit="tree -aCFl --charset=UTF8 --du -h -I '.git'"

# what most people want from od (hexdump)
# hexdump -C ...
alias hd='od -Ax -tx1z -v'

alias dfc='dfc -Tadso'

# Will show 0644 or 0755 type perms for specified files
alias stat_perm="stat -c '%n %U:%G-%a'"

# Show which applications are connecting to network
alias listen="lsof -P -i -n"

# http://eli.thegreenplace.net/2013/06/11/keeping-persistent-history-in-bash/
# to trim history: tail -20000 ~/.persistent_history | tee ~/.persistent_history
log_bash_persistent_history()
{
  [[
    $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$
  ]]
  local date_part="${BASH_REMATCH[1]}"
  local command_part="${BASH_REMATCH[2]}"
  if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]
  then
    echo $date_part "|" "$command_part" >> ~/.persistent_history
    export PERSISTENT_HISTORY_LAST="$command_part"
  fi
}

# Stuff to do on PROMPT_COMMAND
run_on_prompt_command()
{
    log_bash_persistent_history
}

# from http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
function j
{
	cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function jump
{
	cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark
{
	mkdir -p "$MARKPATH";
	ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark
{
	rm -i "$MARKPATH/$1"
}
function marks
{
    # ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
    find ~/.marks -type l -exec sh -c 'printf "\033[1;36m%-12s\033[0m -> \033[1;34m%s\033[0m\n" $(basename {}) $(readlink -f {})' \; | sort
}

_completemarks()
{
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l -printf "%f\n")
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}
complete -F _completemarks jump unmark j

if [ -f /usr/lib/git-core/git-sh-prompt ]; then
  export GIT_PS1_SHOWDIRTYSTATE=1
  source /usr/lib/git-core/git-sh-prompt
else
__git_ps1()
{
    return 0
}
fi

export PS1="$BIYellow${debian_chroot:+<$debian_chroot> }"

if [ "$(id -u)" -eq 0 ]; then
  PS1+="$On_Red$BIYellow\u@\h$Color_Off:"
  PS1+="$BBlue\w$Color_Off"
  PS1+="$Green\$(__git_ps1 \" (%s)\")$Color_Off# "
else
  PS1+="$BRed\u@\h$Color_Off:"
  PS1+="$BBlue\w$Color_Off"
  PS1+="$Green\$(__git_ps1 \" (%s)\")$Color_Off\$ "
fi

bash_return_code()
{
	# http://david.newgas.net/return_code/
	# run false then bash_return_code to see the error code
	ret=$?; if [ $ret -ne 0 ] ; then echo -e "returned $(tput setaf 1)$ret$(tput sgr0)"; fi
}

alias persistent_history_note="history | tail -2 | head -1 | tr -s ' ' | cut -d' ' -f3- | awk '{print \"# \"\$0}' >> ~/.persistent_history_notes"

# http://eli.thegreenplace.net/2013/06/11/keeping-persistent-history-in-bash/
# to trim history: tail -20000 ~/.persistent_history | tee ~/.persistent_history
log_bash_persistent_history()
{
  [[
	$(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$
  ]]
  local date_part="${BASH_REMATCH[1]}"
  local command_part="${BASH_REMATCH[2]}"
  if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]
  then
	echo $date_part "|" "$command_part" >> ~/.persistent_history
	export PERSISTENT_HISTORY_LAST="$command_part"
  fi
}

# Stuff to do on PROMPT_COMMAND
run_on_prompt_command()
{
	log_bash_persistent_history
}

if [ -w ~/.persistent_history ]; then
  export HISTTIMEFORMAT="%F %T "
  # Bash shell executes the content of the PROMPT_COMMAND just before displaying the PS1 variable.
  PROMPT_COMMAND="run_on_prompt_command"
fi

# add this configuration to ~/.bashrc
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignoreboth    # ignore dupes and commands that start with a space
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)

if [ "$IN_SSH_SESSION" != "1" ]; then
  # kill the stop / start commands (see stty -a)
  stty stop undef
  stty start undef
fi


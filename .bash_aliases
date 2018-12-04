
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

export GREP_COLORS='ms=07;33:mc=07;33:sl=:cx=:fn=32:ln=33:bn=33:se=36'
alias grep='grep --color=always'

export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export LESS='-QRS --prompt="%f (%pb\%, %lmth line, %L lines)$ '

alias man="LESS_TERMCAP_mb=$'\E[01;31m' LESS_TERMCAP_md=$'\E[01;38;5;74m' LESS_TERMCAP_me=$'\E[0m' LESS_TERMCAP_se=$'\E[0m' LESS_TERMCAP_so=$'\E[48;5;3m\E[38;5;0m' LESS_TERMCAP_ue=$'\E[0m' LESS_TERMCAP_us=$'\E[04;38;5;146m' man"

alias less="LESS_TERMCAP_mb=$'\E[01;31m' LESS_TERMCAP_md=$'\E[01;38;5;74m' LESS_TERMCAP_me=$'\E[0m' LESS_TERMCAP_se=$'\E[0m' LESS_TERMCAP_so=$'\E[48;5;3m\E[38;5;0m' LESS_TERMCAP_ue=$'\E[0m' LESS_TERMCAP_us=$'\E[04;38;5;146m' less"

alias ll="ls -alF --group-directories-first --block-size=\'1"

alias tree="tree -aCFl --charset=UTF8 --du -h"

# what most people want from od (hexdump)
alias hd='od -Ax -tx1z -v'

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
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

_completemarks()
{
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l -printf "%f\n")
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}
complete -F _completemarks jump unmark j

export HISTTIMEFORMAT="%F %T "
PROMPT_COMMAND="run_on_prompt_command"

# add this configuration to ~/.bashrc
export HH_CONFIG=hicolor         # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignoreboth    # ignore dupes and commands that start with a space
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
# export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
# if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh \C-j"'; fi
export HH_ENV_VAR_HISTFILE=~/.persistent_history
export HH_ENV_HISTORY_FILE_OFFSET=22

# source /home/mikesart/dev/base16-shell-bash-colors/base16-shapeshifter.dark.sh

if [ "$IN_SSH_SESSION" != "1" ]; then
  # kill the stop / start commands (see stty -a)
  stty stop undef
  stty start undef
fi


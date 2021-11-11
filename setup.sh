#!/bin/bash

linkit()
{
    local SRC=$(readlink -f $1)
    local DST=${2:-~}/${SRC##*/}

    if [[ -f $DST ]]; then
        echo "$DST exists: (skipping)"
    else
        echo ln -s $SRC $DST
        ln -s $SRC $DST
    fi
}

unamestr=$(uname -m)

touch ~/.persistent_history

linkit .bashrc
linkit .bash_aliases
linkit .bash_colors
linkit .inputrc
linkit .gitconfig
linkit .drirc
linkit .tigrc

linkit gdb/.gdbinit
linkit gdb/.gdbinit.py

linkit .vimrc

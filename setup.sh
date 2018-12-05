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

mkdir -p ~/.config/htop

linkit .bashrc
linkit .bash_aliases
linkit .bash_colors
linkit .inputrc
linkit .vimrc
linkit .gitconfig
linkit htoprc ~/.config/htop

linkit gdb/.gdbcolors
linkit gdb/.gdbinit
linkit gdb/.gdbinit.py

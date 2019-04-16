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

linkit gdb/.gdbcolors
linkit gdb/.gdbinit
linkit gdb/.gdbinit.py


if [[ "$unamestr" == 'x86_64' ]]; then

linkit .vimrc

mkdir -p ~/.config/htop
linkit htoprc ~/.config/htop

linkit bin/mesa-ninja.sh ~/bin
linkit bin/mesa-with.sh ~/bin
linkit bin/mesa-mk-build-dirs.sh ~/bin
linkit bin/mnt-drive2.sh ~/bin

fi

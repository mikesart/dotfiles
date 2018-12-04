#!/bin/bash

copyit()
{
    local FILE="$@"

    if [[ -f ~/$FILE ]]; then
        echo "~/$FILE (skipping)"
    else
        cp $FILE ~/$FILE
    fi
}

sudo apt-get -y install vim htop tree smem ncdu binutils

mkdir -p ~/.config/htop

copyit .bashrc
copyit .bash_aliases
copyit .bash_colors
copyit .inputrc
copyit .vimrc
copyit .gitconfig
copyit .config/htop/htoprc

pushd gdb
copyit .gdbcolors
copyit .gdbinit
copyit .gdbinit.py
popd

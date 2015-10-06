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

mkdir -p ~/.config/htop

copyit .bashrc
copyit .bash_aliases
copyit .vimrc
copyit .gitconfig
copyit .config/htop/htoprc


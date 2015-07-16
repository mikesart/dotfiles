" save file with sudo
" http://www.cyberciti.biz/faq/vim-vi-text-editor-save-file-without-root-permission/
"   :w !sudo tee %
" command! -bar -nargs=0 SudoW :silent exe “write !sudo tee % >/dev/null” | silent edit!

set nocompatible
syntax on

set background=dark

set tabstop=4       " number of spaces a tab counts for when visually showing the tab.
set softtabstop=4   " number of spaces inserted when you hit <TAB> and removed when you backspace.
set expandtab       " tabs are spaces

set shiftwidth=4    "    

set showcmd         " show last command entered at bottom right
                    " also show leader key when hit - which is \

" set cursorline      " draw horizontal line under current line.

set scrolloff=10    " Keep 10 lines (top/bottom) for scope
set number          " turn on line numbers
set numberwidth=5   " We are good up to 99999 lines
set showmatch       " show matching brackets
set showmode
set sidescrolloff=10 " Keep 10 lines at the side
set incsearch       " search as characters are entered
set hlsearch        " highlight matches
set tags=tags;

" When pasting text in insert mode, hit F2 to toggle indentation smartness and
" just blast text in. Re-enable via hitting F2 again.
" This sets paste / nopaste.
set pastetoggle=<F2>

" http://emerg3nc3.wordpress.com/2012/07/28/full-256-color-support-for-vim-andor-xterm-on-ubuntu-12-04/
" enable 256 colors in VIM
set t_Co=256


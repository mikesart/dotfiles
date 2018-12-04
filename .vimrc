" save file with sudo
" http://www.cyberciti.biz/faq/vim-vi-text-editor-save-file-without-root-permission/
"   :w !sudo tee %
" command! -bar -nargs=0 SudoW :silent exe “write !sudo tee % >/dev/null” | silent edit!

set nocompatible
syntax on

set background=dark

" let mapleader = ","

" Green comments
highlight Comment ctermfg=green

" Use :list command
highlight ExtraWhitespace ctermfg=DarkGray
match ExtraWhitespace /\s\+$\|\t/
set listchars=tab:»\ ,trail:·,extends:>,precedes:<,nbsp:⎵
set list
:nmap <leader>l :set invlist<cr>

" run :retab to convert current file
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces inserted when you hit <TAB> and removed when you backspace.
set shiftwidth=4    "
set expandtab       " tabs are spaces

set showcmd         " show last command entered at bottom right
					" also show leader key when hit - which is \

" set cursorline      " draw horizontal line under current line.

set wildmenu        " visual autocomplete for command menu

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

" Restore cursor position when opening file
" https://github.com/mhinz/vim-galore
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Don't lose selection when shifting right/left.
xnoremap <  <gv
xnoremap >  >gv

" move vertically by visual line (don't skip over "fake" part of really long
" lines)
nnoremap j gj
nnoremap k gk

" highlight last inserted text
nnoremap gV `[v`]

" http://emerg3nc3.wordpress.com/2012/07/28/full-256-color-support-for-vim-andor-xterm-on-ubuntu-12-04/
" enable 256 colors in VIM
set t_Co=256

map <leader>e ggg?G<CR>


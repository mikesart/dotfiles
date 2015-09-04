" save file with sudo
" http://www.cyberciti.biz/faq/vim-vi-text-editor-save-file-without-root-permission/
"   :w !sudo tee %
" command! -bar -nargs=0 SudoW :silent exe “write !sudo tee % >/dev/null” | silent edit!

" vimdiff
"  do ; diff obtain from other side
"  dp ; diff put to other side
"  :diffupdate ; rescan files for changes
"  :[range]diffget
"  :[range]diffput
"  ]c ; advance to next diff block
"  [c ; reverse to previous diff block
"  zr ; unfold both files completely

set nocompatible
syntax on

set background=dark

" Use :list command
set listchars=tab:→\ ,trail:·

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

" move vertically by visual line (don't skip over "fake" part of really long
" lines)
nnoremap j gj
nnoremap k gk

" http://emerg3nc3.wordpress.com/2012/07/28/full-256-color-support-for-vim-andor-xterm-on-ubuntu-12-04/
" enable 256 colors in VIM
set t_Co=256

map <leader>e ggg?G<CR>
" map Project.Encrypt<TAB>ggg?G ggg?G<CR>
"   :set wildmenu
"   :source $VIMRUNTIME/menu.vim

"    g Ctrl-G will show number of lines, words and bytes selected.

"    vim faq: http://vimhelp.appspot.com/vim_faq.txt.html
"    fakevim user commands: http://stackoverflow.com/questions/15437559/how-to-set-user-command-in-qt-fakevim
"    fakevim key movement:  https://github.com/hluk/FakeVim
"
"    clipboard: @+
"
"    "* register has clipboard contents
"    "*p ; paste copied text
"
"    use register 2 to insert previously deleted text: diw"2P
"
"    Ctrl-A ; increment number (see nrformats)
"    Ctrl-X ; decrement number
"
"    viwU ; uppercase word
"    viwu ; lowercase word
"
"    :registers ; show registers
"    :history ; show history
"
"    :undo
"    :redo
"
"    yiw
"    viwp
"
"    zt ; align top
"    zz ; align middle
"    zb ; align bottom
"    zc ; close current fold
"    zo ; open current fold
"    za ; toggle current fold
"
"    /\cWORD ; search and ignore case
"    /^\s*$ ; search for blank lines
"
"    = ; indent selection
"    3== ; indent 3 lines
"    =a{ ; indent current block
"
"    :%s/\s\+$// ; delete trailing white space
"
"    g*: highlight subwords (Ie, doesn't do :/\<WORD\>/
"      (doesn't work in slickedit)
"
"    [[
"    ]] ; move to next function
"
"    [{ ; move to start of current block
"    ]} ; move to end of current block
"
"    "kyy ; copy current line into k register
"    "Kyy ; append current line to k register
"    "kp ; paste register k


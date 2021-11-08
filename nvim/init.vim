"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"     ██▒   █▓ ██▓ ███▄ ▄███▓ ██▀███   ▄████▄
"    ▓██░   █▒▓██▒▓██▒▀█▀ ██▒▓██ ▒ ██▒▒██▀ ▀█
"     ▓██  █▒░▒██▒▓██    ▓██░▓██ ░▄█ ▒▒▓█    ▄
"      ▒██ █░░░██░▒██    ▒██ ▒██▀▀█▄  ▒▓▓▄ ▄██▒
"       ▒▀█░  ░██░▒██▒   ░██▒░██▓ ▒██▒▒ ▓███▀ ░
"       ░ ▐░  ░▓  ░ ▒░   ░  ░░ ▒▓ ░▒▓░░ ░▒ ▒  ░
"       ░ ░░   ▒ ░░  ░      ░  ░▒ ░ ▒░  ░  ▒
"         ░░   ▒ ░░      ░     ░░   ░ ░
"          ░   ░         ░      ░     ░ ░
"         ░                           ░
"
" Maintainer: 
"      Simon Hensel 
"      https://github.com/dolanseesu/dotfiles
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Load Plugins using vim-plug
" more info: https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')

" Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'ap/vim-css-color'

Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'

call plug#end()

" General
syntax on
filetype plugin indent on
set encoding=utf-8
set history=500
set nocompatible
set title
set mouse+=a
set ruler
set cursorline

" display whitespaces and other invisible chars
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set nolist

" disable annoying alerts
set noerrorbells
set novisualbell

" adjust tab behaviour and indentation
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set smartindent
set scrolloff=6

" line numbers and wrapping
set number relativenumber
set wrap
set linebreak

" Disable backups and swap files
set noswapfile
set nowb
set nobackup

" adjust search
set nohlsearch
set incsearch
set ignorecase
set smartcase
" this would remap :nohlsearch to the space-key
":nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" show matching brackets
set showmatch

" let backspace behave like it should
set backspace=indent,eol,start

set laststatus=2
set hidden
set noshowmode
set timeoutlen=1000 ttimeoutlen=10

" autocomplete for find
set wildmenu
set wildmode=longest,list:longest,list:full

" set the path to the current dir
set path=.,**

" disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" change split behaviour
set splitbelow splitright

" Optimize shortcuts for split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" disable Q in normal mode
nmap Q <Nop>

" Colors
set termguicolors
set background=dark
colorscheme gruvbox

" modify lightline to show the absolute file path
let g:lightline = { 'colorscheme': 'gruvbox', 
                    \ 'active': {
                    \ 'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'absolutepath', 'modified']],},
                    \ 'component_function': {
                    \ 'gitbranch': 'FugitiveHead'},}

hi Normal guibg=None guifg=None ctermbg=None ctermfg=None
hi CursorLine cterm=bold ctermbg=None ctermfg=None gui=bold guibg=None guifg=None
hi Comment cterm=italic gui=italic

" If more than one window and previous buffer was NERDTree, go back to it
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
" prevent crashed with vim-plug
let g:plug_window = 'noautocmd vertical topleft new'

" Start NERDTree and put the cursor back in the other window.
"autocmd VimEnter * NERDTree | wincmd p
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" Autocomplete HTML/CSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" autocomplete certain characters
"inoremap ( ()<Esc>i
"inoremap { {}<Esc>i
"inoremap {<CR> {<CR>}<Esc>O
"inoremap [ []<Esc>i
"inoremap < <><Esc>i
"inoremap ' ''<Esc>i
"inoremap " ""<Esc>i

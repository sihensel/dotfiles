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

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'ap/vim-css-color'

Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'

" telescope fzf
" external dependencies: fd and ripgrep
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'kyazdani42/nvim-web-devicons'

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
set colorcolumn=79

" display whitespaces and other invisible chars (use set list)
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
set nowritebackup

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

" change some keyboard shortcts
" make Y behave like C and D
nnoremap Y y$
" change search find behaviour
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Change undo behaviour
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" When jumping, mark the last position, so you can jump back with <C-o>
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

" Colors
set termguicolors
set background=dark
colorscheme gruvbox

set statusline^=%{coc#status()}

" modify lightline to show the absolute file path
let g:lightline = { 'colorscheme': 'gruvbox', 
                    \ 'active': {
                    \ 'left': [['mode', 'paste'], ['gitbranch', 'cocstatus', 'readonly', 'absolutepath', 'modified']],},
                    \ 'component_function': {
                    \ 'gitbranch': 'FugitiveHead',
                    \ 'cocstatus': 'coc#status' },}

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()


hi Normal guibg=None guifg=None ctermbg=None ctermfg=None
hi CursorLine cterm=bold ctermbg=None ctermfg=None gui=bold guibg=None guifg=None
hi Comment cterm=italic gui=italic

" NERDTree settings
" If more than one window and previous buffer was NERDTree, go back to it
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
" prevent crashes with vim-plug
let g:plug_window = 'noautocmd vertical topleft new'

" Start NERDTree and put the cursor back in the other window.
"autocmd VimEnter * NERDTree | wincmd p
" Call NERDTree with CTRL-n
nmap <C-n> :NERDTree<cr>
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

" settings for coc.vim
" see https://github.com/neoclide/coc.nvim
set updatetime=300
set shortmess+=c

if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>ft <cmd>lua require('telescope.builtin').help_tags()<cr>

lua << EOF
local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local new_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { " BINARY" })
        end)
      end
    end
  }):sync()
end

local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        buffer_previewer_maker = new_maker,
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        color_devicons = true,

        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,

        mappings = {
            -- use the same mappings as NERDTree
            i = {
                ["<leader>s"] = actions.file_vsplit,
                ["<leader>i"] = actions.file_split
            },
            n = {
                ["<leader>s"] = actions.file_vsplit,
                ["<leader>i"] = actions.file_split
            },

        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}
require('telescope').load_extension('fzy_native')
EOF

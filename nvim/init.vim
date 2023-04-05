""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This config uses the following custom keybinds:
" gcc/gc{Operation}     toggle comment
" K                     show documentation for word under cursor
" <leader>d             show Coc Diagnostics
"
" nvim-tree
" CTRL-n                toggle nvim-tree
" i                     open in split
" s                     open in vsplit
" o                     cd into directory
"
" telescope
" <leader>ff            search for file
" <leader>fg            search for code (live grep)
" <leader>ft            search for tags
" <leader>i             open in split
" <leader>s             open in vsplit
"
" <leader>r             run current file with Jaq
"
" CTRL-b                toggle blamer.nvim
" CTRL-T                toggle a terminal

" " (normal or visual)  show :Registers
" CTRL-R (insert)       show :Registers
" CTRL-K / CTRL-J       move cursor up / down in registers windos
" DEL / BACKSPACE       delete highlighted entry from registers

" VimTex
" <leader>ll            start/stop compiling document
" <leader>lk            stop compiling document
" <leader>lc            clear auxiliary compiler files
" <leader>lv            forward search in compiled document (pdf)
" <leader>le            toggle quickfix window
" <leader>lt            show table of contents for latex document
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Load Plugins using vim-plug
" https://github.com/junegunn/vim-plug
call plug#begin('~/.config/nvim/plugged')

Plug 'numToStr/Comment.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'APZelos/blamer.nvim'
Plug 'tversteeg/registers.nvim'
Plug 'danilamihailov/beacon.nvim'

" File explorer and status line
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'

" Terminal and quickfix window
Plug 'akinsho/toggleterm.nvim'
Plug 'kevinhwang91/nvim-bqf'

" CoC
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'

" Latex
Plug 'lervag/vimtex'
Plug 'anufrievroman/vim-angry-reviewer'

" Telescope fzf
" External dependencies: fd and ripgrep
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Colors/Icons
Plug 'gruvbox-community/gruvbox'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'norcalli/nvim-colorizer.lua'

Plug 'gennaro-tedesco/nvim-jqx'     " requires 'jq' package
Plug 'is0n/jaq-nvim'

call plug#end()


" General
syntax on
autocmd! bufreadpost *.pp set syntax=ruby    " puppet files are ruby code
filetype plugin indent on
set encoding=utf-8
set history=500
set nocompatible
set title
set ruler
set cursorline
set colorcolumn=79
set shell=/bin/zsh
set shellcmdflag=-c

" always yank to system clipboard as well (:h provider-clipboard)
set clipboard+=unnamedplus

" only enable mouse movement in normal mode
set mouse=n
" disable cursor move on mouse click
:nmap <LeftMouse> <nop>
:imap <LeftMouse> <nop>
:vmap <LeftMouse> <nop>
:nmap <2-LeftMouse> <nop>
:imap <2-LeftMouse> <nop>
:vmap <2-LeftMouse> <nop>

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
set wildmode=longest:full,full

" set the path to the current dir
set path=.,**

" disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" change split behaviour
set splitbelow
set splitright
" Optimize shortcuts for split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" disable Q in normal mode
nmap Q <Nop>
" change some keyboard shortcts
nnoremap E ge
nnoremap Y y$
" change search find behaviour
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
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
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==
" search for the current line
nnoremap <leader>/ 0y$/\V<c-r>"<cr>

" Colors
set termguicolors
set background=dark
colorscheme gruvbox

hi Normal guibg=None guifg=None ctermbg=None ctermfg=None
hi CursorLine cterm=bold ctermbg=None ctermfg=None gui=bold guibg=None guifg=None
hi Comment cterm=italic gui=italic

" Disable some warnings for :CheckHealth
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0

" Settings for coc.vim
" https://github.com/neoclide/coc.nvim
set updatetime=300
set shortmess+=c
set signcolumn=yes

hi CocMenuSel cterm=bold ctermfg=239 ctermbg=109 gui=bold guifg=#504945 guibg=#83a598

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1):
    \ <SID>check_back_space() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"
inoremap <silent><expr> <c-space> coc#refresh()

" Use leader + d to show CocDiagnostics location window
nnoremap <silent><leader>d :CocDiagnostics<CR>
nmap <silent>]k <Plug>(coc-diagnostic-prev)
nmap <silent>]j <Plug>(coc-diagnostic-next)
map <silent> gd <Plug>(coc-definition)

" Use K to show documentation in preview window
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

" VimTex settings
let g:vimtex_view_method = 'zathura'

" blamer.nvim settings
nnoremap <C-b> :BlamerToggle<CR>
let g:blamer_enabled = 0
let g:blamer_delay = 500
let g:blamer_show_in_visual_modes = 0
let g:blamer_show_in_insert_modes = 0
let g:blamer_prefix = '  '
let g:blamer_relative_time = 1

" Telescope settings
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>ft <cmd>lua require('telescope.builtin').help_tags()<CR>

lua << EOF
-- {{{ telescope.nvim
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
            i = {
                ["<leader>s"] = actions.file_vsplit,
                ["<leader>i"] = actions.file_split
            },
            n = {
                ["<leader>s"] = actions.file_vsplit,
                ["<leader>i"] = actions.file_split
            },
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim",
            "--hidden"
        }
    },
    pickers = {
        find_files = {
            find_command = { "fd", "--type", "f", "--exclude", "*.git", "--strip-cwd-prefix" },
            hidden = true
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
-- }}} telescope.nvim
EOF

" settings for nvim-tree.lua
nmap <C-n> :NvimTreeToggle<CR>
lua << EOF
-- {{{ nvim-tree.lua
local tree_cb = require'nvim-tree.config'.nvim_tree_callback
require'nvim-tree'.setup {
    git = {
        ignore = false,
    },
    view = {
        mappings = {
            custom_only = true,
            list = {
                -- custom keybinds for nvim-tree
                { key = "<CR>",  cb = tree_cb("edit") },
                { key = "o",     cb = tree_cb("cd") },
                { key = "s",     cb = tree_cb("vsplit") },
                { key = "i",     cb = tree_cb("split") },
                { key = "<",     cb = tree_cb("prev_sibling") },
                { key = ">",     cb = tree_cb("next_sibling") },
                { key = "<Tab>", cb = tree_cb("preview") },
                { key = "K",     cb = tree_cb("first_sibling") },
                { key = "J",     cb = tree_cb("last_sibling") },
                { key = "<C-i>", cb = tree_cb("toggle_ignored") },
                { key = "<C-h>", cb = tree_cb("toggle_dotfiles") },
                { key = "R",     cb = tree_cb("refresh") },
                { key = "a",     cb = tree_cb("create") },
                { key = "d",     cb = tree_cb("remove") },
                { key = "r",     cb = tree_cb("rename") },
            },
        },
    },
    renderer = {
        group_empty = true,
        special_files = { 'README.md', 'LICENSE' },
        indent_markers = {
            enable = true
        },
        icons = {
            webdev_colors = true,
            glyphs = {
                symlink = '',
                git = {
                    unstaged  = "",
                    staged    = "✓",
                    unmerged  = "",
                    renamed   = " ",
                    untracked = "",
                    deleted   = "",
                    ignored   = "◌"
                },
                folder = {
                    arrow_open   = "",
                    arrow_closed = "",
                    default      = "",
                    open         = "",
                    empty        = "",
                    empty_open   = "",
                    symlink      = "",
                    symlink_open = "",
                }
            }
        }
    }
}
-- }}} nvim-tree.lua

-- {{{ lualine
require'lualine'.setup {
    options = {
        theme = 'gruvbox',
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'g:coc_status'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    extensions = {'nvim-tree'}
}
-- }}} lualine

-- {{{ nvim-colorizer
require'colorizer'.setup()
-- }}} nvim-colorizer

-- {{{ Comment.nvim
require('Comment').setup {
    ignore = "^$"   -- ignore empty lines
}
-- }}} Comment.nvim

-- {{{ toggleterm
require("toggleterm").setup{
    size = 18,
    open_mapping = [[<c-t>]],
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    close_on_exit = true,
    direction = 'horizontal'
}
-- }}} toggleterm

-- {{{ registers
require("registers").setup({
    show_empty = false,
    window = {
        max_width = 79,
        highlight_cursorline = true,
        border = "none",
        transparency = 0
    }
})
-- }}} registers
EOF

nnoremap <leader>r :Jaq<CR>
lua << EOF
-- {{{ jaq-nvim
require('jaq-nvim').setup{
    cmds = {
        internal = {  -- vim commands
            lua = "luafile %",
            vim = "source %"
        },
        external = {  -- shell commands
            python   = "python3 %",
            c        = "gcc % -o $fileBase && ./$fileBase",
            sh       = "sh %",
            lua      = "lua %",
            tex      = "make"
        }
    },
    behavior = {
        default     = "bang",
        startinsert = false,
        autosave    = false,
        wincmd      = false
    }
}
-- }}} jaq-nvim
EOF

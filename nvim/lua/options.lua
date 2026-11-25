-- aliases
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt


-- general settings
g.mapleader = "\\"
g.maplocalleader = "\\"
opt.syntax = 'off'
opt.history = 500
opt.title = true
opt.signcolumn = 'yes'
opt.shell = '/bin/zsh'
opt.shellcmdflag = '-c'

-- disable netrw for nvim-tree
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- filetype
opt.filetype = 'on'
cmd 'autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o'

-- treat all Latex files as the 'tex' filetype, instead of 'plaintex'
g.tex_flavor = 'latex'

-- always yank to system clipboard as well (see :h provider-clipboard)
opt.clipboard:append('unnamedplus')
opt.shortmess:append('c')

-- colors
opt.termguicolors = true
opt.background = 'dark'
opt.winborder = 'rounded'

-- disable mouse movement entirely
opt.mouse = ''

-- cursorline
opt.cursorline = true
opt.cursorlineopt = 'screenline,number'

-- display whitespaces and other invisible chars (use ':set list' to enable)
opt.listchars = 'eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣'
opt.list = false
-- hide end-of-buffer characters
opt.fillchars = {eob = " "}

-- adjust tab behavior and indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smarttab = true
opt.smartindent = true
opt.scrolloff = 6

-- line numbers and wrapping
opt.number = true
opt.wrap = true
opt.linebreak = true

-- disable annoying alerts
opt.errorbells = false
opt.visualbell = false

-- disable backups and swap files
opt.swapfile = false
opt.wb = false
opt.backup = false
opt.writebackup = false

-- adjust search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- show matching brackets
opt.showmatch = true

-- let backspace behave like it should
opt.backspace = 'indent,eol,start'

opt.laststatus = 3
opt.hidden = true
opt.showmode = false
opt.timeoutlen = 750

-- autocomplete for find
opt.wildmenu = true
opt.wildmode = 'longest:full,full'

-- set the path to the current dir
opt.path = '.,**3'

-- change split behavior
opt.splitbelow = true
opt.splitright = true

-- disable folds
opt.foldenable = false

-- adjust LSP diagnostics
vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = false,
    virtual_lines = false,
    signs = {
        text = {
            -- empty text disables signcolumn symbols
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
        },
        numhl = {
            -- custom highlight group defined in plugins.lua
            [vim.diagnostic.severity.ERROR] = 'DiagNumError',
            [vim.diagnostic.severity.WARN] = 'DiagNumWarn',
            [vim.diagnostic.severity.INFO] = 'DiagNumInfo',
            [vim.diagnostic.severity.HINT] = 'DiagNumHint',
        },
    },
})

-- treat vim as a global to avoid LSP warnings when editing nvim config files
vim.lsp.config('lua_ls', { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } })

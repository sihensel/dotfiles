-------------------------------------------------------------------------------
-- VIM OPTIONS
-------------------------------------------------------------------------------

-- aliases
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt


-- general settings
g.mapleader = "\\"
g.maplocalleader = "\\"
opt.syntax = 'off'
opt.encoding = 'utf-8'
opt.history = 500
opt.compatible = false
opt.title = true
opt.colorcolumn = '79'
opt.signcolumn = 'yes'
opt.shell = '/bin/zsh'
opt.shellcmdflag = '-c'

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

-- only enable mouse movement in normal mode
opt.mouse = ''

-- cursorline
opt.cursorline = true
opt.cursorlineopt = 'screenline,number'
-- show cursorline in normal mode
local cursorline_group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "ModeChanged" }, {
    group = cursorline_group,
    callback = function()
        if vim.api.nvim_get_mode().mode == "n" then
            vim.opt_local.cursorlineopt = { "screenline", "number" }
        end
    end,
})
-- only show cursorline on the number row in insert and visual mode
vim.api.nvim_create_autocmd({ "InsertEnter", "ModeChanged" }, {
    group = cursorline_group,
    callback = function()
        if vim.api.nvim_get_mode().mode:match("^[ivV\22]") then
            vim.opt_local.cursorlineopt = { "number" }
        end
    end,
})

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
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- show matching brackets
opt.showmatch = true

-- let backspace behave like it should
opt.backspace = 'indent,eol,start'

opt.laststatus = 2
opt.hidden = true
opt.showmode = false
opt.timeoutlen = 1000
opt.ttimeoutlen = 10

-- autocomplete for find
opt.wildmenu = true
opt.wildmode = 'longest:full,full'

-- set the path to the current dir
opt.path = '.,**'

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
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '󰙎',
        },
    },
})

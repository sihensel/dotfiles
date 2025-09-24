-------------------------------------------------------------------------------
-- VIM OPTIONS
-------------------------------------------------------------------------------

-- Aliases
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt


-- General settings
g.mapleader      = "\\"
g.maplocalleader = "\\"
opt.syntax       = 'off'
opt.encoding     = 'utf-8'
opt.history      = 500
opt.compatible   = false
opt.title        = true
opt.cursorline   = true
opt.colorcolumn  = '79'
opt.signcolumn   = 'yes'
opt.shell        = '/bin/zsh'
opt.shellcmdflag = '-c'

-- Filetype
opt.filetype = 'on'
cmd 'autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o'

-- Always yank to system clipboard as well (see :h provider-clipboard)
opt.clipboard:append('unnamedplus')
opt.shortmess:append('c')

-- Colors
opt.termguicolors = true
opt.background = 'dark'
opt.winborder = 'rounded'

-- Only enable mouse movement in normal mode
opt.mouse = ''

-- Display whitespaces and other invisible chars (use ':set list' to enable)
opt.listchars = 'eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣'
opt.list      = false

-- Adjust tab behavior and indentation
opt.tabstop     = 4
opt.softtabstop = 4
opt.shiftwidth  = 4
opt.expandtab   = true
opt.smarttab    = true
opt.smartindent = true
opt.scrolloff   = 6

-- Line numbers and wrapping
opt.number         = true
-- opt.relativenumber = true
opt.wrap           = true
opt.linebreak      = true

-- Disable annoying alerts
opt.errorbells = false
opt.visualbell = false

-- Disable backups and swap files
opt.swapfile    = false
opt.wb          = false
opt.backup      = false
opt.writebackup = false

-- Adjust search
opt.hlsearch   = false
opt.incsearch  = true
opt.ignorecase = true
opt.smartcase  = true

-- Show matching brackets
opt.showmatch = true

-- Let backspace behave like it should
opt.backspace = 'indent,eol,start'

opt.laststatus  = 2
opt.hidden      = true
opt.showmode    = false
opt.timeoutlen  = 1000
opt.ttimeoutlen = 10

-- Autocomplete for find
opt.wildmenu = true
opt.wildmode = 'longest:full,full'

-- Set the path to the current dir
opt.path = '.,**'

-- Change split behavior
opt.splitbelow = true
opt.splitright = true

-- Disable some warnings for :checkhealth
g.loaded_ruby_provider = false
g.loaded_node_provider = false
g.loaded_perl_provider = false

-- Adjust LSP diagnostics
vim.diagnostic.config({
    underline        = true,
    update_in_insert = false,
    virtual_text     = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN]  = '',
            [vim.diagnostic.severity.HINT]  = '',
            [vim.diagnostic.severity.INFO]  = '󰙎',
        },
    },
})

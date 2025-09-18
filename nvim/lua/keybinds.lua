-------------------------------------------------------------------------------
-- KEY BINDINGS
-------------------------------------------------------------------------------

-- Create mapper function that mimic vim's noremap
local get_mapper = function(mode, noremap)
    return function(lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = noremap
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

-- Aliases
local noremap  = get_mapper("n", false)
local nnoremap = get_mapper("n", true)
local inoremap = get_mapper("i", true)
local tnoremap = get_mapper("t", true)
local vnoremap = get_mapper("v", true)


-- LSP-specific Keymaps
nnoremap("K",         vim.lsp.buf.hover)
nnoremap("gd",        vim.lsp.buf.definition)
nnoremap("gd",        vim.lsp.buf.declaration)
nnoremap("<leader>d", vim.diagnostic.setloclist)

-- Disable cursor move on mouse click
nnoremap('<LeftMouse>',   '<nop>')
inoremap('<LeftMouse>',   '<nop>')
vnoremap('<LeftMouse>',   '<nop>')
nnoremap('<2-LeftMouse>', '<nop>')
vnoremap('<2-LeftMouse>', '<nop>')
inoremap('<2-LeftMouse>', '<nop>')

-- Optimize shortcuts for split navigation
nnoremap('<C-h>', '<C-w>h')
nnoremap('<C-j>', '<C-w>j')
nnoremap('<C-k>', '<C-w>k')
nnoremap('<C-l>', '<C-w>l')

-- Disable Q in normal mode
nnoremap('Q', '<nop>')

-- change some keyboard shortcts
nnoremap('E', 'ge')
nnoremap('Y', 'y$')

-- Change search find behavior
nnoremap('n', 'nzzzv')
nnoremap('N', 'Nzzzv')
nnoremap('*', '*zzzv')
nnoremap('#', '#zzzv')
nnoremap('J', 'mzJ`z')

-- Change undo behavior
inoremap(',', ',<c-g>u')
inoremap('.', '.<c-g>u')
inoremap('!', '!<c-g>u')
inoremap('?', '?<c-g>u')

-- Moving text
nnoremap('<leader>j', ':m .+1<CR>==')
nnoremap('<leader>k', ':m .-2<CR>==')
vnoremap('J',         ":m '>+1<CR>gv=gv")
vnoremap('K',         ":m '<-2<CR>gv=gv")
inoremap('<C-j>',     '<esc>:m .+1<CR>==')
inoremap('<C-k>',     '<esc>:m .-2<CR>==')

-- Search for the current line
nnoremap('<leader>/', '0y$/\\V<c-r>"<cr>')

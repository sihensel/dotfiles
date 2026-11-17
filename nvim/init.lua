-------------------------------------------------------------------------------
-- This config uses the following custom keybinds:

-- LSP ------------------------------------------------------------------------
-- K                        show documentation for word under cursor
-- <leader>d                show LSP diagnostics

-- Nvim-Tree ------------------------------------------------------------------
-- CTRL-n                   toggle nvim-tree
-- s                        open file in split
-- v                        open file in vsplit
-- o                        cd into directory

-- Telescope ------------------------------------------------------------------
-- <leader>ff               search for file
-- <leader>fg               search for code (live grep)
-- <leader>ft               search for tags
-- <leader>fs               open spell recommendations
-- <leader>s                open selected entry in split
-- <leader>v                open selected entry in vsplit

-- Misc -----------------------------------------------------------------------
-- <leader>r                run current file with code_runner.nvim
-- <leader>q                close code runner window
-- CTRL-d                   show deleted lines
-- CTRL-b                   show git blame in a pop-up window
-- CTRL-t                   toggle a terminal
-- gcc/gc{<Movement>}       toggle comment
-- <leader>b                open current file in browser (librewolf)
-------------------------------------------------------------------------------

require("options")
require("keybinds")
require("plugins")

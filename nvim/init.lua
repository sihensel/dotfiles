-------------------------------------------------------------------------------
-- This config uses the following custom keybinds:

-- LSP ------------------------------------------------------------------------
-- K                        show documentation for word under cursor
-- <leader>d                show LSP diagnostics

-- Nvim-Tree ------------------------------------------------------------------
-- CTRL-n                   toggle nvim-tree
-- i                        open file in split
-- s                        open file in vsplit
-- o                        cd into directory

-- Telescope ------------------------------------------------------------------
-- <leader>ff               search for file
-- <leader>fg               search for code (live grep)
-- <leader>ft               search for tags
-- <leader>i                open in split
-- <leader>s                open in vsplit

-- Registers ------------------------------------------------------------------
-- " (normal or visual)     show :Registers
-- CTRL-R (insert)          show :Registers
-- CTRL-K / CTRL-J          move cursor up / down in registers windos
-- DEL / BACKSPACE          delete highlighted entry from registers

-- Misc -----------------------------------------------------------------------
-- <leader>r                run current file with Jaq
-- CTRL-b                   show Neogit
-- CTRL-d                   show git diff
-- CTRL-t                   toggle a terminal
-- gcc/gc{<Movement>}       toggle comment
-------------------------------------------------------------------------------

require("options")
require("keybinds")
require("plugins")

-------------------------------------------------------------------------------
-- PLUGINS AND CONFIGS
-------------------------------------------------------------------------------

-- Aliases
local get_mapper = function(mode, noremap)
    return function(lhs, rhs, opts)
        opts = opts or {}
        opts.noremap = noremap
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end
local nnoremap = get_mapper("n", true)


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


-- Load Plugins
return require("lazy").setup({
    -- {{{ Colors
    {
        "gruvbox-community/gruvbox",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme gruvbox]])
            vim.opt.termguicolors = true
            vim.opt.background    = 'dark'
            vim.api.nvim_set_hl(0, 'Normal',     { ctermbg = 0, ctermfg=0 })
            vim.api.nvim_set_hl(0, 'Cursorline', { ctermbg = 0, ctermfg = 0, bold = true })
            vim.api.nvim_set_hl(0, 'Comment',    { italic = true, fg = "#928374" })
        end
    },
    {
        -- Colorscheme
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = {
                    "c",
                    "lua",
                    "python",
                    "yaml",
                    "json",
                    "bash",
                    "css",
                    "html",
                    "bibtex",
                    "latex",
                    "diff",
                    -- "ssh_config",
                },
                sync_install = false,
                auto_install = false,

                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                    disable = {"gitcommit", "diff", "markdown"}
                }
            }
        end
    },
    {
        "norcalli/nvim-colorizer.lua",
        event = "VeryLazy",
        config = function()
            require'colorizer'.setup()
        end
    },
    -- }}} Colors

    -- {{{ UI
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        config = function()
            require'nvim-web-devicons'.setup()
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
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
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
        },
        config = function()
            local function on_attach(bufnr)
                local api = require('nvim-tree.api')

                local function opts(desc)
                    return {
                        desc = 'nvim-tree: ' .. desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true
                    }
                end

                vim.keymap.set('n', '<CR>',  api.node.open.edit,              opts('Open'))
                vim.keymap.set('n', 'o',     api.tree.change_root_to_node,    opts('CD'))
                vim.keymap.set('n', 's',     api.node.open.vertical,          opts('Open: Vertical Split'))
                vim.keymap.set('n', 'i',     api.node.open.horizontal,        opts('Open: Horizontal Split'))
                vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,  opts('Previous Sibling'))
                vim.keymap.set('n', '>',     api.node.navigate.sibling.next,  opts('Next Sibling'))
                vim.keymap.set('n', '<Tab>', api.node.open.preview,           opts('Open Preview'))
                vim.keymap.set('n', 'K',     api.node.navigate.sibling.first, opts('First Sibling'))
                vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,  opts('Last Sibling'))
                vim.keymap.set('n', '<C-h>', api.tree.toggle_hidden_filter,   opts('Toggle Dotfiles'))
                vim.keymap.set('n', 'R',     api.tree.reload,                 opts('Refresh'))
                vim.keymap.set('n', 'a',     api.fs.create,                   opts('Create'))
                vim.keymap.set('n', 'd',     api.fs.remove,                   opts('Delete'))
                vim.keymap.set('n', 'r',     api.fs.rename,                   opts('Rename'))
            end

            require'nvim-tree'.setup {
                on_attach = on_attach,
                git = {
                    ignore = false,
                },
                view = {
                    width = 40
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

        end

    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        config = function()
            require("ibl").setup({
                indent = {
                    char = "┃"
                }
            })
        end
    },
    -- }}} UI

    -- {{{ Telescope
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make"
			}
        },
        config = function()
            local builtin = require('telescope.builtin')
            nnoremap('<leader>ff', builtin.find_files, {})
            nnoremap('<leader>fg', builtin.live_grep, {})
            nnoremap('<leader>ft', builtin.help_tags, {})

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
                            -- Write a hint to the buffer in case of binary files
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
                        find_command = {
                            "fd",
                            "--type", "f",
                            "--exclude",
                            "*.git",
                            "--strip-cwd-prefix"
                        },
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
            require('telescope').load_extension('fzf')
        end
    },
    -- }}} Telescope

    -- {{{ Functional
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require('Comment').setup {
                ignore = "^$"   -- Ignore empty lines
            }
        end
    },
    {
        "akinsho/toggleterm.nvim",
        cmd = "ToggleTerm",
        keys = {
            { "<C-t>", "<cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },
        },
        config = function()
            require("toggleterm").setup {
                size              = 18,
                open_mapping      = [[<c-t>]],
                start_in_insert   = true,
                insert_mappings   = true,
                terminal_mappings = true,
                persist_size      = true,
                close_on_exit     = true,
                direction         = 'horizontal'
            }
        end
    },
    {
        "is0n/jaq-nvim",
        cmd = "Jaq",
        keys = {
            { "<leader>r", "<cmd>Jaq<CR>", desc = "Run file with Jaq" },
        },
        config = function()
            require('jaq-nvim').setup{
                cmds = {
                    internal = {  -- Vim commands
                    lua = "luafile %",
                    vim = "source %"
                },
                external = {  -- Shell commands
                    python = "python3 %",
                    c      = "gcc % -o $fileBase && ./$fileBase",
                    sh     = "sh %",
                    lua    = "lua %",
                    tex    = "make"
                }
            },
            behavior = {
                default     = "bang",
                startinsert = false,
                autosave    = false,
                wincmd      = false
            }
        }
    end
    },
    {
        "tversteeg/registers.nvim",
        lazy = false,
        config = function()
            require("registers").setup({
                show_empty = false,
                window = {
                    max_width            = 79,
                    highlight_cursorline = true,
                    border               = "none",
                    transparency         = 7
                }
            })
        end
    },
    {
        "NeogitOrg/neogit",
        cmd = "Neogit",
        keys = {
            { "<C-b>", "<cmd>Neogit<CR>", desc = "Launch Neogit split" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        },
        config = function()
            -- Override the default highlight groups
            vim.api.nvim_set_hl(0, 'NeogitDiffAdd',             { bg = 0, fg="#b8bb26" })
            vim.api.nvim_set_hl(0, 'NeogitDiffAddHighlight',    { bg = 0, fg="#b8bb26" })
            vim.api.nvim_set_hl(0, 'NeogitDiffDelete',          { bg = 0, fg="#fb4934" })
            vim.api.nvim_set_hl(0, 'NeogitDiffDeleteHighlight', { bg = 0, fg="#fb4934" })

            require("neogit").setup({
                kind = "split",
            })
        end,
    },
    -- }}} Functional

    -- {{{ Misc
    {
        "danilamihailov/beacon.nvim",
        event = "VeryLazy"
    },
    {
        "kevinhwang91/nvim-bqf",
        event = "VeryLazy"
    },
    {
        -- Requires 'jq' package
        "gennaro-tedesco/nvim-jqx",
        event = "VeryLazy"
    },
    {
        "anufrievroman/vim-angry-reviewer",
        cmd = "AngryReviewer",
        config = function()
            vim.g.AngryReviewerEnglish = 'american'
        end
    },
    -- }}} Misc

    -- {{{ LSP config
    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "L3MON4D3/LuaSnip",
        },
        event = "VeryLazy",
        config = function()
            require("mason").setup({
                PATH = "append",    -- Prefer system installed language servers
            })
            require("mason-lspconfig").setup({
                ensure_installed = {
                    -- :help lspconfig-all
                    "bashls",
                    "clangd",
                    "lua_ls",
                    "pyright",
                    "texlab",
                },
                handlers = {
                    require("lsp-zero").default_setup,
                },
            })

            -- Adjust diagnostic text in signcolumn
            vim.fn.sign_define("DiagnosticSignError", {
                texthl = "DiagnosticSignError",
                text = "",
                numhl = "DiagnosticSignError"
            })
            vim.fn.sign_define("DiagnosticSignWarn", {
                texthl = "DiagnosticSignWarn",
                text = "",
                numhl = "DiagnosticSignWarn"
            })
            vim.fn.sign_define("DiagnosticSignHint", {
                texthl = "DiagnosticSignHint",
                text = "",
                numhl = "DiagnosticSignHint"
            })
            vim.fn.sign_define("DiagnosticSignInfo", {
                texthl = "DiagnosticSignInfo",
                text = "󰙎",
                numhl = "DiagnosticSignInfo"
            })

            -- Adjust diagnostics
            vim.diagnostic.config({
                underline = true,
                virtual_text = false,
                signs = true,
                update_in_insert = false,
            })

            vim.cmd("filetype detect")

            local cmp = require("cmp")
            local cmp_action = require("lsp-zero").cmp_action()

            -- Autocompletion
            cmp.setup({
                sources = {
                    { name = "buffer"},
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm(),
                    ["<Tab>"] = cmp_action.luasnip_supertab(),
                    ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
                }),
            })

            -- LSP keybinds
            require("lsp-zero").on_attach(function(client, bufnr)
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist, opts)
            end)

            -- Config each LSP server
            require("lspconfig").bashls.setup {}
            require("lspconfig").clangd.setup {}

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
            require'lspconfig'.lua_ls.setup {
                on_init = function(client)
                    local path = client.workspace_folders[1].name
                    if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
                        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT'
                                },
                                workspace = {
                                    checkThirdParty = false,
                                    library = {
                                        vim.env.VIMRUNTIME
                                    }
                                }
                            }
                        })

                        client.notify(
                            "workspace/didChangeConfiguration",
                            {settings = client.config.settings}
                        )
                    end
                    return true
                end
            }
            require("lspconfig").pyright.setup {}
            require("lspconfig").texlab.setup {}
        end
    }
    -- }}} LSP config
})

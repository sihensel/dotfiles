-------------------------------------------------------------------------------
-- PLUGINS AND CONFIGS
-------------------------------------------------------------------------------

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


-- Enable ansible language server for all yaml files
vim.lsp.config.ansiblels = {
    filetypes = {"yaml"}
}


-- Define plugins
local plugin_spec = {

    -- {{{ Colors
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            contrast = "soft",
            transparent_mode = true
        },
        config = function()
            vim.cmd([[colorscheme gruvbox]])
            vim.opt.termguicolors = true
            vim.api.nvim_set_hl(0, 'Normal',     { ctermbg = 0, ctermfg=0 })
            vim.api.nvim_set_hl(0, 'Cursorline', { ctermbg = 0, ctermfg = 0, bold = true })
        end
    },
    {
        -- also see https://github.com/Corn207/ts-query-loader.nvim
        'MeanderingProgrammer/treesitter-modules.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', branch = "main" },
        opts = {
            ensure_installed = {
                "comment",
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
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                disable = {"gitcommit", "diff"},
            }
        }
    },
    {
        "norcalli/nvim-colorizer.lua",
        event = "VeryLazy",
        config = function()
            require('colorizer').setup()
        end
    },
    -- }}} Colors

    -- {{{ UI
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            theme = 'gruvbox',
            extensions = {'nvim-tree'},
        },
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
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
    {
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufRead",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			event = "BufRead",
		},
		opts = {},
	},
    -- }}} UI

    -- {{{ Telescope
    {
        "nvim-telescope/telescope.nvim",
        version = false,
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make"
			}
        },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Telescope find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Telescope live greap" },
            { "<leader>fr", "<cmd>Telescope registers<CR>", desc = "Telescope show registers" },
        },
        config = function()
            local actions = require('telescope.actions')
            require('telescope').setup {
                defaults = {
                    color_devicons = true,
                    mappings = {
                        n = {
                            ["<leader>s"] = actions.file_vsplit,
                            ["<leader>i"] = actions.file_split,
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
                        "--hidden",
                        "--sort=path",
                        -- ignore everything in the .git directory
                        "-g",
                        "!.git/",
                        -- ignore snmp config files
                        "-g",
                        "!*snmp*",
                        -- ignore grafana dashboards
                        "-g",
                        "!*dashboards*"
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
        "akinsho/toggleterm.nvim",
        cmd = "ToggleTerm",
        keys = {
            { "<C-t>", "<cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },
        },
        opts = {
            size              = 18,
            open_mapping      = [[<c-t>]],
            direction         = 'horizontal',
        },
    },
    {
        "is0n/jaq-nvim",
        cmd = "Jaq",
        keys = {
            { "<leader>r", "<cmd>Jaq<CR>", desc = "Run file with Jaq" },
        },
        opts = {
            cmds = {
                -- Vim commands
                internal = {
                    lua = "luafile %",
                    vim = "source %",
                },
                -- Shell commands
                external = {
                    python = "python3 %",
                    c      = "gcc % -o $fileBase && ./$fileBase",
                    sh     = "sh %",
                    lua    = "lua %",
                    tex    = "make",
                }
            },
            behavior = {
                default     = "bang",
                startinsert = false,
                autosave    = false,
                wincmd      = false,
            },
        },
    },
    -- }}} Functional

    -- {{{ Git
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            attach_to_untracked = false,
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns
                local opts = { buffer = buffer }
                vim.keymap.set("n", "<C-d>", gs.toggle_deleted,                        opts)
                vim.keymap.set("n", "<C-b>", function() gs.blame_line{full=false} end, opts)
            end
        },
    },
    -- }}} Git

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
        "anufrievroman/vim-angry-reviewer",
        cmd = "AngryReviewer",
        init = function()
            vim.g.AngryReviewerEnglish = 'american'
        end
    },
    -- }}} Misc

    -- {{{ LSP config
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            {
                "mason-org/mason.nvim",
                opts = {
                    PATH = "append",
                }
            },
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                -- :help lspconfig-all
                "ansiblels",
                "bashls",
                "clangd",
                "gopls",
                "lua_ls",
                "pyright",
                "texlab",
            },
        },
    },
    {
        -- Autocomplete
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        opts = {
            keymap = {
                preset = 'default',
                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
                ['<Enter>'] = { 'accept', 'fallback' },
            },
            completion = {
                trigger = {
                    show_on_backspace = true,
                },
                menu = {
                    max_height = 20,
                },
                documentation = {
                    auto_show = true,
                },
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    },
                },
            },
        },
    },
    -- }}} LSP config
}

-- Load Plugins
return require("lazy").setup({
    spec = plugin_spec,
})

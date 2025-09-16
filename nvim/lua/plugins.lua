-------------------------------------------------------------------------------
-- PLUGINS AND CONFIGS
-------------------------------------------------------------------------------

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
        build = ":TSUpdate",
        config = function()
            require'nvim-treesitter.configs'.setup {
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
                    disable = {"gitcommit", "diff", "markdown"},
                }
            }
            -- Disable the color flash for errortext
            vim.api.nvim_set_hl(0, "@error", { link = "Identifier" })
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
                    icons_enabled = true,
                    theme = 'gruvbox',
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'lsp_status'},
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
            vim.keymap.set('n', '<leader>ff', function() builtin.find_files() end)
            vim.keymap.set('n', '<leader>fg', function() builtin.live_grep() end)
            vim.keymap.set('n', '<leader>ft', function() builtin.help_tags() end)

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
    -- }}} Functional

    -- {{{ Git
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            require('gitsigns').setup {
                attach_to_untracked = false,
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local opts = { buffer = bufnr }
                    vim.keymap.set("n", "<C-d>", gs.toggle_deleted,                        opts)
                    vim.keymap.set("n", "<C-b>", function() gs.blame_line{full=false} end, opts)
                end
            }
        end
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
                    "ansiblels",
                    "bashls",
                    "clangd",
                    "gopls",
                    "lua_ls",
                    "pyright",
                    "texlab",
                },
                handlers = {
                    require("lsp-zero").default_setup,
                }
            })

            -- Adjust diagnostics
            vim.diagnostic.config({
                underline        = true,
                virtual_text     = false,
                update_in_insert = false,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '',
                        [vim.diagnostic.severity.WARN] = '',
                        [vim.diagnostic.severity.HINT] = '',
                        [vim.diagnostic.severity.INFO] = '󰙎',
                },
              },
            })

            vim.cmd("filetype detect")

            local cmp = require("cmp")
            local cmp_action = require("lsp-zero").cmp_action()

            -- Autocompletion
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                },
                confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"]    = cmp.mapping.confirm(),
                    ["<Tab>"]   = cmp_action.luasnip_supertab(),
                    ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
                })
            })

            -- LSP keybinds
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "K",         vim.lsp.buf.hover,         opts)
                vim.keymap.set("n", "gd",        vim.lsp.buf.definition,    opts)
                vim.keymap.set("n", "gD",        vim.lsp.buf.declaration,   opts)
                vim.keymap.set("n", "gR",        vim.lsp.buf.rename,        opts)
                vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist, opts)
            end

            local capabilities = require("cmp_nvim_lsp").default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )

            -- Config for each LSP server
            local lspconfig = require("lspconfig")

            lspconfig.ansiblels.setup{
                on_attach = on_attach,
                capabilities = capabilities,
                filetypes = { "yaml", "ansible.yaml" }
            }
            lspconfig.bashls.setup {
                on_attach = on_attach,
                capabilities = capabilities
            }
            lspconfig.clangd.setup {
                on_attach = on_attach,
                capabilities = capabilities
            }
            lspconfig.gopls.setup {
                on_attach = on_attach,
                capabilities = capabilities
            }

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
            lspconfig.lua_ls.setup {
                on_attach = on_attach,
                capabilities = capabilities,
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

                        client:notify(
                            "workspace/didChangeConfiguration",
                            {settings = client.config.settings}
                        )
                    end
                    return true
                end
            }
            lspconfig.pyright.setup {
                on_attach = on_attach,
                capabilities = capabilities
            }
            lspconfig.texlab.setup {
                on_attach = on_attach,
                capabilities = capabilities
            }
        end
    }
    -- }}} LSP config
})

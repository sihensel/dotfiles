-------------------------------------------------------------------------------
-- PLUGINS AND CONFIGS
-------------------------------------------------------------------------------

-- bootstrap lazy.nvim
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


-- define plugins
local plugin_spec = {

    -- {{{ colors
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                italic = {
                    strings = false,
                },
                contrast = "hard",
                transparent_mode = true,
                overrides = {
                    CursorLine = { bg = "#282828" },
                    CursorLineNr = { bold = true },
                    DiagnosticUnderlineError = { underdotted = true, sp = "#fb4934" },
                    DiagnosticUnderlineWarn = { underdotted = true, sp = "#fabd2f" },
                    DiagnosticUnderlineInfo = { underdotted = true, sp = "#83a598" },
                    DiagnosticUnderlineHint = { underdotted = true, sp = "#83c07c" },
                    DiagnosticUnderlineOk = { underdotted = true, sp = "#b8bb26" },
                },
            })
            vim.cmd([[colorscheme gruvbox]])
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            -- from https://github.com/MeanderingProgrammer/treesitter-modules.nvim
            require('nvim-treesitter').install({
                "bash",
                "c",
                "cmake",
                "comment",
                "diff",
                "dockerfile",
                "go",
                "helm",
                "ini",
                "jinja",
                "jinja_inline",
                "json",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "mermaid",
                "python",
                "rasi",
                "regex",
                "terraform",
                "xml",
                "yaml",
                "zsh",
            })
            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('treesitter.setup', {}),
                callback = function(args)
                    local buf = args.buf
                    local filetype = args.match

                    -- you need some mechanism to avoid running on buffers that do not
                    -- correspond to a language (like oil.nvim buffers), this implementation
                    -- checks if a parser exists for the current language
                    local language = vim.treesitter.language.get_lang(filetype) or filetype
                    if not vim.treesitter.language.add(language) then
                        return
                    end

                    -- enable highlighting
                    vim.treesitter.start(buf, language)

                    -- enable indenting
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
    {
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = {
            options = {
                parsers = {
                    names = {
                        enable = false,
                    },
                },
            },
        },
    },
    -- }}} colors

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
            local function nvim_tree_on_attach(bufnr)
                local api = require "nvim-tree.api"

                local function opts(desc)
                    return {
                        desc = "nvim-tree: " .. desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true
                    }
                end

                -- default mappings
                api.map.on_attach.default(bufnr)

                -- custom mappings
                vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
                vim.keymap.set('n', 'o', api.tree.change_root_to_node, opts('CD'))
                vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split'))
                vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
                vim.keymap.set('n', '<C-h>', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
                vim.keymap.set('n', '<C-r>', api.tree.reload, opts('Refresh'))
                vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
                vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
                vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
            end
            require'nvim-tree'.setup {
                on_attach = nvim_tree_on_attach,
                git = {
                    ignore = false,
                },
                view = {
                    width = 45,
                },
                renderer = {
                    group_empty = true,
                    special_files = {
                        'README.md',
                        'Makefile',
                        'Dockerfile'
                    },
                    indent_markers = {
                        enable = true
                    },
                },
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
                },
                scope = {
                    show_start = false,
                    show_end = false
                },
            })
        end
    },
    -- }}} UI

    -- {{{ telescope
    {
        "nvim-telescope/telescope.nvim",
        version = false,
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			}
        },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Telescope find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Telescope live grep" },
            { "<leader>fr", "<cmd>Telescope registers<CR>", desc = "Telescope show registers" },
            { "<leader>fs", "<cmd>Telescope spell_suggest<CR>", desc = "Telescope show spelling suggestions" },
        },
        config = function()
            local actions = require('telescope.actions')
            require('telescope').setup {
                defaults = {
                    color_devicons = true,
                    mappings = {
                        n = {
                            ["<leader>s"] = actions.file_split,
                            ["<leader>v"] = actions.file_vsplit,
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
                        "!**/config-generator/mibs/**",
                        -- ignore grafana dashboards
                        "-g",
                        "!*dashboards*",
                    }
                },
                pickers = {
                    find_files = {
                        find_command = {
                            "fd",
                            "--type", "f",
                            "--exclude",
                            "*.git",
                            "--strip-cwd-prefix",
                        },
                        hidden = true,
                    }
                },
                extensions = {
                    fzy_native = {
                        override_generic_sorter = false,
                        override_file_sorter = true,
                    },
                },
            }
            require('telescope').load_extension('fzf')
        end
    },
    -- }}} telescope

    -- {{{ functional
    {
        'CRAG666/betterTerm.nvim',
        keys = {
            {
                mode = { 'n', 't' },
                '<C-t>',
                function()
                    require('betterTerm').toggle_termwindow()
                end,
                desc = 'Toggle Terminal',
            },
        },
        opts = {
            display = 'float',
            float_config = {
                width = 0.8,
                height = 0.8,
                border = 'rounded',
            },
            show_tabs = false,
            new_tab_mapping = 'C-;',    -- effectively disables the keybind
            index_base = 1,
        },
    },
    {
        "CRAG666/code_runner.nvim",
        config = true,
        keys = {
            {
                mode = { 'n', 't' },
                '<leader>r',
                function()
                    require('code_runner').run_code()
                end,
                desc = 'Run Code',
            },
            {
                mode = { 'n', 't' },
                '<leader>q',
                function()
                    require("code_runner").run_close()
                end,
                desc = 'Close Code Runner Window',
            },
        },
        opts = {
            mode = 'term',
            focus = false,
            startinsert = false,
            term = {
                size = 20,
            },
            filetype = {
                tex = {
                    "make short",
                },
            },
        },
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        opts = {
            enabled = false,
            latex = {
                enabled = false
            },
            html = {
                enabled = false
            },
            completions = {
                lsp = {
                    enabled = true
                }
            },
        },
    },
    -- }}} functional

    -- {{{ git
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            attach_to_untracked = false,
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns
                local opts = { buffer = buffer }
                vim.keymap.set("n", "<C-d>", gs.toggle_deleted, opts)
                vim.keymap.set("n", "<C-b>", function() gs.blame_line{full=true} end, opts)
            end
        },
    },
    -- }}} git

    -- {{{ misc
    {
        "kevinhwang91/nvim-bqf",
        event = "VeryLazy",
        opts = {
            preview = {
                winblend = 0,
                wrap = false,
            },
        },
    },
    {
        "https://codeberg.org/yorickpeterse/nvim-pqf",
        event = "VeryLazy",
        opts = {
            signs = {
                error = { text = '' },
                warning = { text = '' },
                info = { text = '󰙎' },
                hint = { text = '' },
            },
        },
    },
    -- }}} misc

    -- {{{ LSP config
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            {
                "mason-org/mason.nvim",
                opts = {
                    PATH = "append",
                },
            },
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                -- :help lspconfig-all
                "basedpyright",
                "clangd",
                "gopls",
                "lua_ls",
            },
        },
    },
    {
        'saghen/blink.cmp',
        version = '1.*',
        lazy = false,
        opts = {
            keymap = {
                preset = 'default',
                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
                ['<Enter>'] = { 'accept', 'fallback' },
            },
            completion = {
                menu = {
                    max_height = 20,
                    winhighlight = 'Normal:None,FloatBorder:None,CursorLine:BlinkCmpMenuSelection,Search:None',
                },
                documentation = {
                    auto_show = true,
                },
                list = {
                    selection = {
                        preselect = true,
                        auto_insert = true,
                    },
                },
                trigger = {
                    show_on_backspace = false,
                    show_on_backspace_in_keyword = false,
                    show_on_backspace_after_accept = false,
                    show_on_backspace_after_insert_enter = false,
                }
            },
            fuzzy = {
                sorts = {
                    'exact',
                    'score',
                    'sort_text',
                },
            },
            sources = {
                default = { 'lsp', 'path', 'buffer' },
            },
            cmdline = {
                completion = {
                    list = {
                        selection = {
                            preselect = false,
                            auto_insert = true,
                        },
                    },
                },
            },
        },
    },
    -- }}} LSP config
}

-- load plugins
return require("lazy").setup({
    spec = plugin_spec,
})

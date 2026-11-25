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


local plugin_spec = {

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
                    DiagnosticUnderlineError = { underline = true, sp = "#fb4934" },
                    DiagnosticUnderlineWarn = { underline = true, sp = "#fabd2f" },
                    DiagnosticUnderlineInfo = { underline = true, sp = "#83a598" },
                    DiagnosticUnderlineHint = { underline = true, sp = "#83c07c" },
                    DiagnosticUnderlineOk = { underline = true, sp = "#b8bb26" },
                    WinSeparator = { fg = "#458588" },
                },
            })
            vim.cmd("colorscheme gruvbox")
            -- custom highlight groups to show LSP diagnostics in the number column
            vim.api.nvim_set_hl(0, 'DiagNumError', { fg = '#fb4934', underline = true, sp = '#fb4934' })
            vim.api.nvim_set_hl(0, 'DiagNumWarn',  { fg = '#fabd2f', underline = true, sp = '#fabd2f' })
            vim.api.nvim_set_hl(0, 'DiagNumInfo',  { fg = '#83a598', underline = true, sp = '#83a598' })
            vim.api.nvim_set_hl(0, 'DiagNumHint',  { fg = '#83c07c', underline = true, sp = '#83c07c' })
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
                    -- avoid running on buffers that do not correspond to a language
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

    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = 'gruvbox',
            },
            extensions = {
                'nvim-tree',
            },
        },
    },

    {
        'b0o/incline.nvim',
        event = 'VeryLazy',
        opts = {
            window = {
                zindex = 30,
                margin = {
                    -- shift to overlap window borders
                    vertical = {
                        top = 0,
                        bottom = 0,
                    },
                    horizontal = {
                        left = 0,
                        right = 2,
                    },
                },
            },
            render = function(props)
                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                if filename == '' then
                    filename = '[No Name]'
                end
                local modified = vim.bo[props.buf].modified
                return {
                    ' ',
                    filename,
                    modified and ' [+]' or '',
                    ' ',
                    guibg = '#458588',
                    guifg = '#fbf1c7' }
            end,
        },
    },

    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle nvim-tree" },
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
                vim.keymap.set('n', '<C-h>', api.filter.dotfiles.toggle, opts('Toggle Dotfiles'))
                vim.keymap.set('n', '<C-r>', api.tree.reload, opts('Refresh'))
                vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
                vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
                vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
            end
            require'nvim-tree'.setup {
                on_attach = nvim_tree_on_attach,
                filters = {
                    git_ignored = false,
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
                    char = "┃",
                },
                scope = {
                    show_start = false,
                    show_end = false,
                },
            })
        end
    },

    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        keys = {
            { "<leader>m", "<cmd>Markview splitToggle<CR>", desc = "Toggle Markdown split preview" },
        },
        opts = {
            preview = {
                enable = false,
                icon_provider = "devicons",
            },
        },
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            -- LSP diagnostic signs have a priority of 10, so now gitsigns always appears on the left
            attach_to_untracked = false,
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns
                vim.keymap.set("n", "<C-d>", gs.preview_hunk_inline, { buffer = buffer, desc = "Preview inline Git hunk" })
                vim.keymap.set("n", "<C-b>", function() gs.blame_line{full=true} end, { buffer = buffer, desc = "Toggle Git blame for current line" })
            end
        },
    },

    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            { "mason-org/mason.nvim", opts = { PATH = "append" }},
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

    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = {
            -- { "<leader>d", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Open Diagnostics in Trouble" },
            { "<leader>d", "<cmd>Trouble diagnostics toggle<cr>", desc = "Open Diagnostics in Trouble" },
        },
        opts = {
            focus = true,
            warn_no_results = false,
        },
    },

    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        keys = {
            { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "fzf-lua files" },
            { "<leader>fo", "<cmd>FzfLua oldfiles<CR>", desc = "fzf-lua history" },
            { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "fzf-lua live grep" },
            { "<leader>fm", "<cmd>FzfLua manpages<CR>", desc = "fzf-lua manpages" },
            { "<leader>fr", "<cmd>FzfLua lsp_references<CR>", desc = "fzf-lua registers" },
            { "<leader>fs", "<cmd>FzfLua spellcheck<CR>", desc = "fzf-lua spellcheck" },
            { "<leader>fu", "<cmd>FzfLua undotree<CR>", desc = "fzf-lua undotree" },
        },
        opts = function ()
            local trouble_actions = require("trouble.sources.fzf").actions
            return {
                actions = {
                    files = {
                        true,   -- inherit defaults
                        ["ctrl-q"] = trouble_actions.open,  -- open all matches in trouble, see trouble's README
                    },
                },
                winopts = {
                    preview = {
                        layout = "vertical",
                        vertical = "up:60%",
                    },
                },
                grep = {
                    rg_opts = [[ --column --line-number --no-heading --color=always --smart-case --max-columns=4096 --sort=path --trim -g "!.git" -g "!**/config-generator/mibs/**" -g "!*dashboards*" -e ]],
                    hidden = true,
                },
                oldfiles = {
                    file_ignore_patterns = { "%.git/" },
                },
            }
        end,
    },

    {
        {
            "rachartier/tiny-inline-diagnostic.nvim",
            event = "VeryLazy",
            priority = 1000,
            opts = {
                options = {
                    show_code = false,
                },
            },
        },
    },

}

-- load plugins
return require("lazy").setup({
    spec = plugin_spec,
})

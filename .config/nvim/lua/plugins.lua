return {
    -- UI & Icons
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {},
        config = function()
            require("lualine").setup {
                sections = {
                    lualine_c = {
                        {
                            'lsp_status',
                            icon = '', -- f013
                            symbols = {
                                -- Standard unicode symbols to cycle through for LSP progress:
                                spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                                -- Standard unicode symbol for when LSP is done:
                                done = '✓',
                                -- Delimiter inserted between LSP names:
                                separator = ' ',
                            },
                            -- List of LSP names to ignore (e.g., `null-ls`):
                            ignore_lsp = {},
                            -- Display the LSP name
                            show_name = true,
                        }
                    }
                }
            }
        end
    },

    -- Fuzzy Finder
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        ---@module "fzf-lua"
        ---@type fzf-lua.Config|{}
        ---@diagnostic disable: missing-fields
        opts = {},
        ---@diagnostic enable: missing-fields
        config = function()
            require("fzf-lua").setup({})
        end
    },

    -- LSP & Mason (Package Manager)
    { "mason-org/mason.nvim",        opts = {} },
    { "neovim/nvim-lspconfig" },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },

    -- Autocompletion Engine
    {
        'saghen/blink.cmp',
        dependencies = {
            'saghen/blink.lib',
            -- optional: provides snippets for the snippet source
            'rafamadriz/friendly-snippets',
        },
        build = function()
            -- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
            -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
            require('blink.cmp').build():pwait()
        end,

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = 'enter' },

            -- (Default) Only show the documentation popup when manually triggered
            completion = { documentation = { auto_show = false } },

            -- (Default) list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"`
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "rust" }
        },
    },

    -- File Tree & Navigation Utilities
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" }
        },
        opts = {
            window = {
                mappings = {
                    ["."] = "toggle_hidden",
                    ["<leader>."] = "navigate_up",
                },
            },
        },
    },
    {
        "Crysthamus/nvim-file-operations",
        dependencies = { "nvim-neo-tree/neo-tree.nvim" },
        config = function()
            require("nvim-file-operations").setup()
        end,
    },
    {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
            require("window-picker").setup({
                filter_rules = {
                    include_current_win = false,
                    autoselect_one = true,
                    bo = {
                        filetype = { "neo-tree", "neo-tree-popup", "notify" },
                        buftype = { "terminal", "quickfix" },
                    },
                },
            })
        end,
    },

    -- Text Editing Enhancements
    {
        "nvim-mini/mini.pairs",
        version = false,
        config = function()
            require('mini.pairs').setup()
        end
    },
    {
        "kylechui/nvim-surround",
        version = "^4.0.0",
        event = "VeryLazy",
        opts = {}
    },

    -- Treesitter Syntax Highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            -- Native configuration and parser installation
            local configs = require('nvim-treesitter')
            -- If you want to force install specific parsers on startup:
            configs.install({ "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "cpp" })
        end
    },
    {
        'RRethy/base16-nvim',
        config = function()
            require('matugen').setup()
        end,
    },
    {
        "folke/zen-mode.nvim",
        opts = {}
    },
    {
        "folke/twilight.nvim",
        opts = {}
    },
    {
        "nvim-mini/mini.animate",
        version = false,
        config = function()
            require('mini.animate').setup({
                cursor = {
                    enable = false,
                },
            })
        end
    },
    {
        "sphamba/smear-cursor.nvim",
        opts = {},
    },
}

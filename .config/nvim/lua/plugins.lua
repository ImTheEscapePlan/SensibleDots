return {
    -- UI & Icons
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {},
        config = function ()
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

    -- Git Integration
    { "sindrets/diffview.nvim" },
    {
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {
            "sindrets/diffview.nvim",
            "ibhagwan/fzf-lua",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
        },
        opts = {}
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
    { "mason-org/mason.nvim", opts = {} },
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
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require("cmp")
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )

            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body) 
                    end,
                },
                window = {},
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.snippet.active({ direction = 1 }) then
                            vim.snippet.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif vim.snippet.active({ direction = -1 }) then
                            vim.snippet.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                }, {
                    { name = "buffer" },
                }),
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
                matching = { disallow_symbol_nonprefix_matching = false },
            }) 
        end,
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
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
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
            configs.install({ "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python" })
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
}

-- ~/.config/nvim/init.lua

-- 1. Global Leader Definitions
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. Quality of Life Settings
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.scrolloff = 5
vim.opt.clipboard = "unnamedplus"

vim.diagnostic.config({
    virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "*",
    },
    severity_sort = true,
})

-- 3. Run the Lazy Bootstrapper & Plugin Specs
require("config.lazy") -- Links to your lazy setup

vim.keymap.set('n', '<leader>p', '<cmd>lua require("fzf-lua").files()<CR>', { silent = true }, { desc = "FzfLua Files" })
vim.keymap.set('n', '<leader>n', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
vim.keymap.set('n', '<leader>l', '<cmd>Lazy<CR>', { desc = 'Open Lazy.nvim' })
vim.keymap.set('n', '<leader>m', '<cmd>Mason<CR>', { desc = 'Open Mason.nvim' })
vim.keymap.set('n', '<leader>t', '<cmd>botright 15split | terminal<CR>', { desc = 'Open Terminal' })
vim.keymap.set('n', '<leader>`', '<cmd>tabnew<CR>', { desc = 'Open New Tab' })
vim.keymap.set('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>',
    { desc = 'LSP: Format Buffer' })
vim.keymap.set('x', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>',
    { desc = 'LSP: Format Selected Range' })

local term_group = vim.api.nvim_create_augroup("TerminalInsert", { clear = true })
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
    group = term_group,
    pattern = "term://*",
    command = "startinsert",
})

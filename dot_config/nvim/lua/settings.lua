-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.bo.tabstop = 4
vim.bo.softtabstop = 0
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.g.smarttab = true

-- Color scheme
vim.o.termguicolors = true

-- require("catppuccin").setup({
--     flavour="macchiato",
--     integrations = {
--         cmp = true,
--         gitsigns = true,
--         fidget=true,
--         nvimtree = true,
--         telescope = true,
--         notify = false,
--         mini = false,
--     }
-- })
vim.cmd.colorscheme "catppuccin"

vim.filetype.add({
    pattern = {
        ['.*zshrc'] = 'zsh'
    }
})

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap.set

keymap("n", "<Up>", "<C-w><C-k>", { desc = "Move cursor up window" })
keymap("n", "<Down>", "<C-w><C-j>", { desc = "Move cursor down window" })
keymap("n", "<Left>", "<C-w><C-h>", { desc = "Move cursor left window" })
keymap("n", "<Right>", "<C-w><C-l>", { desc = "Move cursor right window" })

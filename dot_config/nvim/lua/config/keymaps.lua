local keymap = vim.keymap.set

vim.o.timeout = true
vim.o.timeoutlen = 300
local wk = require("which-key")
wk.setup()


-- ---Arrow key bindings---
keymap("n", "<Up>", "<C-w><C-k>", { desc = 'Move cursor up window' })
keymap("n", "<Down>", "<C-w><C-j>", { desc = 'Move cursor down window' })
keymap("n", "<Left>", "<C-w><C-h>", { desc = 'Move cursor left window' })
keymap("n", "<Right>", "<C-w><C-l>", { desc = 'Move cursor right window' })


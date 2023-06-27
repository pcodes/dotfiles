local keymap = vim.keymap.set

vim.o.timeout = true
vim.o.timeoutlen = 300
local wk = require("which-key")
wk.setup()

local register_prefix = function(keybinding, name)
    wk.register({
        [keybinding] = { name = name }
    })
end

-- ---Arrow key bindings---
keymap("n", "<Up>", "<C-w><C-k>", { desc = 'Move cursor up window' })
keymap("n", "<Down>", "<C-w><C-j>", { desc = 'Move cursor down window' })
keymap("n", "<Left>", "<C-w><C-h>", { desc = 'Move cursor left window' })
keymap("n", "<Right>", "<C-w><C-l>", { desc = 'Move cursor right window' })

-- -- ---Hop bindings---
-- keymap("n", "<leader>h", ":HopWord<cr>")

-- ---Telescope bindings---
register_prefix("<leader>f", "+telescope")
keymap("n", "<leader>ff", ":Telescope find_files<cr>")
keymap("n", "<leader>fb", ":Telescope buffers<cr>")

-- ---Bufferline bindings---
register_prefix("<leader>b", "+buffer")
keymap("n", "bn", ":BufferLineCycleNext<cr>")
keymap("n", "bp", ":BufferLineCyclePrev<cr>")

-- ---Trouble bindings---
register_prefix("<leader>x", "+trouble")
keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
    { silent = true, noremap = true }
)
keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
    { silent = true, noremap = true }
)
keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
    { silent = true, noremap = true }
)
keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
    { silent = true, noremap = true }
)
keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
    { silent = true, noremap = true }
)

-- ---LSP bindings---
register_prefix("<leader>c", "+code actions")
register_prefix("<leader>w", "+workspace actions")
keymap('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
keymap('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', { desc = 'Go to definition' })
keymap('n', 'K', '<cmd>Lspsaga hover_doc<CR>', { desc = 'LSP hover' })
keymap('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
keymap('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { desc = 'LSP outline' })
keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>")
-- keymap('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
-- keymap('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
keymap('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = 'Print workspace folders' })
keymap('n', 'gt', "<cmd>Lspsaga goto_type_definition<CR>", { desc = 'Go to type definition' })
-- keymap('n', '<space>rn', vim.lsp.buf.rename, bufopts)
-- keymap('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
-- keymap('n', 'gr', vim.lsp.buf.references, bufopts)
keymap('n', '<leader>F', function() vim.lsp.buf.format { async = true } end, { desc = 'Format file' })

-- ---Nvim Tree bindings---
keymap('n', '<leader>t', '<cmd>NvimTreeToggle<cr>', { desc = 'NvimTree toggle' })

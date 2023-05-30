local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities()
M.capabilities = capabilities

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        'lua_ls', 'jsonls', 'yamlls', 'bashls'
    }
})

require("mason-null-ls").setup({
    ensure_installed = { "stylua", 'luacheck', 'shellcheck', 'shfmt', 'prettier' },
    automatic_setup = true
})

-- This sets up lua_ls and jsonls automatically
require("neodev").setup({
})

local lspconfig = require('lspconfig')

lspconfig.bashls.setup({
    capabilities = capabilities,
    filetypes = { 'sh', 'zsh' }
})


lspconfig.yamlls.setup({
    capabilities = capabilities,
    settings = {
        yaml = {
            keyOrdering = false
        }
    }

})



return M

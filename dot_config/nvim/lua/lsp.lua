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

require("neodev").setup({
})

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason-lspconfig').setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup({
            capabilities = capabilities
        })
    end,
    ['bashls'] = function()
        require('lspconfig').bashls.setup({
            filetypes = { 'sh', 'zsh' }
        })
    end,
    ['yamlls'] = function()
        require('lspconfig').yamlls.setup({
            settings = {
                yaml = {
                    keyOrdering = false
                }
            }
        })
    end
})


require('trouble').setup {}

return M

local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities()
M.capabilities = capabilities

require("neodev").setup({
})

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

require('mason-lspconfig').setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup({
            capabilities = capabilities
        })
    end,
    ["bashls"] = function()
        require("lspconfig").bashls.setup({
            capabilities = capabilities,
            filetypes = { 'sh', 'zsh' }
        })
    end,
    ["yamlls"] = function()
        require("lspconfig").yamlls.setup({
            capabilities = capabilities,
            settings = {
                yaml = {
                    keyOrdering = false
                }
            }

        })
    end
}

return M

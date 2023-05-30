-- Replace this with local stuff

-- Get LSP settings for my config
local lsp_settings = require('lsp')
local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup({
    capabilities=lsp_settings.capabilities
})

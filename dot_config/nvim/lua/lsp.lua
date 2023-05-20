-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        'lua_ls', 'gopls', 'jsonls', 'yamlls', 'rust_analyzer'
    }
})

require("mason-null-ls").setup({
    ensure_installed = { "stylua", 'luacheck', 'rustfmt' },
    automatic_setup = true
})

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities()


require('mason-lspconfig').setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup({
            capabilities = capabilities
        })
    end,
    ["lua_ls"] = function()
        require('lspconfig').lua_ls.setup({
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { 'vim' },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                },
                capabilities = capabilities
            }
        })
    end
})


require('trouble').setup {}

-- require('lspconfig').yamlls.setup {
--     on_attach = on_attach,
--   settings = {
--     yaml = {
--       schemas = {
--         ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "~/uss_enterprise/*"
--       },
--     },
--   }
-- }


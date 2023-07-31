return {
    'neovim/nvim-lspconfig',
    'jose-elias-alvarez/null-ls.nvim',
    "williamboman/mason.nvim",
    'williamboman/mason-lspconfig.nvim',
    'jay-babu/mason-null-ls.nvim',
    {
        'folke/trouble.nvim',
        main = 'trouble',
        config = true
    },
    {
        "glepnir/lspsaga.nvim",
        event = "LspAttach",
        config = function()
            require("lspsaga").setup({
                ui = {
                    kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
                },
            })
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            --Please make sure you install markdown and markdown_inline parser
            { "nvim-treesitter/nvim-treesitter" }
        }
    },
    'onsails/lspkind-nvim',
    {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        config = function()
            require('fidget').setup({
                window = {
                    blend = 100,
                },
            })
        end
    },

}

return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        priority = 1000,
        opts = {
            flavour = "macchiato",
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                notify = true,
                ts_rainbow2 = true,
                noice = true,
                leap = true,
                telescope = true,
                fidget = true,
                lsp_saga = true,
                mason = true,
                lsp_trouble = true,
                which_key = true,
                semantic_tokens = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                },

            },
        }
    },
    { 'nvim-tree/nvim-web-devicons', lazy = true },

}

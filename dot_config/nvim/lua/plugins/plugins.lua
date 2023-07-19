return {
    -- THEMES
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
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
                }
            })
        end
    },
    { 'nvim-tree/nvim-web-devicons', lazy = true },
    'folke/tokyonight.nvim',

    -- LANGUAGE-SPECIFIC
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require("nvim-treesitter.install").prefer_git = true
            require('nvim-treesitter.configs').setup {
                ensure_installed = "all",
                highlight = { enable = true }
            }
        end

    },
    {
        'ray-x/go.nvim',
        main = 'go',
        config = true
    },
    'folke/neodev.nvim',

    -- STATUS LINE
    'nvim-lualine/lualine.nvim',
    { 'akinsho/bufferline.nvim',     version = 'v3.*' },

    -- LSP
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

    -- SEARCH
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

    -- COMPLETION
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    "hrsh7th/cmp-nvim-lsp-signature-help",
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'andersevenrud/cmp-tmux',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',

    -- KEYMAP SHORTCUTS
    {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    },
    "folke/which-key.nvim",
    "windwp/nvim-autopairs",
    {
        "ggandor/leap.nvim",
        dependencies = { "tpope/vim-repeat" },
        config = function()
            require("leap").add_default_mappings()
        end
    },

    -- MISC
    'mfussenegger/nvim-dap',
    {
        'lewis6991/gitsigns.nvim',
        main = 'gitsigns',
        config = true
    },
    'ray-x/guihua.lua', -- recommanded if need floating window support
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require('indent_blankline').setup({
                -- for example, context is off by default, use this to turn it on
                show_current_context = true,
                show_current_context_start = true,
            })
        end
    },
    { 'nvim-tree/nvim-tree.lua',                  main = 'nvim-tree', config = true },
    {
        'mhinz/vim-signify',
        config = function(_, _)
            vim.api.nvim_set_hl(0, "SignifySignAdd", { link = "GitSignsAdd" })
            vim.api.nvim_set_hl(0, "SignifySignChange", { link = "GitSignsChange" })
            vim.api.nvim_set_hl(
                0,
                "SignifySignChangeDelete",
                { link = "GitSignsChange" }
            )
            vim.api.nvim_set_hl(0, "SignifySignDelete", { link = "GitSignsDelete" })
            vim.api.nvim_set_hl(
                0,
                "SignifySignDeleteFirstLine",
                { link = "GitSignsDelete" }
            )

            vim.g.signify_sign_add = "▎"
            vim.g.signify_sign_change = "▎"
            vim.g.signify_sign_delete = ""
            vim.g.signify_sign_delete_first_line = ""
            vim.g.signify_sign_change_delete = ""
        end,
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        config = function()
            local rainbow_delimiters = require 'rainbow-delimiters'

            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = rainbow_delimiters.strategy['global'],
                    commonlisp = rainbow_delimiters.strategy['local'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                },
                highlight = {
                    'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
                blacklist = { 'c', 'cpp' },
            }
        end

    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true,         -- use a classic bottom cmdline for search
                    command_palette = true,       -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false,       -- add a border to hover docs and signature help
                },
            })
        end
    }
}

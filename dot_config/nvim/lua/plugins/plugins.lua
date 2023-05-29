return {
    { 'nvim-tree/nvim-web-devicons', lazy = true },
    { "catppuccin/nvim",              name = "catppuccin", lazy = true, priority = 1000 },
    'folke/tokyonight.nvim',
    'nvim-lualine/lualine.nvim',
    { 'nvim-treesitter/nvim-treesitter',          build = ':TSUpdate' },
    'neovim/nvim-lspconfig',
    "williamboman/mason.nvim",
    'williamboman/mason-lspconfig.nvim',
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'mfussenegger/nvim-dap',
    'jose-elias-alvarez/null-ls.nvim',
    {'phaazon/hop.nvim', config=true},
    {'j-hui/fidget.nvim', config=true},
    'folke/neodev.nvim',
    'jay-babu/mason-null-ls.nvim',
    {
        "glepnir/lspsaga.nvim",
        event = "LspAttach",
        config = function()
            require("lspsaga").setup({})
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            --Please make sure you install markdown and markdown_inline parser
            { "nvim-treesitter/nvim-treesitter" }
        }
    },
    'folke/trouble.nvim',
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    },
    'williamboman/mason-lspconfig.nvim',

    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    "hrsh7th/cmp-nvim-lsp-signature-help",
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'andersevenrud/cmp-tmux',
    { 'akinsho/bufferline.nvim', version = 'v3.*' },
    'onsails/lspkind-nvim',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    },
    "folke/which-key.nvim",
    "windwp/nvim-autopairs",
    'ray-x/go.nvim',
    'ray-x/guihua.lua' -- recommanded if need floating window support
}

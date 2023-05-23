require('nvim-treesitter.configs').setup {
    ensure_installed = "all",
    highlight={enable=true}
}

require("nvim-treesitter.install").prefer_git = true

require('go').setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '

require('lazy').setup(
    'plugins',
    {
        checker = {
            enabled = true,
            notify = false
        },
        dev={
            path="~/Code/nvim_plugins"
        },
	install={
		colorscheme={'catppuccin'}
	}
    }
)

-- Create autocommand for running chezmoi apply on save
vim.api.nvim_create_autocmd({"BufWritePost"}, {
    pattern = '*.local/share/chezmoi/*',
    command = 'silent ! chezmoi apply --source-path %',
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {pattern="*/waybar/config", command="set filetype=json"})

-- Import all of the submodules
require('settings')
require("statusline")
require("autocomplete")
require('lsp')
require('telescope')
require('keybindings')
require('local')

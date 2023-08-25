return {
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
		'numToStr/Comment.nvim',
		config = function() require('Comment').setup() end
	},
	{
		'windwp/nvim-autopairs',
		config = function(_, opts)
			require('nvim-autopairs').setup(opts)

			require('cmp').event:on('confirm_done',
				require('nvim-autopairs.completion.cmp').on_confirm_done())
		end
	},
	{
		"ggandor/leap.nvim",
		dependencies = { "tpope/vim-repeat" },
		config = function()
			require("leap").add_default_mappings()
		end
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true
	},
	{
		'nvim-tree/nvim-tree.lua',
		main = 'nvim-tree',
		config = true,
		keys = {
			{ "<leader>t", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree Toggle" }
		}
	},
}

return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		version = false,
		opts = {
			extensions = {
				fzf = {
					fuzzy = true,         -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				}
			}
		},
		keys = {
			{ "<leader>ff", ":Telescope find_files<cr>" },
			{ "<leader>fb", ":Telescope buffers<cr>" }
		}
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
		dependencies = { 'nvim-telescope/telescope.nvim' },
		config = function()
			require('telescope').load_extension('fzf')
		end
	},
}

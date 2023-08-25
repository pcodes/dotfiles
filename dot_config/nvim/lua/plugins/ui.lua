return {
	--- A noice UI
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
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
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	--- Statusline
	{
		'nvim-lualine/lualine.nvim',
		opts = {
			options = {
				theme = 'catppuccin'
			},
			sections = {
				lualine_x = {
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = { fg = "#ff9e64" },
					},
				},
			},

		}
	},
	{
		'akinsho/bufferline.nvim',
		version = 'v3.*',
		opts = {
			highlights = require("catppuccin.groups.integrations.bufferline").get(),
			options = {
				numbers = "buffer_id",
				indicator = {
					style = 'icon',
				},
				buffer_close_icon = '',
				modified_icon = '●',
				close_icon = '',
				left_trunc_marker = '',
				right_trunc_marker = '',
				--- name_formatter can be d to change the buffer's label in the bufferline.
				--- Please note some names can/will break the
				--- bufferline so  this at your discretion knowing that it has
				--- some limitations that will *NOT* be fixed.
				-- name                | str        | the basename of the active file
				-- path                | str        | the full path of the active file
				-- bufnr (buffer only) | int        | the number of the active buffer
				-- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
				-- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				-- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
				color_icons = true,  -- whether or not to add the filetype icon highlights
				show_buffer_icons = true, -- disable filetype icons for buffers
				show_buffer_close_icons = true,
				show_buffer_default_icon = true, -- whether or not an unrecognised filetype should show a default icon
				show_close_icon = true,
				show_tab_indicators = true,
				persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
				-- can also be a table containing 2 custom separators
				-- [focd and unfocused]. eg: { '|', '|' }
				separator_style = { "\u{e0b8}", "\u{e0ba}" },
				always_show_bufferline = true,
				hover = {
					enabled = true,
					delay = 200,
					reveal = { 'close' }
				},
			}
		},
		keys = {
			{ "bn", ":BufferLineCycleNext<cr>" },
			{ "bp", ":BufferLineCyclePrev<cr>" },
			{ "bx", ":bdelete<cr>" }
		}
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
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require('indent_blankline').setup({
				-- for example, context is off by default, use this to turn it on
				show_current_context = true,
				show_current_context_start = true,
			})
		end
	},
	{
		"folke/which-key.nvim",
		opts = {
			plugins = { spelling = true },
			defaults = {
				mode = { "n", "v" },
				["<leader>f"] = { name = "+telescope" },
				["<leader>b"] = { name = "+buffer" },
				["<leader>x"] = { name = "+trouble" },
				["<leader>c"] = { name = "+code" },
				["<leader>w"] = { name = "+workspace" }
			}
		}
	}
}

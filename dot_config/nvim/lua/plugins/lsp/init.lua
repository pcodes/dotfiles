return {
	{
		'neovim/nvim-lspconfig',
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
			{ "folke/neodev.nvim",  opts = {} },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		keys = {
			{ "gD",    vim.lsp.buf.declaration },
			{ "gi",    vim.lsp.buf.implementation },
			{ "<C-k>", vim.lsp.buf.signature_help },
			{ "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end
			},
			{
				"<leader>F", function()
				vim.lsp.buf.format({ async = true })
			end
			},
			{ "<leader>wa", vim.lsp.buf.add_workspace_folder },
			{ "<leader>rn", vim.lsp.buf.rename },
			{ "<leader>ca", vim.lsp.buf.code_action },
			{ "gr",         vim.lsp.buf.references }
		},
		config = function(_, opts)
			require("neoconf").setup({})
			require("neodev").setup({
			})

			local lspconfig = require("lspconfig")

			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				opts.capabilities or {}
			)

			lspconfig.bashls.setup({
				capabilities = capabilities,
				filetypes = { 'sh', 'zsh' }
			})
			lspconfig.yamlls.setup({
				capabilities = capabilities,
				settings = {
					yaml = {
						keyOrdering = false
					}
				}

			})
			lspconfig.lua_ls.setup({})
		end

	},
	'jose-elias-alvarez/null-ls.nvim',
	"williamboman/mason.nvim",
	'williamboman/mason-lspconfig.nvim',
	'jay-babu/mason-null-ls.nvim',
	{
		'folke/trouble.nvim',
		main = 'trouble',
		config = true,
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle<cr>" },
			{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
			{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>" },
			{ "<leader>xl", "<cmd>TroubleToggle loc_list<cr>" },
			{ "<leader>xq", "<cmd>TroubleToggle quickfix<cr>" },
			{ "<leader>xt", "<cmd>TodoTrouble<cr>" },
		}
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
		},
		keys = {
			{ "gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Go to definition" },
			{ "K",  "<cmd>Lspsaga hover_doc<cr>" },
			{ "gd", "<cmd>Lspsaga outline<cr>" },
			{ "gd", "<cmd>Lspsaga code_action<cr>" },
			{ "gt", "<cmd>Lspsaga goto_definition<cr>" },
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
	{
		'williamboman/mason.nvim',
		cmd = "Mason",
		build = ":MasonUpdate",
		config = function(_, opts)
			require('mason').setup(opts)
		end


	}

}

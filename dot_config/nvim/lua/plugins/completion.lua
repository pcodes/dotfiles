local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
            col)
        :match("%s") == nil
end


return {
    {
        'hrsh7th/nvim-cmp',
        opts = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')
            local luasnip = require('luasnip')
            return {
                snippet = {
                    expand = function(args)
                        lspkind.lsp_expand(args.body)
                    end,
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol',   -- show only symbol annotations
                        maxwidth = 50,     -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    })
                },
                mapping = {
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                            -- they way you will only jump inside the snippet region
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true })
                },
                sources = cmp.config.sources(
                    {
                        { name = 'nvim_lsp' },
                        { name = 'nvim_lsp_signature_help' },
                        { name = 'luasnip' },
                        { name = 'path' },
                        { name = 'tmux' }
                    }, {
                        { name = 'buffer' },
                    })
            }
        end,
        -- config = function(_, opts)
        --     cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
        -- end
    },
    {
        'hrsh7th/cmp-buffer',
        dependencies = {
            'hrsh7th/nvim-cmp',
        }
    },
    {
        'hrsh7th/cmp-nvim-lsp',
        dependencies = {
            'hrsh7th/nvim-cmp',
        }

    },
    {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        dependencies = {
            'hrsh7th/nvim-cmp',
        }

    },
    {
        'hrsh7th/cmp-path',
        dependencies = {
            'hrsh7th/nvim-cmp',
        }

    },
    {
        'hrsh7th/cmp-cmdline',
        dependencies = {
            'hrsh7th/nvim-cmp',
        }

    },
    {
        'andersevenrud/cmp-tmux',
        dependencies = {
            'hrsh7th/nvim-cmp',
        }

    },
    {
        'saadparwaiz1/cmp_luasnip',
        dependencies = {
            'hrsh7th/nvim-cmp',
        }
    },
    'L3MON4D3/luasnip',
}

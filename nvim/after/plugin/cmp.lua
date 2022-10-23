
local cmp = require('cmp')
local lspkind = require('lspkind')
lspkind.init()

cmp.setup{
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
    view = {
        entries = {name = 'custom', selection_order = 'near_cursor' }
    },
	mapping = {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-s>'] = cmp.mapping.select_prev_item(),
		['<C-e>'] = cmp.mapping.close(),
        ['<C-y>'] = cmp.mapping.confirm { select = true },
		['<C-Space>'] = cmp.mapping.complete(),
	},
	sources = {
		{ name = 'nvim_lsp', max_item_count = 10 },
		{ name = 'path', max_item_count = 10 },
		{ name = 'luasnip', max_item_count = 10 },
		{ name = 'buffer', max_item_count = 10,  keyword_length = 5}
	},
    experimental = {
        ghost_text = true
    },
	formatting = {
		format = lspkind.cmp_format{
			mode = 'symbol',
			maxwidth = 50,
			with_text = true,
			menu = {
				buffer = "[buf]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[api]",
				path = "[path]",
				luasnip = "[snip]",
				gh_issues = "[issues]",
			}
		}
	}
}

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path', max_item_count = 10 }
    }, {
        { name = 'cmdline', max_item_count = 10 }
    })
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer', max_item_count = 10 }
    }
})


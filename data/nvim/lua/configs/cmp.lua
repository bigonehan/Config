local cmp = require 'cmp'
local luasnip = require('luasnip')


local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}


cmp.setup {
	enabled = true,
	preselect = cmp.PreselectMode.None,
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = {
		['<C-k>'] = cmp.mapping.select_prev_item(),
		['<C-j>'] = cmp.mapping.select_next_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<esc>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
		['<S-Tab>'] = function(fallback)
			-- ✅ luasnip을 먼저 확인
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			elseif cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end,
	},
	sources = cmp.config.sources({
		{ name = 'luasnip' },
		{ name = "buffer" },
		{ name = 'nvim_lsp' },
		{ name = "path" },
	}),
	formatting = {
		--fields = { "kind", "abbr", "menu" },
		fileds = { "kind" },
		format = function(entry, vim_item)
			--	vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
			vim_item.kind = string.format('%s ', kind_icons[vim_item.kind])
			vim_item.menu = ({
				nvim_lsp = "✎",
				luasnip = "🗲",
				buffer = "",
				path = "",
			})[entry.source.name]
			return vim_item
		end,
	},

}

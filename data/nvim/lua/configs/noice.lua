require("noice").setup({
	views = {
		split = {
			enter = true,
		},
	},
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	-- you can enable a preset for easier configuration
	preset = {
		bottom_search = true,   -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false,     -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},

	notify = {
		enabled = true,
		view = "split",
	},
	popupmenu = {
		enabled = true,
		backend = "nui",
		kind_icons = {},
	},

}
)

local notify = require("notify")
notify.setup({
	max_width = 50,
	render = "wrapped-compact",
	stages = "fade",
	timeout = 100,


})

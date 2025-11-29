local navbuddy = require("nvim-navbuddy")
local actions = require("nvim-navbuddy.actions")

require("lspconfig").clangd.setup {
    on_attach = function(client, bufnr)
        navbuddy.attach(client, bufnr)
    end
}



navbuddy.setup {
	icons = {
		File = ' ',
		Module = ' ',
		Namespace = ' ',
		Package = ' ',
		Class = ' ',
		Method = ' ',
		Property = ' ',
		Field = ' ',
		Constructor = ' ',
		Enum = ' ',
		Interface = ' ',
		Function = ' ',
		Variable = ' ',
		Constant = ' ',
		String = ' ',
		Number = ' ',
		Boolean = ' ',
		Array = ' ',
		Object = ' ',
		Key = ' ',
		Null = ' ',
		EnumMember = ' ',
		Struct = ' ',
		Event = ' ',
		Operator = ' ',
		TypeParameter = ' ',
	},
	use_default_mappings = false,
	mappings = {
		["i"] = actions.children(), -- Move to left panel
		--	["h"] = actions.parent(), -- Move to right panel
		["a"] = actions.insert_name(), -- Insert at start of name'
		["m"] = actions.parent(),
		["q"] = actions.close(),

	},
	source_buffer = {
		follow_node = true, -- Keep the current node in focus on the source buffer
		highlight = true, -- Highlight the currently focused node
		reorient = "smart", -- "smart", "top", "mid" or "none"
		scrolloff = nil -- scrolloff value when navbuddy is open
	}
}

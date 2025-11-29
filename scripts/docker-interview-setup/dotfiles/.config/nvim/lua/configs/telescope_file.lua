local fb_actions = require 'telescope'.extensions.file_browser.actions

local actions = require('telescope.actions')

require("telescope").setup {
	defaults = {
		prompt_prefix = " ",
		selection_caret = "➤ ",
	},
	extensions = {
		file_browser = {
			mappings = {
				["i"] = {
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					['<C-a>'] = fb_actions.create,
					['<C-h>'] = fb_actions.goto_parent_dir,


				},
				["n"] = {
					['/'] = function()
						vim.cmd('startinsert')
					end
				},
			},
		},
	},
}

require("telescope").load_extension "file_browser"

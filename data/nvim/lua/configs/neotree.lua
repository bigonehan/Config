require("neo-tree").setup({
	filesfilesystem = {
		filtered_items = {
			visible = true,
			show_hidden_count = true,
			hide_dotfiles = false,
			hide_gitignored = true,
			hide_by_name = {
				-- '.git',
				-- '.DS_Store',
				-- 'thumbs.db',
			},
		}
	},
	window = {
		mappings = {
			["s"] = "open_vsplit",
			["e"] = "",
			["q"] = "close_window",
			["<Left>"] = "none", -- ⬅️ 이게 핵심
			["<leader>mg"] = {
				function(state)
					vim.cmd("MonogenAdapter")
				end,
				desc = "mygen",
			},

		}
	},
	update_focused_file = {
		enable = true,
		update_root = true
	},
})

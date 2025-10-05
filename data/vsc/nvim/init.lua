_G.__luacache_config = {
	chunks = {
		enable = true,
		path = vim.fn.stdpath('cache') .. '/luacache_chunks',
	},
	modpaths = {
		enable = true,
		path = vim.fn.stdpath('cache') .. '/luacache_modpaths',
	}
}

vim.loader.enable()

-- astro support
vim.filetype.add {
	extension = {
		astro = "astro",
	},
}
vim.lsp.set_log_level("debug")
require("basic")
require("plugin")
require("input")
require("theme")

-- use cache to load fast
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
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.astro",
  callback = function()
    vim.bo.filetype = "astro"
  end,
})
vim.lsp.set_log_level("debug")

if vim.g.vscode then
	require("vsc")
else

	require("basic")
	require("plugin")
	require("input")
	require("theme") -- ordinary Neovim
end

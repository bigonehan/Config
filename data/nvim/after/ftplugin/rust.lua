local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
	"n",
	"gc",
	function()
		vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
		-- or vim.lsp.buf.codeAction() if you don't want grouping.
	end,
	{ silent = true, buffer = bufnr }
)



vim.keymap.set('n', '<f7>',
	function()
		vim.cmd.RustLsp('debuggables')
	end,
	{ noremap = true })

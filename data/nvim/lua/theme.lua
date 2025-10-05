--basic theme setting
local o = vim.o
o.termguicolors = true

--Diagnostic
local signs = {
	Warn = "",
	Hint = "",
	Error = "",
	Info = ""
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end



--theme color scheme
vim.cmd.colorscheme 'melange'
o.background = "light"
vim.api.nvim_set_hl(0, 'Comment', { fg = '#a8a491' })
vim.api.nvim_set_hl(0, 'String', { fg = '#465AA4' })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = '#acbfb0' })
require('lualine').setup {
	options = {
		theme = 'nord'
	}
}



--Dap icon settings
vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

vim.fn.sign_define('DapBreakpoint', {
	text = '●',	
	texthl = 'DapBreakpoint',
	linehl = 'DapBreakpoint',
	numhl =
	'DapBreakpoint'
})

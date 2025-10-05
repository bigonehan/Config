local Terminal = require('toggleterm.terminal').Terminal

local dev_term = Terminal:new({
	hidden = true,
	count = 5,
	direction = "float",
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<cmd>lua Toggle_Term()<CR>",
			{ noremap = true, silent = true })
		vim.fn.chansend(term.job_id, "pnpm run dev")
	end,
})

function devTerm()
	local opts = { buffer = 0 }
	dev_term:toggle()
end

function Toggle_Term()
	dev_term:toggle()
end

vim.api.nvim_create_user_command("Rundev", devTerm, {})

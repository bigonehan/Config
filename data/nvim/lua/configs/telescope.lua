local status, telescope = pcall(require, 'telescope')
if (not status) then return end

local function telescope_buffer_dir()
	return vim.fn.expand('%:p:h')
end

print("Hello World<>")
local vscode = require('vscode')
-- basic setup
vim.opt.clipboard:append("unnamedplus")
local o = vim.o
local w = vim.wo
local b = vim.bo
local cmd = vim.cmd
local fn = vim.fn
local opt = vim.opt
--basic settings
o.ma = true
o.swapfile = false
o.tabstop = 4
o.shiftwidth = 4
o.hidden = true
o.backup = false
o.writebackup = false
o.cmdheight = 1
o.updatetime = 300
o.fileformat = "unix"
o.fileencoding = "utf-8"
o.encoding = "utf-8"
o.shortmess = o.shortmess .. "c"
--for better searching
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
--folding setting
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-- use system clipboard
--astro
vim.g.astro_typescript = 'enable'
vim.g.astro_stylus = 'enable'
--plugin setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	"tendertree/nforcolemak-dh",


})

function TrimCarriageReturns()
  -- 시스템 클립보드 내용 가져오기
  local text = vim.fn.getreg('+')
  -- CR 제거
  local cleaned = text:gsub('\r', '')
  -- 다시 시스템 클립보드에 저장
  vim.fn.setreg('+', cleaned)
end


--input Setting
require("nforcolemak-dh")
local s = vim.api.nvim_set_keymap
local function toggle_sidebar()
  if sidebar_open then
    print("Closing sidebar")
    vscode.call('workbench.action.toggleSidebarVisibility')
    sidebar_open = false
  else
    print("Opening sidebar")
    vscode.call('workbench.action.toggleSidebarVisibility')
    vscode.call('workbench.action.focusSideBar')
    sidebar_open = true
  end
end
--- space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
s('n', 'sh', ':split<Return>', { noremap = true })
s('n', 'sv', ':call VSCodeNotify ("workbench.action.splitEditorRight")<CR>', { noremap = true })
s('n', '<C-w>m', ':call VSCodeNotify ("workbench.action.focusPreviousGroup")<CR>', { noremap = true, silent = true })
s('n', '<C-w>i', ':call VSCodeNotify ("workbench.action.focusNextGroup")<CR>', { noremap = true, silent = true })

s("n", "gc", ":call VSCodeNotify('editor.action.quickFix')<CR>", { noremap = true, silent = true })
s("n", "gr", ":call VSCodeNotify('editor.action.rename')<CR>", { noremap = true, silent = true })

s("n", "<leader>tf", ":call VSCodeNotify('workbench.action.quickOpen')<CR>", { noremap = true, silent = true })
s("n", "<leader>o", ":call VSCodeNotify('workbench.action.showCommands')<CR>", { noremap = true, silent = true })
s('n', '<leader>hv', ":call VSCodeNotify('editor.action.revealDefinitionAside')<CR>", { noremap = true, silent = true })
--s('n', ',h', toggle_sidebar, { noremap = true, silent = true })

s('n', ':', [[:lua TrimCarriageReturns()<CR>"+p]], { noremap = true, silent = true })
s('n', ';', ':', { noremap = true, silent = true })	
vim.keymap.set('n', ',h', toggle_sidebar, { noremap = true, silent = true })

s('n', '<leader>hb', ":call VSCodeNotify('vscode-harpoon.addEditor')<CR>", { noremap = true, silent = true })
s('n', '<leader>ho', ":call VSCodeNotify('vscode-harpoon.editorQuickPick')<CR>", { noremap = true, silent = true })
s('n', '<leader>he', ":call VSCodeNotify('vscode-harpoon.gotoPreviousGlobalHarpoonEdito')<CR>", { noremap = true, silent = true })
s('n', '<leader>hn', ":call VSCodeNotify('vscode-harpoon.editorQuickPick')<CR>", { noremap = true, silent = true })
s('v', 'm', 'h', { noremap = true })
s('v', 'n', 'j', { noremap = true })
s('v', 'e', 'k', { noremap = true })
s('v', 'i', 'l', { noremap = true })
--call vsc command 

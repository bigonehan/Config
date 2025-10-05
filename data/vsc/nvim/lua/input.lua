vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
local s = vim.api.nvim_set_keymap

require("nforcolemak-dh")



s('n', ':', 'p', { noremap = true })
s('v', ':', 'p', { noremap = true })
s('n', ';', ':', { noremap = true })
s('v', ';', ':', { noremap = true })
s('v', 'dd', '"_dd', { noremap = true })



s('n', 'ss', '"_dd', { noremap = true, silent = true })
s('n', '<F5>', ':undo<CR>', { noremap = true })
s('n', '<leader>hv', '<Cmd>call VSCodeNotify("editor.action.revealDefinition")<CR>', { noremap = true, silent = true })
s('n', '<leader>go', '<Cmd>call VSCodeNotify("bookmarks.listFromAllFiles")<CR>', { noremap = true, silent = true })
s('n', '<leader>gg', '<Cmd>call VSCodeNotify("bookmarks.toggle")<CR>', { noremap = true, silent = true })
s('n', 'gc', '<Cmd>call VSCodeNotify("editor.action.codeAction")<CR>', { noremap = true, silent = true })
s('n', 'gr', '<Cmd>call VSCodeNotify("editor.action.rename")<CR>', { noremap = true, silent = true })
s('n', '<leader>q', '<Cmd>call VSCodeNotify("workbench.view.search")<CR>', { noremap = true, silent = true })
s('n', ',h', '<Cmd>call VSCodeNotify("workbench.action.toggleSidebarVisibility")<CR>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
local s = vim.api.nvim_set_keymap

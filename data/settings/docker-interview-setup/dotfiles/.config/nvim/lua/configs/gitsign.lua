local status, gitsign = pcall(require, 'gitsings')
if (not status) then return end

gitsing.setup {}

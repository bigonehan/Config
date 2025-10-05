-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:

config.color_scheme = 'Mar (Gogh)'

config.colors = {
	-- The default background color
	background = '#f1f1f1'
}

config.font = wezterm.font 'JetBrainsMono Nerd Font Mono'

config.default_prog = { 'wsl.exe', '-d', 'Arch', '--cd', '~' }
config.audible_bell = "Disabled"
-- and finally, return the configuration to wezterm
--
--
config.window_padding = {
	left = 10,
	right = 5,
	top = 5,
	bottom = 5,
}
return config

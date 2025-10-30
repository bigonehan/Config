local alpha = require 'alpha'
local startify = require 'alpha.themes.startify'
startify.section.header.val = {
	'⠀⠀            ⢀⣀⣀⡀⠀⠀⠀⠀⠀                      ',
	'         ⢀⣤⡶⠞⠛⠛⠉⠉⠛⠛⠳⢦⣄                       ',
	' ⠀⠀⠀⠀ ⠀⣠⡾⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀            ',
	' ⠀⠀⠀⠀⠀⣼⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣄⠀⢹⡆⠀⠀⠀⠀⠀⠀⠀⠀            ',
	'     ⣼⠃⠀⠀⣠⡖⢠⠀⠀⠀⠀⠀⠀⠀⠀⣧⣼⣷⠀⢿⡀⠀                  ',
	'     ⡟⠀⠀⢠⢿⣷⣶⡇⠀⠀⠀⠀⠀⠀⠀⡿⣿⡿⠀⠘⣧⠀⠀⠀                ',
	'     ⣇⠀⠀⢸⠸⠻⡿⠇⠀⠀⠀⠀⠀⠀⠀⠐⠒⠈⢀⠀⢹⡄                  ',
	'  ⢀⣄⡀⣿⠀⠀⠀⠁⠀⠉⠁⢀⣀⣀⣀⣄⣤⠴⢶⣶⣿⡏⠀⣸⣃⣀⣤⣀⣀⠀⠀            ',
	'⣠⣾⠉⠛⠛⠦⠤⣄⡀⢿⡋⠉⠉⠁⠀⠀⠉⠁⠀⠀⢈⡟⢀⡼⠛⠉⠉⠉⠉⠉⠛⢷⣄            ',
	'⣿⠀⠀⠀⠀⠀⠀⠀⠉⠛⢷⣦⣀⠀⣀⣠⠤⠖⠒⠒⢛⣛⣻⣷⡖⣀⡀⠀⠀⠀⠀⠀⢹⡆⠀          ',
	'⣿⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⡋⢉⣠⠴⠖⠚⠉⠉⠁⠉⠻⣍⣹⣶⣦⣀⡀⠀⠀⣸⣷⠶⠶⠶⠶⢦⣤⣴⣦⡀⡀⠀',

}
startify.config.opts.margin = 30

require 'alpha'.setup(require 'alpha.themes.startify'.config)

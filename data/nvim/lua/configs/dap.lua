print('loading node config')

local dap = require 'dap'

local js_based_languages = {
	"typescript", "javascript", "javascriptreact", "typescriptreact",
	-- using pwa-chrome
}

require("dap-vscode-js").setup({
	debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
	adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
})

for _, language in ipairs(js_based_languages) do
	dap.configurations[language] = {


		{
			type = 'pwa-node',
			request = 'launch',
			name = 'Launch curret files- tsnode (Typescript)',
			cwd = "${workspaceFolder}",
			program = "${file}",
			runtimeExecutable = 'ts-node',
			-- args = { '${file}' },
			sourceMaps = true,
			protocol = 'inspector',
			outFiles = { "${workspaceFolder}/**/**/*", "!**/node_modules/**" },
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
		}
	}
end
dapui = require("dapui")
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	--dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	--dapui.close()
end

require("dapui").setup()

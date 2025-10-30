require("neotest").setup {
	adapters = {
		require "neotest-python" {
			dap = { justMyCode = false },
			runner = "unittest",
		},
		require('neotest-jest')({
			jestCommand = "npm test --",
			jestConfigFile = "custom.jest.config.ts",
			env = { CI = true },
			cwd = function(path)
				return vim.fn.getcwd()
			end,
		}),
		require "neotest-go",
		require "neotest-rust",
		require "neotest-plenary",
		require("neotest-vitest") {
			filter_dir = function(name, rel_path, root)
				return name ~= "node_modules"
			end,
		},
		-- require("neotest-playwright").adapter({
		-- 	options = {
		-- 		persist_project_selection = true,
		-- 		enable_dynamic_test_discovery = true,
		-- 	}
		-- }),

	},
	config = true,
	icons = {
		expanded = "",
		child_prefix = "",
		child_indent = "",
		final_child_prefix = "",
		non_collapsible = "",
		collapsed = "",

		passed = "",
		running = "",
		failed = "",
		unknown = ""
	},
}


--neodev setttings

require("neodev").setup({
	library = { plugins = { "neotest" }, types = true },
	...
})

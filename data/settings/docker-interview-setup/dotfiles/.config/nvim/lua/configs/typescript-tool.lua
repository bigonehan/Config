
local navbuddy = require("nvim-navbuddy")


require("typescript-tools").setup {
	    on_attach = function(client, bufnr)
        navbuddy.attach(client, bufnr)
    end,

	settings = {
		tsserver_file_preferences = {
			includeInlayParameterNameHints = "all",
			includeCompletionsForModuleExports = true,
			quotePreference = "auto",
		},
		tsserver_format_options = {
			allowIncompleteCompletions = false,
			allowRenameOfImportPath = false,
		}
	},
}

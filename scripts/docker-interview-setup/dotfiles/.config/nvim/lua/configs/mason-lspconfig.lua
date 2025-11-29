require("mason").setup()
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason-lspconfig').setup({
	ensure_installed = {
		'eslint',
		'html',
		'cssls',
		'jsonls',
		'pylsp',
		'lua_ls',
		'rust_analyzer',
		'tailwindcss',
		'emmet_language_server',
		-- 'denols'

	},

	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({ on_attach = on_attach, capabilities = capabilities })
		end,
		["lua_ls"] = function()
			require("lspconfig").lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim" },
						},
					},
				},
			})
		end,
		["clangd"] = function()
			require("lspconfig").clangd.setup({
				on_attach = on_attach
			})
		end,
		["eslint"] = function()
			require("lspconfig").eslint.setup({})
		end,
		["emmet_language_server"] = function()
			require("lspconfig").emmet_language_server.setup({

			})
		end,
		["tailwindcss"] = function()
			require("lspconfig").tailwindcss.setup({
				    root_dir = require('lspconfig.util').root_pattern('tailwind.config.ts', 'package.json'),
				capabilities = capabilities,

			})
		end,
		-- ["denols"] = function()
		-- 	require("lspconfig").denols.setup({
		-- 		capabilities = capabilities,
		-- 		root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
		-- 	})
		-- end,
		["omnisharp"] = function()
			require('lspconfig').omnisharp.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { "dotnet", vim.fn.stdpath "data" .. "/home/tree/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },
				filetypes = { "cs", "vb" },
				root_dir = require('lspconfig.util').root_pattern("Assets", "ProjectSettings", "Packages"),
				enable_roslyn_analyzers = true,
				analyze_open_documents_only = false,
				enable_import_completion = true,
				organize_imports_on_format = true,
			})
		end,
		["pylsp"] = function()
			require("lspconfig").pylsp.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							-- formatter options
							black = { enabled = true },
							autopep8 = { enabled = false },
							yapf = { enabled = false },
							-- linter options
							pylint = { enabled = true, executable = "pylint" },
							pyflakes = { enabled = false },
							pycodestyle = { enabled = false },
							-- type checker
							pylsp_mypy = { enabled = true },
							-- auto-completion options
							jedi_completion = { fuzzy = true },
							-- import sorting
							pyls_isort = { enabled = true },
						},
					},
				},
			})
		end
	}

})
   --dap config


--format on save
-- vim.api.nvim_create_autocmd('BufWritePre', {
-- 	callback = function()
-- 		vim.lsp.buf.format {
-- 		}
-- 	end,
-- })

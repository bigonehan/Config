local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	
	{
		"m4xshen/hardtime.nvim",
		enabled=false,
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
	},
	{
		'ThePrimeagen/harpoon',
		keys = {
			{ "<leader>hb", function() require("harpoon.mark").add_file() end,        desc = "Toggle Harpoon Menu" },
			{ "<leader>ho", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Toggle Harpoon Menu" },
			{ "<leader>he", function() require("harpoon.ui").nav_next() end,          desc = "Toggle Harpoon Menu" },
			{ "<leader>hn", function() require("harpoon.ui").nav_prev() end,          desc = "Toggle Harpoon Menu" }
		}
	},
	{
		"LintaoAmons/bookmarks.nvim",
		tag = "3.2.0",
		event = 'BufRead',
		dependencies = {
			{ "kkharji/sqlite.lua" },
			{ "nvim-telescope/telescope.nvim" },
			{ "stevearc/dressing.nvim" },
			{ "GeorgesAlkhouri/nvim-aider" }
		},
		config = function()
			local opts = {}
			require("bookmarks").setup(opts)
		end,
	},
	{
		'nvim-neo-tree/neo-tree.nvim',
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		config = function()
			require("configs.neotree")
		end,
		keys = {
			{ ",h", ":Neotree toggle<CR>", silent = true }
		}
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim"
				},
				opts = { lsp = { auto_attach = true } }
			}
		}
	},
	"nvim-neotest/nvim-nio",
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		event = 'BufRead',
		keys = {
			{ "<f10>", ":TodoTelescope<CR>", silent = true }
		}
	},
	"sindrets/diffview.nvim",
	{
		"monkoose/neocodeium",
		event = "VeryLazy",
		enabled = false,
		config = function()
			local neocodeium = require("neocodeium")
			neocodeium.setup()
			vim.keymap.set("i", "<A-f>", neocodeium.accept)
		end,
	},
	{
		'mfussenegger/nvim-dap',
		config = function()
			require("configs.dap")
		end,
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"mxsdev/nvim-dap-vscode-js",
		},
		keys = {
			{ 'fp', ":lua require'dap'.toggle_breakpoint() <cr>" },
			{ 'fP', ":lua require'dap'.continue() <cr>" }
		},
		lazy = true,
	},
	{
		"microsoft/vscode-js-debug",
		version = "1.x",
		build = "npm i && npm run compile vsDebugServerBundle && mv dist out"
	},
	{
		'rcarriga/nvim-notify',
		event = 'BufEnter'
	},
	'MunifTanjim/nui.nvim',
	{
		'prisma/vim-prisma',
		ft = "prisma",
		config = function()
		end,
	},
	{
		'nvim-neotest/neotest',
		dependencies = {
			"antoinemadec/FixCursorHold.nvim",
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-plenary",
			{
				"folke/neodev.nvim",
				config = function()
					require("neodev").setup({
						library = { plugins = { "neotest" }, types = true },
					})
				end
			},
		},
		config = function()
			require("neotest").setup({
				root = vim.loop.cwd(),
				adapters = {
					require("neotest-vitest") {
						filter_dir = function(name, rel_path, root)
							return rel_path:match("^tests")
						end,
					},
				},
				diagnostic = {
					enabled = true,
					severity = 1
				},
			})
		end,
		keys = {
			{ "tr", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File" },
			{ "ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary" },
			{ "to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
		}
	},
	{ 'nvim-neotest/neotest-jest',   ft = "typescript", },
	{ "thenbe/neotest-playwright",   ft = "typescript", },
	{ 'rouge8/neotest-rust',         ft = "rust" },
	{ "nvim-neotest/neotest-python", ft = "python" },
	{ "nvim-neotest/neotest-go",     ft = "go" },
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require("configs.gitsign")
		end
	},
	{
		'TimUntersberger/neogit',
		dependencies = { 'nvim-lua/plenary.nvim', "sindrets/diffview.nvim" },
		config = function()
			require('neogit').setup { integrations = { diffview = true } }
		end,
		keys = {
			{ "<f7>", function() require("neogit").open() end, desc = "Neogit open" },
		}
	},
	"nathom/filetype.nvim",
	{
		'lewis6991/impatient.nvim',
		config = function()
			require('impatient')
		end,
		event = 'BufRead',
		lazy = false,
		enabled = false,
	},
	'preservim/tagbar',
	'ludovicchabant/vim-gutentags',
	'nvim-lua/plenary.nvim',
	'sindrets/diffview.nvim',
	{
		'nvim-telescope/telescope.nvim',
		dependencies = 'nvim-lua/plenary.nvim',
		config = function()
			require("configs.telescope")
		end,
		keys = {
			{ '<leader>tb', ':Telescope buffers<CR>',    noremap = true, silent = true },
			{ '<leader>tf', ':Telescope find_files<CR>', noremap = true, silent = true },
		}
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build =
		'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
	},
	{
		'nvim-telescope/telescope-file-browser.nvim',
		config = function()
			require("configs.telescope_file")
		end,
		dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
		keys = {
			{
				'<f6>',
				function()
					require("telescope").extensions.file_browser.file_browser()
					print("telecope run")
				end,
				noremap = true,
				silent = true
			}
		}
	},
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup {}
		end
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = 'BufRead',
		opts = {},
		config = function()
			require("configs.indent_blackline")
		end
	},
	{
		'nacro90/numb.nvim',
		config = function()
			require('numb').setup()
		end
	},
	{
		'OXY2DEV/markview.nvim',
		lazy = false,
		priority = 49,
		ops = {},
		config = function()
			local presets = require("markview.presets");
			require("markview").setup(presets.no_nerd_fonts);
		end
	},
	'rhysd/git-messenger.vim',
	'Shatur/neovim-session-manager',
	{
		'numToStr/Comment.nvim',
		config = function()
			require("configs.comment")
		end,
		lazy = false,
	},
	"tendertree/nforcolemak-dh",
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = false,
		config = function()
			require("configs.treesitter")
		end,
		dependencies = { "OXY2DEV/markview.nvim" },
		build = { ':TSUpdate', ':TSInstall markdown markdown_inline' }
	},
	'nvim-treesitter/nvim-treesitter-textobjects',
	'nvim-treesitter/nvim-treesitter-context',
	'vim-pandoc/vim-pandoc-syntax',
	'RRethy/nvim-treesitter-textsubjects',
	{
		'mfussenegger/nvim-treehopper',
		config = function()
			require("tsht").config.hint_keys = { "h", "j", "f", "d", "n", "v", "s", "l", "a" }
		end
	},
	{
		'windwp/nvim-autopairs',
		config = function()
			require("configs.autopair")
		end,
		event = 'InsertEnter'
	},
	{
		'windwp/nvim-ts-autotag',
		config = function()
			require("configs.autotag")
		end,
		event = 'InsertEnter'
	},
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("configs.toggle_term")
		end
	},
	{ 'michaelb/sniprun',         build = 'bash ./install.sh' },
	{
		'junegunn/fzf',
		event = 'BufRead',
		build = ":call fzf#install()",
		config = function()
			require 'sniprun'.setup({ display = { "Terminal" }, })
		end
	},
	{ 'junegunn/fzf.vim',         event = 'BufRead' },
	{ 'wookayin/fzf-ripgrep.vim', event = 'BufRead' },
	{
		"folke/twilight.nvim",
		config = function()
			require("twilight").setup {}
		end,
		dependencies = {
			{
				"folke/zen-mode.nvim",
				config = function()
					require("zen-mode").setup {}
				end
			},
		},
		keys = {
			{ 'T', ':lua require("twilight").toggle() <CR>', noremap = true, silent = true, }
		}
	},
	"haringsrob/nvim_context_vt",
	{
		'laytan/tailwind-sorter.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
		build = 'cd formatter && npm i && npm run build',
		config = true,
	},
	{
		'goolord/alpha-nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require("configs.alpha")
		end,
		lazy = false
	},
	'cocopon/iceberg.vim',
	'savq/melange-nvim',
	{
		'nvim-lualine/lualine.nvim',
		config = function()
			require("configs.lualine")
		end
	},
	'romgrk/barbar.nvim',
	{
		"cuducos/yaml.nvim",
		ft = { "yaml" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
		},
	},
	{
		'anuvyklack/pretty-fold.nvim',
		config = function()
			require('pretty-fold').setup()
		end
	},
	'stevearc/dressing.nvim',

	-- LSP 설정 (순서가 중요함)
	{
		"williamboman/mason.nvim",
		lazy = false,
		priority = 100,
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded"
				}
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		priority = 99,
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "rust_analyzer" }
			})
			-- configs.mason-lspconfig가 있다면 여기서도 호출
			-- require("configs.mason-lspconfig")
		end,
	},
	{
		'neovim/nvim-lspconfig',
		lazy = false,
		priority = 98,
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		}
	},

	{
		'mrcjkb/rustaceanvim',
		version = '^6',
		ft = { 'rust' },
		init = function()
			vim.g.rustaceanvim = {
				tools = {},
				server = {
					-- rust-analyzer 경로를 명시적으로 지정
					cmd = function()
						-- 1. Mason 설치 경로 확인
						local mason_path = vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer"
						if vim.fn.executable(mason_path) == 1 then
							return { mason_path }
						end

						-- 2. 시스템 rust-analyzer 사용
						return { "rust-analyzer" }
					end,
					on_attach = function(client, bufnr)
						local bufmap = function(mode, lhs, rhs)
							vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
						end
						bufmap("n", "<leader>r", "<cmd>RustLsp runnables<CR>")
						bufmap("n", "<leader>a", "<cmd>RustLsp codeAction<CR>")
						bufmap("n", "K", "<cmd>RustLsp hover actions<CR>")
					end,
					default_settings = {
						['rust-analyzer'] = {
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
							},
							procMacro = {
								enable = true,
							},
							checkOnSave = {
								command = "clippy",
							},
						},
					},
				},
				dap = {
					adapter = function()
						local has_config, rust_config = pcall(require, "rustaceanvim.config")
						if not has_config then
							return false
						end

						local joinpath = function(...)
							if vim.fs and vim.fs.joinpath then
								return vim.fs.joinpath(...)
							end
							return table.concat({ ... }, "/")
						end

						local has_mason, mason_registry = pcall(require, "mason-registry")
						if has_mason and mason_registry.is_installed("codelldb") then
							local ok_pkg, codelldb_package = pcall(mason_registry.get_package, "codelldb")
							if ok_pkg and codelldb_package and codelldb_package.get_install_path then
								local shell = require("rustaceanvim.shell")
								local mason_codelldb_path = joinpath(codelldb_package:get_install_path(), "extension")
								local codelldb_path = joinpath(mason_codelldb_path, "adapter", "codelldb")
								local liblldb_path = joinpath(mason_codelldb_path, "lldb", "lib", "liblldb")
								if shell.is_windows() then
									codelldb_path = codelldb_path .. ".exe"
									liblldb_path = joinpath(mason_codelldb_path, "lldb", "bin", "liblldb.dll")
								else
									local suffix = shell.is_macos() and ".dylib" or ".so"
									liblldb_path = liblldb_path .. suffix
								end
								return rust_config.get_codelldb_adapter(codelldb_path, liblldb_path)
							end
						end

						if vim.fn.executable("codelldb") == 1 then
							return {
								type = "server",
								host = "127.0.0.1",
								port = "${port}",
								executable = {
									command = "codelldb",
									args = { "--port", "${port}" },
								},
							}
						end

						local has_lldb_dap = vim.fn.executable("lldb-dap") == 1
						local has_lldb_vscode = vim.fn.executable("lldb-vscode") == 1
						if not has_lldb_dap and not has_lldb_vscode then
							return false
						end

						local command = has_lldb_dap and "lldb-dap" or "lldb-vscode"
						return {
							type = "executable",
							command = command,
							args = {},
						}
					end,
				},
			}
		end,
	}, {
	'rust-lang/rust.vim',
	config = function()
		vim.g.rustfmt_autosave = 1
	end,
	ft = { 'rust' },
},

	{
		'pmizio/typescript-tools.nvim',
		ft = { 'typescript', 'typescriptreact' },
		config = function()
			require("configs.typescript-tool")
		end,
		enabled = true,
	},
	{
		"glepnir/lspsaga.nvim",
		event = 'BufRead',
		config = function()
			require("configs.lsp_saga")
		end,
	},
	{
		'hrsh7th/nvim-cmp',
		event = "InsertEnter",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer" },
		config = function()
			require("configs.cmp")
		end
	},
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	{
		'hrsh7th/cmp-nvim-lsp',
		event = 'InsertEnter'
	},
	'hrsh7th/cmp-nvim-lsp-signature-help',
	'hrsh7th/cmp-nvim-lua',
	{
		'saadparwaiz1/cmp_luasnip',
		event = 'InsertEnter'
	},
	{
		'L3MON4D3/LuaSnip',
		dependencies = { "rafamadriz/friendly-snippets" },
		event = 'InsertEnter',
		config = function()
			require("configs.lua_snip")
		end
	},
	{
		"rafamadriz/friendly-snippets",
		event = 'InsertEnter',
		pin = "true"
	},
	"lukas-reineke/lsp-format.nvim",
	{
		"SmiteshP/nvim-navic",
		config = function()
			require("configs.navic")
		end
	},

	-- 기타 언어별 설정
	'prisma/vim-prisma',
	{ 'TimUntersberger/neogit',      dependencies = 'nvim-lua/plenary.nvim' },
	{
		'rmagatti/auto-session',
		config = function()
			require("auto-session").setup {
				logplevel = "error",
				auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			}
		end
	},
	{
		"cbochs/grapple.nvim",
		opts = {
			scope = "git",
		},
		event = { "BufReadPost", "BufNewFile" },
		cmd = "Grapple",
		keys = {
			{ "<leader>gg", "<cmd>Grapple toggle<cr>",          desc = "Grapple toggle tag" },
			{ "<leader>go", "<cmd>Grapple toggle_tags<cr>",     desc = "Grapple open tags window" },
			{ "<leader>ge", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
			{ "<leader>gn", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle next tag" }
		},
	},
	{
		'wuelnerdotexe/vim-astro',
		config = function()
			vim.g.astro_typescript = 'enable'
			vim.g.astro_stylus = 'enable'
		end,
		ft = { 'astro' },
		dependencies = {
			"wavded/vim-stylus"
		}
	},
	{
		'lvimuser/lsp-inlayhints.nvim'
	},
	{
		'timtro/glslView-nvim',
		ft = 'glsl',
		config = function()
			require('glslView').setup {
				viewer_path = 'glslViewer',
				args = { '-l' },
			}
		end
	},
	{
		'sigmasd/deno-nvim',
		config = function()
			require("lspconfig").denols.setup({
				capabilities = require('cmp_nvim_lsp').default_capabilities(),
				root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
			})
		end,
		ft = "typescriptreact,typescript,javascript,javascriptreact"
	},
	-- message bar
	{
		"folke/noice.nvim",
		enabled = true,
		event = "VeryLazy",
		opts = {},
		config = function()
			require("configs.noice")
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					visual = "'",
					visual_line = "'g",
				}
			})
		end
	},
	{
		"danymat/neogen",
		config = function()
			require('neogen').setup({ snippet_engine = "luasnip" })
		end,
		version = "*",
		event = 'BufRead',
	},
	{
		"akinsho/flutter-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
		config = function()
			require('flutter-tools').setup {
				debugger = {
					enabled = false,
					run_via_dap = false,
					register_configurations = function(_)
						require("dap").adapters.dart = {
							type = "executable",
							command = vim.fn.stdpath("data") .. "/mason/bin/dart-debug-adapter",
							args = { "flutter" }
						}
						require("dap").configurations.dart = {
							{
								type = "dart",
								request = "launch",
								name = "Launch flutter",
								dartSdkPath = 'home/flutter/bin/cache/dart-sdk/',
								flutterSdkPath = "home/flutter",
								program = "${workspaceFolder}/lib/main.dart",
								cwd = "${workspaceFolder}",
							}
						}
					end,
				},
				dev_log = {
					enabled = false,
					open_cmd = "tabedit",
				},
				lsp = {
					on_attach = require("lvim.lsp").common_on_attach,
					capabilities = require("lvim.lsp").default_capabilities,
				},
			}
		end
	},
	{
		"dart-lang/dart-vim-plugin"
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		opts = {},
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"echasnovski/mini.pick",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/nvim-cmp",
			"ibhagwan/fzf-lua",
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua",
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						use_absolute_path = true,
					},
				},
			},
		}
	},
	{ "nvim-tree/nvim-web-devicons", opts = {} },
}, { defaults = { lazy = true } })
